"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.processWithdrawal = void 0;
const firestore_1 = require("firebase-functions/v2/firestore");
const v2_1 = require("firebase-functions/v2");
exports.processWithdrawal = (0, firestore_1.onDocumentWritten)({
    document: 'withdrawals/{withdrawalId}',
    region: 'europe-west1',
}, async (event) => {
    if (!event.data?.after)
        return;
    const withdrawal = event.data.after.data();
    if (withdrawal?.status !== 'pending')
        return;
    v2_1.logger.info('Withdrawal request', { withdrawalId: event.params.withdrawalId });
    // TODO: appeler API Mobile Money (MTN / Moov)
    // TODO: mettre à jour statut withdrawal → processing → completed/rejected
    // TODO: créer transaction correspondante
});
