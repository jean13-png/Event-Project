"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.sendSmsTicket = exports.sendPushNotification = void 0;
const https_1 = require("firebase-functions/v2/https");
const v2_1 = require("firebase-functions/v2");
const axios_1 = __importDefault(require("axios"));
exports.sendPushNotification = (0, https_1.onCall)({
    region: 'europe-west1',
}, async (request) => {
    const { title, body, token, data, userId } = request.data;
    v2_1.logger.info('Push notification request', { title });
    // TODO: envoyer notification FCM via Firebase Admin SDK
    // const message = { notification: { title, body }, token };
    // await admin.messaging().send(message);
    // Sauvegarder dans Firestore
    // await db.collection('notifications').add({ title, body, userId, createdAt: new Date() });
    return { success: true };
});
exports.sendSmsTicket = (0, https_1.onCall)({
    region: 'europe-west1',
}, async (request) => {
    const { phone, ticketCode, eventTitle, eventDate, eventLocation, buyerName } = request.data;
    if (!phone || !ticketCode) {
        throw new Error('Téléphone et code ticket requis');
    }
    try {
        const username = process.env.AT_USERNAME || 'sandbox';
        const apiKey = process.env.AT_API_KEY || '';
        const message = `EventBJ - Ton ticket pour ${eventTitle || 'l\'événement'}\nNom: ${buyerName || 'Acheteur'}\nCode: ${ticketCode}\n${eventDate ? 'Date: ' + eventDate + '\n' : ''}${eventLocation ? 'Lieu: ' + eventLocation + '\n' : ''}Présente ce code à l'entrée.`;
        const response = await axios_1.default.post('https://api.africastalking.com/restless/send', new URLSearchParams({
            username: username,
            message: message,
            to: phone,
            from: 'EventBJ',
        }).toString(), {
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
                'apiKey': apiKey,
            },
        });
        v2_1.logger.info('SMS envoyé', { phone, ticketCode, response: response.data });
        return { success: true, message: 'SMS envoyé', data: response.data };
    }
    catch (error) {
        v2_1.logger.error('Erreur envoi SMS', error);
        return { success: false, message: 'Échec envoi SMS', error: String(error) };
    }
});
