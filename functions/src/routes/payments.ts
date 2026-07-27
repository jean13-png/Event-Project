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

router.post('/create-session', requireAuth, async (req: any, res: any) => {
  try {
    const { eventId, ticketType, quantity, amount, buyerName, buyerPhone, organizerId, paymentMethod, reference } = req.body;

    if (!eventId || !ticketType || !quantity || !amount || !buyerName || !buyerPhone || !organizerId || !paymentMethod) {
      return res.status(400).json({ error: 'Missing fields' });
    }

    const txRef = await db.collection('transactions').add({
      userId: req.user.uid,
      type: 'credit',
      amount,
      reference,
      status: 'pending',
      createdAt: new Date(),
      metadata: { eventId, ticketType, quantity, buyerName, buyerPhone, organizerId, paymentMethod },
    });

    const checkoutUrl = `https://mymood.bj/simulate-payment?tx=${txRef.id}&ref=${reference}`;

    return res.json({ success: true, transactionId: txRef.id, reference, checkoutUrl });
  } catch (err) {
    console.error('create-session error', err);
    return res.status(500).json({ error: 'Impossible de créer la session de paiement' });
  }
});

export default router;
