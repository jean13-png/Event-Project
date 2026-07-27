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

router.get('/', requireAuth, async (req: any, res: any) => {
  try {
    const snap = await db.collection('wallets').doc(req.user.uid).get();
    const data = snap.exists ? snap.data() : { balance: 0, pendingBalance: 0 };
    return res.json({ organizerId: req.user.uid, ...data });
  } catch (err) {
    console.error('wallet error', err);
    return res.status(500).json({ error: 'Impossible de récupérer le portefeuille' });
  }
});

router.post('/withdraw', requireAuth, async (req: any, res: any) => {
  try {
    const { amount, mobileMoneyNumber, operator } = req.body;

    if (!amount || !mobileMoneyNumber || !operator) {
      return res.status(400).json({ error: 'Montant, numéro et opérateur requis' });
    }

    const withdrawalRef = await db.collection('withdrawals').add({
      organizerId: req.user.uid,
      amount,
      mobileMoneyNumber,
      operator,
      status: 'pending',
      requestedAt: new Date(),
    });

    return res.json({ success: true, withdrawalId: withdrawalRef.id, status: 'pending' });
  } catch (err) {
    console.error('withdraw error', err);
    return res.status(500).json({ error: 'Impossible de créer la demande de retrait' });
  }
});

export default router;
