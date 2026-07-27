import { Router } from 'express';
import { getAuth } from 'firebase-admin/auth';
import { getFirestore } from 'firebase-admin/firestore';
import axios from 'axios';

const router = Router();
const auth = getAuth();
const db = getFirestore();

async function requireAuth(req: any, res: any, next: any) {
  const header = req.headers.authorization || '';
  const match = header.match(/^Bearer (.+)$/);
  if (!match) {
    return res.status(401).json({ error: 'Missing Authorization header' });
  }
  try {
    const decoded = await auth.verifyIdToken(match[1]);
    req.user = decoded;
    next();
  } catch (err) {
    return res.status(401).json({ error: 'Invalid token' });
  }
}

router.get('/', requireAuth, async (req: any, res: any) => {
  try {
    const snap = await db.collection('users').doc(req.user.uid).collection('notifications').orderBy('createdAt', 'desc').limit(50).get();
    const notifications = snap.docs.map((doc: any) => ({ id: doc.id, ...doc.data() }));
    return res.json({ notifications });
  } catch (err) {
    console.error('notifications error', err);
    return res.status(500).json({ error: 'Impossible de récupérer les notifications' });
  }
});

router.post('/send-sms', requireAuth, async (req: any, res: any) => {
  try {
    const { phone, ticketCode, eventTitle, eventDate, eventLocation, buyerName } = req.body;

    if (!phone || !ticketCode) {
      return res.status(400).json({ error: 'Téléphone et code ticket requis' });
    }

    const username = process.env.AT_USERNAME || 'sandbox';
    const apiKey = process.env.AT_API_KEY || '';

    const message = `MyMood - Ton ticket pour ${eventTitle || "l'événement"}\nNom: ${buyerName || 'Acheteur'}\nCode: ${ticketCode}\n${eventDate ? 'Date: ' + eventDate + '\n' : ''}${eventLocation ? 'Lieu: ' + eventLocation + '\n' : ''}Présente ce code à l'entrée.`;

    const response = await axios.post(
      'https://api.africastalking.com/restless/send',
      new URLSearchParams({
        username,
        message,
        to: phone,
        from: 'MyMood',
      }).toString(),
      {
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          apiKey,
        },
      }
    );

    return res.json({ success: true, data: response.data });
  } catch (err) {
    console.error('sms error', err);
    return res.status(500).json({ error: "Échec d'envoi SMS" });
  }
});

export default router;
