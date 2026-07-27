"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.generateQrCode = exports.createDynamicLink = exports.sendSmsTicket = exports.sendPushNotification = exports.processWithdrawal = exports.onPaymentFailed = exports.onPaymentSuccess = exports.createPaymentSession = void 0;
const https_1 = require("firebase-functions/v2/https");
const firestore_1 = require("firebase-functions/v2/firestore");
const v2_1 = require("firebase-functions/v2");
const firestore_2 = require("firebase-admin/firestore");
const auth_1 = require("firebase-admin/auth");
const messaging_1 = require("firebase-admin/messaging");
const db = (0, firestore_2.getFirestore)();
const auth = (0, auth_1.getAuth)();
const messaging = (0, messaging_1.getMessaging)();
// ============================================
// PAYMENT FUNCTIONS
// ============================================
exports.createPaymentSession = (0, https_1.onCall)({
    region: 'europe-west1',
    timeoutSeconds: 60,
    memory: '256MiB',
}, async (request) => {
    const { eventId, ticketType, quantity, amount, buyerName, buyerPhone, organizerId, paymentMethod, reference } = request.data;
    if (!request.auth) {
        throw new Error('Non authentifié');
    }
    if (!eventId || !ticketType || !quantity || !amount || !buyerName || !buyerPhone || !organizerId || !paymentMethod) {
        throw new Error('Paramètres manquants');
    }
    try {
        // Créer une transaction en attente
        const transactionRef = await db.collection('transactions').add({
            userId: request.auth.uid,
            type: 'credit',
            amount: amount,
            reference: reference,
            status: 'pending',
            createdAt: new Date(),
            metadata: {
                eventId,
                ticketType,
                quantity,
                buyerName,
                buyerPhone,
                organizerId,
                paymentMethod,
            },
        });
        v2_1.logger.info('Transaction créée', { txId: transactionRef.id });
        // TODO: Appeler FedaPay API pour créer une session de paiement
        // Pour l'instant, retourne une URL de simulation
        const checkoutUrl = `https://eventbj.bj/simulate-payment?tx=${transactionRef.id}&ref=${reference}`;
        return {
            success: true,
            transactionId: transactionRef.id,
            reference,
            checkoutUrl,
        };
    }
    catch (error) {
        v2_1.logger.error('Erreur création session paiement', error);
        throw new Error('Impossible de créer la session de paiement');
    }
});
exports.onPaymentSuccess = (0, firestore_1.onDocumentWritten)({
    document: 'transactions/{txId}',
    region: 'europe-west1',
}, async (event) => {
    if (!event.data?.after)
        return;
    const tx = event.data.after.data();
    if (tx?.status !== 'completed')
        return;
    if (tx?.processed)
        return; // Éviter les doublons
    const txId = event.params.txId;
    const { eventId, ticketType, quantity, buyerId, buyerPhone, buyerName, organizerId } = tx.metadata || {};
    v2_1.logger.info('Paiement validé', { txId, eventId });
    try {
        // Marquer la transaction comme traitée
        await event.data.after.ref.update({
            processed: true,
            processedAt: new Date(),
        });
        // Créer les tickets
        const ticketIds = [];
        for (let i = 0; i < quantity; i++) {
            const ticketRef = await db.collection('tickets').add({
                eventId,
                buyerId: buyerId || 'guest',
                buyerPhone,
                buyerName,
                type: ticketType,
                price: tx.amount / quantity,
                qrCode: `eventbj:ticket:${eventId}:${Date.now()}:${i}`,
                status: 'active',
                purchasedAt: new Date(),
            });
            ticketIds.push(ticketRef.id);
        }
        // Créditer le wallet de l'organisateur
        const walletRef = db.collection('wallets').doc(organizerId);
        const walletSnap = await walletRef.get();
        if (!walletSnap.exists) {
            await walletRef.set({
                organizerId,
                balance: tx.amount,
                pendingBalance: 0,
                totalEarned: tx.amount,
                currency: 'XOF',
                createdAt: new Date(),
            });
        }
        else {
            await walletRef.update({
                balance: (walletSnap.data()?.balance || 0) + tx.amount,
                totalEarned: (walletSnap.data()?.totalEarned || 0) + tx.amount,
            });
        }
        // Créer une notification pour l'organisateur
        if (organizerId) {
            await db.collection('users').doc(organizerId).collection('notifications').add({
                title: 'Nouvelle vente !',
                body: `${buyerName} a acheté ${quantity} ticket(s) ${ticketType}`,
                read: false,
                createdAt: new Date(),
            });
            // Envoyer une push notification
            const organizerToken = tx.metadata?.organizerToken;
            if (organizerToken) {
                await messaging.send({
                    token: organizerToken,
                    notification: {
                        title: 'Nouvelle vente !',
                        body: `${buyerName} a acheté ${quantity} ticket(s)`,
                    },
                    data: {
                        type: 'new_sale',
                        eventId,
                        ticketIds: JSON.stringify(ticketIds),
                    },
                });
            }
        }
        // Envoyer un SMS de confirmation à l'acheteur
        // TODO: Intégrer Africa's Talking API
        v2_1.logger.info('SMS confirmation à envoyer', { phone: buyerPhone, ticketIds });
        // Envoyer une notification à l'acheteur
        if (buyerId && buyerId !== 'guest') {
            await db.collection('users').doc(buyerId).collection('notifications').add({
                title: 'Ticket confirmé !',
                body: `Ton ticket pour ${eventId} est prêt`,
                read: false,
                createdAt: new Date(),
                data: { ticketIds: JSON.stringify(ticketIds) },
            });
        }
        v2_1.logger.info('Paiement traité avec succès', { txId, ticketIds });
    }
    catch (error) {
        v2_1.logger.error('Erreur traitement paiement', error);
    }
});
exports.onPaymentFailed = (0, firestore_1.onDocumentWritten)({
    document: 'transactions/{txId}',
    region: 'europe-west1',
}, async (event) => {
    if (!event.data?.after)
        return;
    const tx = event.data.after.data();
    if (tx?.status !== 'failed')
        return;
    v2_1.logger.warn('Paiement échoué', { txId: event.params.txId });
    // TODO: Notifier l'utilisateur de l'échec
});
// ============================================
// WALLET FUNCTIONS
// ============================================
exports.processWithdrawal = (0, firestore_1.onDocumentWritten)({
    document: 'withdrawals/{withdrawalId}',
    region: 'europe-west1',
}, async (event) => {
    if (!event.data?.after)
        return;
    const withdrawal = event.data.after.data();
    if (withdrawal?.status !== 'pending')
        return;
    const withdrawalId = event.params.withdrawalId;
    const { organizerId, amount, mobileMoneyNumber, operator } = withdrawal;
    v2_1.logger.info('Traitement retrait', { withdrawalId, organizerId, amount });
    try {
        // TODO: Appeler l'API Mobile Money (MTN / Moov)
        // Pour l'instant, simulation
        // Mettre à jour le statut
        await event.data.after.ref.update({
            status: 'processing',
            processedAt: new Date(),
        });
        // Créer la transaction correspondante
        await db.collection('transactions').add({
            userId: organizerId,
            type: 'debit',
            amount: amount,
            reference: `withdrawal_${withdrawalId}`,
            status: 'completed',
            createdAt: new Date(),
            metadata: {
                withdrawalId,
                mobileMoneyNumber,
                operator,
            },
        });
        // Mettre à jour le wallet
        const walletRef = db.collection('wallets').doc(organizerId);
        const walletSnap = await walletRef.get();
        if (walletSnap.exists) {
            await walletRef.update({
                balance: Math.max(0, (walletSnap.data()?.balance || 0) - amount),
            });
        }
        // Marquer comme complété
        await event.data.after.ref.update({
            status: 'completed',
            completedAt: new Date(),
        });
        // Notifier l'organisateur
        await db.collection('users').doc(organizerId).collection('notifications').add({
            title: 'Retrait effectué',
            body: `Ton retrait de ${amount} FCFA a été envoyé vers ${mobileMoneyNumber}`,
            read: false,
            createdAt: new Date(),
        });
        v2_1.logger.info('Retrait traité', { withdrawalId });
    }
    catch (error) {
        v2_1.logger.error('Erreur traitement retrait', error);
        await event.data.after.ref.update({
            status: 'failed',
            error: String(error),
        });
    }
});
// ============================================
// NOTIFICATION FUNCTIONS
// ============================================
exports.sendPushNotification = (0, https_1.onCall)({
    region: 'europe-west1',
    timeoutSeconds: 30,
}, async (request) => {
    const { title, body, token, data, userId } = request.data;
    if (!request.auth && !token) {
        throw new Error('Non authentifié ou token manquant');
    }
    try {
        const payload = {
            notification: { title, body },
            data: data || {},
        };
        if (token) {
            payload.token = token;
        }
        else if (userId) {
            const userTokens = await db.collection('users').doc(userId).collection('tokens').get();
            payload.tokens = userTokens.docs.map((doc) => doc.id);
        }
        const response = await messaging.sendMulticast({
            tokens: payload.tokens || [payload.token],
            notification: payload.notification,
            data: payload.data,
        });
        v2_1.logger.info('Notifications envoyées', { successCount: response.successCount });
        return { success: true, sent: response.successCount };
    }
    catch (error) {
        v2_1.logger.error('Erreur envoi notification', error);
        throw new Error('Impossible d\'envoyer la notification');
    }
});
exports.sendSmsTicket = (0, https_1.onCall)({
    region: 'europe-west1',
    timeoutSeconds: 30,
}, async (request) => {
    const { phone, ticketCode, eventTitle, eventDate, eventLocation } = request.data;
    if (!phone || !ticketCode) {
        throw new Error('Téléphone et code ticket requis');
    }
    try {
        // TODO: Intégrer Africa's Talking API
        // const message = `EventBJ - Ton ticket pour ${eventTitle}\nDate: ${eventDate}\nLieu: ${eventLocation}\nCode: ${ticketCode}\nPrésente ce code à l'entrée.`;
        // await axios.post('https://api.africastalking.com/restless/send', ...);
        v2_1.logger.info('SMS à envoyer', { phone, ticketCode });
        return { success: true, message: 'SMS envoyé (simulation)' };
    }
    catch (error) {
        v2_1.logger.error('Erreur envoi SMS', error);
        throw new Error('Impossible d\'envoyer le SMS');
    }
});
// ============================================
// HELPER FUNCTIONS
// ============================================
// ============================================
// DYNAMIC LINKS
// ============================================
exports.createDynamicLink = (0, https_1.onCall)({
    region: 'europe-west1',
    timeoutSeconds: 30,
}, async (request) => {
    const { eventId, title, category, city } = request.data;
    if (!eventId || !title) {
        throw new Error('eventId et titre requis');
    }
    try {
        const link = `https://eventbj.page.link/events/${eventId}`;
        // TODO: Appeler Firebase Dynamic Links REST API pour créer un lien court
        // POST https://firebasedynamiclinks.googleapis.com/v1/shortLinks?key=API_KEY
        // Body: { "dynamicLinkInfo": { "domainUriPrefix": "https://eventbj.page.link", "link": link } }
        const shortLink = `https://eventbj.page.link/${eventId}`;
        // Mettre à jour l'événement avec le lien
        if (request.auth) {
            await db.collection('events').doc(eventId).update({
                shareLink: shortLink,
                updatedAt: new Date(),
            });
        }
        v2_1.logger.info('Dynamic link créé', { eventId, shortLink });
        return { success: true, shortLink, longLink: link };
    }
    catch (error) {
        v2_1.logger.error('Erreur création dynamic link', error);
        throw new Error('Impossible de créer le lien partageable');
    }
});
exports.generateQrCode = (0, https_1.onCall)({
    region: 'europe-west1',
}, async (request) => {
    const { ticketId, eventId, buyerName, ticketType } = request.data;
    const qrData = JSON.stringify({
        ticketId,
        eventId,
        buyerName,
        ticketType,
        timestamp: Date.now(),
    });
    // TODO: Générer un QR code image et uploader sur Cloud Storage
    // Pour l'instant, retourne les données brutes
    return {
        qrCode: qrData,
        imageUrl: `https://storage.googleapis.com/eventbj-tickets/qr/${ticketId}.png`,
    };
});
