import { onCall } from 'firebase-functions/v2/https';
import { logger } from 'firebase-functions/v2';
import axios from 'axios';

export const sendPushNotification = onCall(
  {
    region: 'europe-west1',
  },
  async (request) => {
    const { title, body, token, data, userId } = request.data;

    logger.info('Push notification request', { title });

    // TODO: envoyer notification FCM via Firebase Admin SDK
    // const message = { notification: { title, body }, token };
    // await admin.messaging().send(message);

    // Sauvegarder dans Firestore
    // await db.collection('notifications').add({ title, body, userId, createdAt: new Date() });

    return { success: true };
  }
);

export const sendSmsTicket = onCall(
  {
    region: 'europe-west1',
  },
  async (request) => {
    const { phone, ticketCode, eventTitle, eventDate, eventLocation, buyerName } = request.data;

    if (!phone || !ticketCode) {
      throw new Error('Téléphone et code ticket requis');
    }

    try {
      const username = process.env.AT_USERNAME || 'sandbox';
      const apiKey = process.env.AT_API_KEY || '';

      const message = `MyMood - Ton ticket pour ${eventTitle || 'l\'événement'}\nNom: ${buyerName || 'Acheteur'}\nCode: ${ticketCode}\n${eventDate ? 'Date: ' + eventDate + '\n' : ''}${eventLocation ? 'Lieu: ' + eventLocation + '\n' : ''}Présente ce code à l'entrée.`;

      const response = await axios.post(
        'https://api.africastalking.com/restless/send',
        new URLSearchParams({
          username: username,
          message: message,
          to: phone,
          from: 'MyMood',
        }).toString(),
        {
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'apiKey': apiKey,
          },
        }
      );

      logger.info('SMS envoyé', { phone, ticketCode, response: response.data });

      return { success: true, message: 'SMS envoyé', data: response.data };
    } catch (error) {
      logger.error('Erreur envoi SMS', error);
      return { success: false, message: 'Échec envoi SMS', error: String(error) };
    }
  }
);
