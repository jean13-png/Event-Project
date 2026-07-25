<<<<<<< HEAD
# EventBJ

Application mobile Flutter + Firebase pour découvrir les événements au Bénin et acheter des tickets via Mobile Money.

## Stack

- Flutter (Android, iOS, Web admin)
- Firebase (Auth, Firestore, FCM, Cloud Functions, Storage)
- State management : Riverpod
- Navigation : go_router

## Démarrage

```bash
flutter pub get
flutter run
```

## Firebase

Projet : `event-project-e6868`  
Config générée : `lib/core/firebase/firebase_options.dart`  
Init dans `lib/main.dart` via `Firebase.initializeApp`.

Dans la console Firebase, activer au minimum :
- Authentication (Phone + Google)
- Cloud Firestore
- Storage
- Cloud Messaging
- Functions (quand on branchera FedaPay)

## Équipe

| Dev | Modules |
|-----|---------|
| **Jean** | Auth, page événement publique, paiement, wallet, notifications, navigation, admin |
| **Épiphane** | Home, explore, organisateur, scanner, carte, profil, widgets partagés |

Voir `INSTRUCTIONS_JEAN.md` et `INSTRUCTIONS_EPIPHANE.md`.

## Design

Source de vérité visuelle : `DESIGN.md`.
=======
# eventbj

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
>>>>>>> epiphane/init
