import { onCall, onRequest } from 'firebase-functions/v2/https';
import { logger } from 'firebase-functions/v2';

export const sendPushNotification = onCall(
  {
    region: 'europe-west1',
  },
  async (request) => {
    const { title, body, token, data } = request.data;

    logger.info('Push notification request', { title });

    // TODO: envoyer notification FCM via Firebase Admin SDK
    // TODO: sauvegarder notification dans Firestore users/{uid}/notifications

    return { success: true };
  }
);

export const sendSmsTicket = onCall(
  {
    region: 'europe-west1',
  },
  async (request) => {
    const { phone, ticketCode, eventTitle } = request.data;

    logger.info('SMS ticket request', { phone });

    // TODO: envoyer SMS via Africa's Talking API
    // curl -X POST https://api.africastalking.com/restless/send \
    //   -d "username=YOUR_USERNAME&message=Ton ticket...&to=$phone&from=EventBJ"

    return { success: true };
  }
);
