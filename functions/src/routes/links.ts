import { Router } from 'express';
import { getAuth } from 'firebase-admin/auth';
import { getFirestore } from 'firebase-admin/firestore';

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

router.post('/create', requireAuth, async (req: any, res: any) => {
  try {
    const { eventId, title } = req.body;

    if (!eventId || !title) {
      return res.status(400).json({ error: 'eventId et titre requis' });
    }

    const shortLink = `https://mymood.page.link/${eventId}`;
    const longLink = `https://mymood.page.link/events/${eventId}`;

    await db.collection('events').doc(eventId).update({
      shareLink: shortLink,
      updatedAt: new Date(),
    });

    return res.json({ success: true, shortLink, longLink });
  } catch (err) {
    console.error('create link error', err);
    return res.status(500).json({ error: 'Impossible de créer le lien partageable' });
  }
});

export default router;
