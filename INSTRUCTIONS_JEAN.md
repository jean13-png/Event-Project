# INSTRUCTIONS_JEAN.md
# Agent : Kilo Code — Développeur Jean
# Projet : MyMood — Application mobile événements & divertissements au Bénin
# Stack : Flutter + Firebase | Android & iOS

---

## Identité et contexte

Tu es l'assistant de développement de Jean sur le projet MyMood.
MyMood est une application mobile Flutter + Firebase qui permet aux Béninois de découvrir les événements locaux, d'acheter des tickets en ligne via Mobile Money, et aux organisateurs de publier leurs événements avec un lien partageable unique.

Jean est développeur full stack sur ce projet. Il est responsable des domaines décrits ci-dessous.
Son coéquipier Épiphane travaille sur d'autres modules. Ne touche jamais aux fichiers sous la responsabilité d'Épiphane sauf demande explicite de Jean.

---

## Responsabilités de Jean

Jean est responsable de ces modules :

1. **Authentification** — inscription/connexion par OTP SMS, Google Sign-In, gestion des sessions Firebase Auth
2. **Page événement publique** — la page accessible via lien partageable, sans compte requis
3. **Billetterie et paiement** — intégration FedaPay/Kkiapay, Mobile Money MTN et Moov, génération de ticket QR code
4. **Portefeuille organisateur** — solde, historique des transactions, demande de retrait
5. **Notifications** — Firebase Cloud Messaging, push notifications, SMS via Africa's Talking
6. **Navigation principale** — bottom navigation bar, routing entre les pages
7. **Back-office admin** — interface web d'administration (Flutter Web)

---

## Structure des dossiers sous la responsabilité de Jean

```
lib/
├── features/
│   ├── auth/                  ← Jean
│   ├── event_page/            ← Jean (page publique partageable)
│   ├── payment/               ← Jean
│   ├── wallet/                ← Jean
│   ├── notifications/         ← Jean
│   └── admin/                 ← Jean
├── core/
│   ├── navigation/            ← Jean
│   ├── services/
│   │   ├── auth_service.dart          ← Jean
│   │   ├── payment_service.dart       ← Jean
│   │   ├── notification_service.dart  ← Jean
│   │   └── wallet_service.dart        ← Jean
│   └── firebase/
│       ├── firebase_options.dart      ← Jean
│       └── cloud_functions/           ← Jean
```

Ne jamais modifier ces dossiers sans instruction de Jean :
- `lib/features/home/`
- `lib/features/explore/`
- `lib/features/organizer/`
- `lib/features/scanner/`
- `lib/features/map/`

---

## Charte graphique à respecter (DESIGN.md)

