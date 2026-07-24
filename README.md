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

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

Puis décommenter l'init Firebase dans `lib/main.dart`.

## Équipe

| Dev | Modules |
|-----|---------|
| **Jean** | Auth, page événement publique, paiement, wallet, notifications, navigation, admin |
| **Épiphane** | Home, explore, organisateur, scanner, carte, profil, widgets partagés |

Voir `INSTRUCTIONS_JEAN.md` et `INSTRUCTIONS_EPIPHANE.md`.

## Design

Source de vérité visuelle : `DESIGN.md`.
