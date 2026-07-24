# INSTRUCTIONS_EPIPHANE.md
# Agent : Kilo Code — Développeur Épiphane
# Projet : EventBJ — Application mobile événements & divertissements au Bénin
# Stack : Flutter + Firebase | Android & iOS

---

## Identité et contexte

Tu es l'assistant de développement d'Épiphane sur le projet EventBJ.
EventBJ est une application mobile Flutter + Firebase qui permet aux Béninois de découvrir les événements locaux, d'acheter des tickets en ligne via Mobile Money, et aux organisateurs de publier leurs événements avec un lien partageable unique.

Épiphane est développeur full stack sur ce projet. Il est responsable des domaines décrits ci-dessous.
Son coéquipier Jean travaille sur d'autres modules. Ne touche jamais aux fichiers sous la responsabilité de Jean sauf demande explicite d'Épiphane.

---

## Responsabilités d'Épiphane

Épiphane est responsable de ces modules :

1. **Accueil et découverte** — fil d'actualité, sections "Ce soir", "À la une", "Prochainement"
2. **Explorer** — recherche, filtres par catégorie/ville/date/prix, résultats
3. **Espace organisateur** — création/édition d'événement, tableau de bord des ventes, liste des participants, export CSV
4. **Scanner QR code** — scan à l'entrée, validation des tickets, mode hors ligne
5. **Carte et géolocalisation** — carte interactive des événements, filtres de rayon
6. **Profil utilisateur** — paramètres, historique, favoris, suivi des organisateurs
7. **Firestore Data Layer partagé** — modèles de données (en coordination avec Jean)

---

## Structure des dossiers sous la responsabilité d'Épiphane

```
lib/
├── features/
│   ├── home/                  ← Épiphane
│   ├── explore/               ← Épiphane
│   ├── organizer/             ← Épiphane
│   │   ├── create_event/
│   │   ├── dashboard/
│   │   └── participants/
│   ├── scanner/               ← Épiphane
│   ├── map/                   ← Épiphane
│   └── profile/               ← Épiphane
├── core/
│   ├── services/
│   │   ├── event_service.dart         ← Épiphane
│   │   ├── organizer_service.dart     ← Épiphane
│   │   ├── scanner_service.dart       ← Épiphane
│   │   └── location_service.dart      ← Épiphane
│   └── shared/
│       ├── widgets/                   ← Épiphane (composants partagés UI)
│       └── models/                    ← Épiphane (en coordination avec Jean)
```

Ne jamais modifier ces dossiers sans instruction d'Épiphane :
- `lib/features/auth/`
- `lib/features/event_page/`
- `lib/features/payment/`
- `lib/features/wallet/`
- `lib/features/notifications/`
- `lib/features/admin/`
- `lib/core/firebase/cloud_functions/`

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
- Les cartes ont toujours fond `#FFFFFF`, border-radius 16px
- La bulle déco des cartes : cercle `rgba(13,59,110,0.04)` 80px, positionné en bas-droite hors bord

### Composants UI à réutiliser (définis dans `core/shared/widgets/`)

```dart
// Composants qu'Épiphane doit créer et maintenir
EventCard          // carte standard de liste
HeroCard           // grande carte pour "À la une"
CategoryPill       // pill de catégorie (actif/inactif)
SectionHeader      // titre de section + lien "Voir tout"
PriceTag           // affichage du prix (orange ou vert)
EventDetailMeta    // ligne d'info (icône + texte : date, lieu)
```

---

## Conventions de code Flutter

### Nommage
- Fichiers : snake_case (`event_service.dart`)
- Classes : PascalCase (`EventService`)
- Variables et méthodes : camelCase (`getUpcomingEvents`)
- Constantes : SCREAMING_SNAKE_CASE (`MAX_EVENTS_PER_PAGE`)
- Widgets : PascalCase avec suffixe selon le type (`HomeScreen`, `EventCard`, `CategoryPill`)

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
│   ├── widgets/         # composants spécifiques à la feature
│   └── providers/       # Riverpod providers
```

### State management
Utiliser **Riverpod** pour la gestion d'état. Pas de setState sauf pour des états vraiment locaux et simples (ex : toggle d'un champ de formulaire).

---

## Firebase Firestore — collections à lire/écrire

Épiphane lit et écrit principalement sur ces collections :

```
events/{eventId}              ← lecture (affichage) + écriture (création/édition par organisateur)
  - title, description, category, date, time, location
  - organizerId, tickets[], status, views, shareLink, createdAt

tickets/{ticketId}            ← lecture (scanner, liste participants)
  - eventId, buyerName, buyerPhone, type, qrCode, status, purchasedAt

users/{userId}                ← lecture/écriture (profil, préférences, favoris)
  - displayName, phone, type, preferences, savedEvents[], followedOrganizers[]