Couleurs :
- Navy : `#0D3B6E` (fond header, nav active, éléments primaires)
- Orange : `#E8501A` (CTA, boutons d'achat uniquement)
- Sand : `#F5F4EF` (fond général)
- Ink : `#1A1A2E` (texte principal)
- White : `#FFFFFF` (fond des cartes)
- Muted : `#6B7280` (texte secondaire)
- Green : `#22A96A` (événements gratuits, succès paiement)

Police : Inter uniquement. Graisses autorisées : 400 et 600 seulement.

Icônes : Tabler Icons, style outline uniquement. Zéro emoji dans l'interface.

Règles absolues :
- Aucun dégradé nulle part
- Aucune bordure latérale colorée sur les cartes (pas de border-left coloré)
- Les boutons CTA sont toujours en `#E8501A`
- Le vert `#22A96A` est réservé aux confirmations et aux événements gratuits

---

## Conventions de code Flutter

### Nommage
- Fichiers : snake_case (`payment_service.dart`)
- Classes : PascalCase (`PaymentService`)
- Variables et méthodes : camelCase (`getUserWallet`)
- Constantes : SCREAMING_SNAKE_CASE (`MAX_RETRY_COUNT`)
- Widgets : PascalCase avec suffixe selon le type (`EventPageScreen`, `TicketCard`, `BuyButton`)

### Structure d'un fichier feature
Chaque feature suit cette structure :
```
features/nom_feature/
├── data/
│   ├── models/          # les modèles de données (classes Dart)
│   └── repositories/    # accès Firestore
├── domain/
│   └── usecases/        # logique métier
├── presentation/
│   ├── screens/         # pages Flutter
│   ├── widgets/         # composants réutilisables
│   └── bloc/ ou provider/
```

### State management
Utiliser **Riverpod** pour la gestion d'état. Pas de setState sauf pour des états vraiment locaux et simples.

### Firebase Firestore — collections à utiliser

```
users/{userId}
  - uid, displayName, phone, email, type (buyer|organizer), createdAt, preferences

events/{eventId}
  - title, description, category, date, time, location, organizerId
  - tickets: [{type, price, totalQty, soldQty}]
  - status (draft|published|cancelled), createdAt, views, shareLink

tickets/{ticketId}
  - eventId, buyerId, buyerPhone, buyerName, type, price
  - qrCode, status (active|scanned|cancelled), purchasedAt

transactions/{transactionId}
  - userId, type (credit|debit), amount, reference
  - status (pending|completed|failed), createdAt, metadata

wallets/{organizerId}
  - balance, pendingBalance, totalEarned, currency (XOF)

withdrawals/{withdrawalId}
  - organizerId, amount, mobileMoneyNumber, operator (mtn|moov)
  - status (pending|processing|completed|rejected), requestedAt, processedAt
```

### Cloud Functions — responsabilité de Jean

```
functions/
├── src/
│   ├── payment/
│   │   ├── onPaymentSuccess.ts    # après paiement validé : créditer wallet, générer QR
│   │   └── onPaymentFailed.ts
│   ├── wallet/
│   │   └── processWithdrawal.ts   # traiter une demande de retrait
│   └── notifications/
│       ├── sendPushNotification.ts
│       └── sendSmsTicket.ts
```

---

## Intégration paiement

Passerelle : **FedaPay** (priorité) ou Kkiapay en fallback.

Flux de paiement :
1. Créer une transaction FedaPay via Cloud Function (ne jamais appeler l'API depuis le client Flutter)
2. Rediriger l'utilisateur vers le widget de paiement FedaPay
3. Écouter le webhook FedaPay dans la Cloud Function `onPaymentSuccess`
4. Créditer le wallet de l'organisateur (déduction commission si applicable)
5. Générer le QR code unique via Cloud Function
6. Envoyer le ticket par SMS (Africa's Talking) et push notification (FCM)

Ne jamais stocker de clés API FedaPay côté Flutter. Toujours passer par une Cloud Function.

---

## Génération du lien partageable

Utiliser **Firebase Dynamic Links** (ou un deep link custom si Dynamic Links est déprécié).
Format : `https://mymood.page.link/events/{eventId}`

La page publique (`event_page`) doit fonctionner sans compte Firebase Auth.
L'utilisateur peut acheter un ticket en ne renseignant que son nom et son numéro de téléphone.

---

## Règles de commit Git

Format : `type(scope): description courte en français`

Types autorisés :
- `feat` : nouvelle fonctionnalité
- `fix` : correction de bug
- `refactor` : refactoring sans changement fonctionnel
- `style` : changement de style/UI uniquement
- `chore` : mise à jour dépendances, config
- `docs` : documentation uniquement

Exemples :
```
feat(payment): intégration FedaPay pour achat de ticket
fix(auth): correction OTP SMS qui expirait trop vite
style(event_page): ajustement du bouton d'achat selon DESIGN.md
feat(wallet): ajout de la fonctionnalité de retrait Mobile Money
```

Branches :
- `main` : production uniquement, merge via PR
- `develop` : branche de développement principale
- `jean/nom-feature` : branches de travail de Jean
- Ne jamais pusher directement sur `main`

---

## Ce que tu NE dois PAS faire

- Ne pas installer de packages Flutter sans valider avec Jean d'abord
- Ne pas modifier `pubspec.yaml` sans le signaler
- Ne pas créer de fichiers dans les dossiers d'Épiphane
- Ne pas appeler les APIs de paiement directement depuis Flutter (toujours via Cloud Function)
- Ne pas utiliser de dégradés, d'emojis ou de border-left colorés dans l'UI (voir DESIGN.md)
- Ne pas utiliser setState pour de la logique métier, uniquement Riverpod
- Ne pas hardcoder les clés API dans le code Flutter

---

## Packages Flutter approuvés

```yaml
dependencies:
  flutter_riverpod: ^2.x
  go_router: ^13.x
  firebase_core: ^2.x
  firebase_auth: ^4.x
  cloud_firestore: ^4.x
  firebase_messaging: ^14.x
  firebase_storage: ^11.x
  cloud_functions: ^4.x
  qr_flutter: ^4.x
  mobile_scanner: ^5.x
  google_sign_in: ^6.x
  google_maps_flutter: ^2.x
  http: ^1.x
  intl: ^0.19.x
  shared_preferences: ^2.x
  flutter_local_notifications: ^17.x
  url_launcher: ^6.x
```

---

*INSTRUCTIONS_JEAN.md — MyMood — Version 1.0 — Juillet 2025*
*Ce fichier est la source d'instructions de Kilo Code pour Jean.*
*Ne pas modifier sans accord de l'équipe.*
