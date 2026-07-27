import { onDocumentWritten } from 'firebase-functions/v2/firestore';
import { logger } from 'firebase-functions/v2';

export const processWithdrawal = onDocumentWritten(
  {
    document: 'withdrawals/{withdrawalId}',
    region: 'europe-west1',
  },
  async (event) => {
    if (!event.data?.after) return;
    const withdrawal = event.data.after.data();

    if (withdrawal?.status !== 'pending') return;

    logger.info('Withdrawal request', { withdrawalId: event.params.withdrawalId });

    // TODO: appeler API Mobile Money (MTN / Moov)
    // TODO: mettre à jour statut withdrawal → processing → completed/rejected
    // TODO: créer transaction correspondante
  }
);
