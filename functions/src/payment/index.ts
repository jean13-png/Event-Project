import { onDocumentWritten } from 'firebase-functions/v2/firestore';
import { logger } from 'firebase-functions/v2';

export const onPaymentSuccess = onDocumentWritten(
  {
    document: 'transactions/{txId}',
    region: 'europe-west1',
  },
  async (event) => {
    if (!event.data?.after) return;
    const tx = event.data.after.data();

    if (tx?.status !== 'completed') return;

    logger.info('Payment success', { txId: event.params.txId });

    // TODO: créditer wallet organisateur
    // TODO: générer QR code ticket via Cloud Function
    // TODO: envoyer SMS confirmation via Africa's Talking
    // TODO: envoyer push notification FCM
  }
);

export const onPaymentFailed = onDocumentWritten(
  {
    document: 'transactions/{txId}',
    region: 'europe-west1',
  },
  async (event) => {
    if (!event.data?.after) return;
    const tx = event.data.after.data();

    if (tx?.status !== 'failed') return;

    logger.warn('Payment failed', { txId: event.params.txId });

    // TODO: notifier utilisateur de l'échec
  }
);
