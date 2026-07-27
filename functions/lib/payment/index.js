"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.onPaymentFailed = exports.onPaymentSuccess = void 0;
const firestore_1 = require("firebase-functions/v2/firestore");
const v2_1 = require("firebase-functions/v2");
exports.onPaymentSuccess = (0, firestore_1.onDocumentWritten)({
    document: 'transactions/{txId}',
    region: 'europe-west1',
}, async (event) => {
    if (!event.data?.after)
        return;
    const tx = event.data.after.data();
    if (tx?.status !== 'completed')
        return;
    v2_1.logger.info('Payment success', { txId: event.params.txId });
    // TODO: créditer wallet organisateur
    // TODO: générer QR code ticket via Cloud Function
    // TODO: envoyer SMS confirmation via Africa's Talking
    // TODO: envoyer push notification FCM
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
    v2_1.logger.warn('Payment failed', { txId: event.params.txId });
    // TODO: notifier utilisateur de l'échec
});