```

Épiphane ne doit pas écrire sur ces collections (responsabilité de Jean) :
- `transactions/`
- `wallets/`
- `withdrawals/`

---

## Fonctionnalités clés à implémenter

### 1. Fil d'actualité (HomeScreen)

Trois sections à charger depuis Firestore :
- "À la une" : les 5 événements avec le plus de vues, status `published`, date future
- "Ce soir" : événements du jour courant, triés par heure
- "Prochainement" : les 20 prochains événements, triés par date

Pagination : utiliser `startAfterDocument` Firestore pour le scroll infini sur "Prochainement".

### 2. Création d'événement (OrganizerCreateEventScreen)

Formulaire en plusieurs étapes (stepper) :
- Étape 1 : Informations de base (titre, catégorie, description)
- Étape 2 : Date, heure, lieu (avec sélection sur carte Google Maps)
- Étape 3 : Upload affiche (Firebase Storage) + photos supplémentaires
- Étape 4 : Configuration des tickets (types, prix, quantités)
- Étape 5 : Prévisualisation + publication

Après publication, appeler la Cloud Function `generateShareLink` (responsabilité Jean) pour obtenir le lien partageable et l'afficher avec bouton de partage.

### 3. Scanner QR code (ScannerScreen)

Utiliser le package `mobile_scanner`.
À chaque scan, interroger Firestore sur la collection `tickets` avec le contenu du QR code.
Afficher le résultat :
- Ticket valide et non scanné : fond vert + nom de l'acheteur + type de ticket
- Ticket déjà scanné : fond orange + heure du premier scan
- Ticket invalide : fond rouge + message d'erreur

Mode hors ligne : pré-charger la liste des tickets de l'événement en cours dans SharedPreferences avant le début de l'événement.

### 4. Tableau de bord organisateur (OrganizerDashboardScreen)

Données à afficher en temps réel (Firestore stream) :
- Total tickets vendus
- Chiffre d'affaires total (déléguer le solde à Jean via le wallet)
- Courbe des ventes (graphique simple par jour)
- Liste des 10 dernières ventes
- Bouton export CSV des participants

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
feat(home): implémentation du fil d'actualité avec les 3 sections
fix(scanner): correction du mode hors ligne qui ne chargeait pas les tickets
style(event_card): ajustement de la bulle déco selon DESIGN.md
feat(organizer): formulaire de création d'événement en 5 étapes
feat(map): carte interactive des événements avec filtres de rayon
```

Branches :
- `main` : production uniquement, merge via PR
- `develop` : branche de développement principale
- `epiphane/nom-feature` : branches de travail d'Épiphane
- Ne jamais pusher directement sur `main`

---

## Coordination avec Jean

Ces points nécessitent une coordination entre Épiphane et Jean :

| Sujet | Action |
|---|---|
| Nouveau champ dans un modèle Firestore | Valider avec Jean avant de modifier |
| Nouveau composant dans `core/shared/widgets/` | Notifier Jean pour qu'il puisse l'utiliser |
| Besoin d'une Cloud Function | Ouvrir une issue GitHub et assigner à Jean |
| Changement dans `pubspec.yaml` | Toujours valider avec les deux avant de merger |

---

## Ce que tu NE dois PAS faire

- Ne pas installer de packages Flutter sans valider avec Épiphane d'abord
- Ne pas modifier `pubspec.yaml` sans le signaler
- Ne pas créer de fichiers dans les dossiers de Jean
- Ne pas écrire dans les collections Firestore `transactions/`, `wallets/`, `withdrawals/`
- Ne pas utiliser de dégradés, d'emojis ou de border-left colorés dans l'UI (voir DESIGN.md)
- Ne pas utiliser setState pour de la logique métier, uniquement Riverpod
- Ne pas appeler les APIs de paiement depuis Flutter (c'est le rôle de Jean via Cloud Functions)

---

## Packages Flutter approuvés

```yaml
dependencies:
  flutter_riverpod: ^2.x
  go_router: ^13.x
  firebase_core: ^2.x
  cloud_firestore: ^4.x
  firebase_storage: ^11.x
  mobile_scanner: ^5.x
  google_maps_flutter: ^2.x
  image_picker: ^1.x
  intl: ^0.19.x
  shared_preferences: ^2.x
  csv: ^6.x
  fl_chart: ^0.68.x
  share_plus: ^9.x
  cached_network_image: ^3.x
  shimmer: ^3.x
  url_launcher: ^6.x
```

---

*INSTRUCTIONS_EPIPHANE.md — EventBJ — Version 1.0 — Juillet 2025*
*Ce fichier est la source d'instructions de Kilo Code pour Épiphane.*
*Ne pas modifier sans accord de l'équipe.*
