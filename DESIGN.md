# DESIGN.md — MyMood

Référence de design de l'application mobile MyMood.  
Ce document est la source de vérité pour toute décision visuelle sur le projet.  
Stack : Flutter + Firebase — Android & iOS.

---

## 1. Identité visuelle

### Nom et positionnement

**MyMood** — L'agenda événementiel du Bénin.

L'application se positionne comme une référence sérieuse, locale et accessible. Le design doit inspirer confiance, refléter la vivacité de la scène événementielle béninoise, et rester très lisible sur les écrans d'entrée de gamme courants au Bénin.

### Logo

L'icône du logo est un carré aux coins arrondis (border-radius 9px) en couleur `--orange`, contenant l'icône `calendar-event` (Tabler Icons outline) en blanc. Le nom "MyMood" s'affiche à droite, en Inter 600, couleur blanche sur fond sombre ou `--navy` sur fond clair.

```
[ 🗓 ]  MyMood
```

---

## 2. Palette de couleurs

Quatre couleurs principales, aucune couleur décorative supplémentaire sans validation.

| Nom | Variable | Hex | Usage |
|---|---|---|---|
| Nuit Béninoise | `--navy` | `#0D3B6E` | Header, nav active, éléments primaires |
| Feu de Lagune | `--orange` | `#E8501A` | CTA, boutons d'achat, badges actifs |
| Sable clair | `--sand` | `#F5F4EF` | Fond général de l'application |
| Encre | `--ink` | `#1A1A2E` | Texte principal |
| Blanc | `--white` | `#FFFFFF` | Surface des cartes |
| Gris muted | `--muted` | `#6B7280` | Texte secondaire, placeholders |
| Confirmation | `--green` | `#22A96A` | Événements gratuits, succès paiement |

### Règles d'utilisation des couleurs

`--orange` est réservé exclusivement aux boutons d'action (acheter, réserver, publier) et aux badges de catégorie actifs. Il ne doit jamais être utilisé comme fond de section ou couleur décorative.

`--navy` habille le header, la navigation active et les éléments de structure. Sur fond `--navy`, le texte est toujours blanc.

`--green` apparaît uniquement pour signaler la gratuité d'un événement ou la confirmation d'un paiement réussi. Il n'est pas une couleur décorative.

Aucun dégradé nulle part dans l'application.

---

## 3. Typographie

Police unique : **Inter** (Google Fonts).  
Deux graisses utilisées : 400 (regular) et 600 (semi-bold). Pas de 700 ni de 300.

| Rôle | Taille | Graisse | Couleur par défaut |
|---|---|---|---|
| Titre principal (H1) | 20px | 600 | `--ink` |
| Titre secondaire (H2) | 16px | 600 | `--ink` |
| Titre de carte | 14–15px | 600 | `--ink` |
| Corps de texte | 14px | 400 | `--ink` |
| Texte secondaire | 12px | 400 | `--muted` |
| Label / caption | 11px | 500 | `--muted` |
| Prix | 13–15px | 600 | `--orange` ou `--green` |

Espacement de ligne (line-height) : 1.3 pour les titres, 1.5 pour le corps de texte.  
Letter-spacing : -0.3px sur les titres de 16px et au-delà pour resserrer légèrement.

---

## 4. Iconographie

Toutes les icônes proviennent de **Tabler Icons**, style **outline uniquement**.  
Aucun emoji dans l'interface. Les icônes sont les seuls éléments visuels symboliques.

| Contexte | Taille |
|---|---|
| Navigation principale (bottom nav) | 20px |
| Actions dans les cartes | 16–18px |
| Icônes illustratives dans les vignettes | 28px |
| Icônes de statut / meta | 12–13px |

Icônes de référence par fonctionnalité :

| Fonctionnalité | Icône Tabler |
|---|---|
| Accueil | `ti-home` |
| Explorer / Recherche | `ti-search` |
| Carte | `ti-map-pin` |
| Mes billets | `ti-ticket` |
| Profil | `ti-user-circle` |
| Filtres | `ti-adjustments-horizontal` |
| Notifications | `ti-bell` |
| Partager | `ti-share` |
| Portefeuille | `ti-wallet` |
| QR Code | `ti-qrcode` |
| Calendrier | `ti-calendar` |
| Statistiques | `ti-chart-bar` |
| Concert | `ti-music` |
| Soirée | `ti-moon-stars` |
| Sport | `ti-trophy` |
| Culture | `ti-palette` |
| Gastronomie | `ti-tools-kitchen-2` |
| Formation | `ti-microphone-2` |
| Heure | `ti-clock` |
| Participants | `ti-users` |

---

## 5. Rayon et surfaces

### Border radius

| Élément | Valeur |
|---|---|
| Boutons principaux | 8px |
| Cartes standard | 16px |
| Grandes cartes (hero) | 22px |
| Pills / badges | 30px (pill complet) |
| Icônes dans les vignettes | 12px |
| Icônes de navigation | 12px |
| Logo icon | 9px |

### Surfaces

Les cartes utilisent `#FFFFFF` comme fond, jamais `--sand`. Le fond sable `--sand` est réservé au fond général de l'application pour créer une séparation visuelle naturelle entre les cartes et l'arrière-plan.

Ombres : légères, jamais lourdes. Une seule ombre admise sur les cartes : `box-shadow: 0 4px 20px rgba(13,59,110,0.08)`. Pas d'ombre portée noire.

---

## 6. Éléments décoratifs

Le design utilise des formes géométriques simples comme éléments d'ambiance. Ces formes ne portent aucune information, elles créent de la profondeur sans alourdir l'interface.

### Règles pour les formes décoratives

Les formes sont toujours placées en arrière-plan (z-index 0), jamais au-dessus du contenu. Elles sont toujours en opacité faible (entre 4% et 20%). Elles ne sont jamais interactives.

Les formes autorisées sont les cercles et anneaux (`border-radius: 50%`), les triangles (technique CSS `border`), et les polygones simples. Pas de formes organiques complexes.

### Formes par zone

**Header** : anneau circulaire semi-transparent en blanc (opacité 6%) en haut à droite, petite bulle orange (opacité 18%) en bas à droite, triangle CSS en blanc très transparent en bas à gauche.

**Cartes hero** : chaque carte a sa propre forme décorative unique liée à sa couleur de fond. Cercle plein en opacité 20% pour les fonds navy, triangle CSS pour les fonds bordeaux, anneau circulaire pour les fonds verts.

**Cartes de liste** : bulle circulaire très discrète en `rgba(13,59,110,0.04)` en bas à droite de chaque carte. Rayon 80px, positionnée à -20px hors bord.

**Bandeau "Ce soir"** : anneau en orange (opacité 20%) et petite bulle blanche (opacité 4%).

---

## 7. Composants

### Bouton principal (CTA)

Fond `--orange`. Texte blanc. Border-radius 8px. Padding 12px 20px. Font-size 14px, font-weight 600. Pas de bordure. Pas d'ombre.

Usage : achat de ticket, réservation, publication d'événement.

### Bouton secondaire

Fond transparent. Bordure 1.5px solid `--navy`. Texte `--navy`. Même border-radius et padding que le bouton principal.

Usage : "Voir l'événement", "Annuler", actions non destructives secondaires.

### Bouton mini (dans les cartes)

Fond `--orange` (ou `--green` pour les événements gratuits). Texte blanc. Border-radius 7px. Padding 5px 10px. Font-size 11px, font-weight 500.

### Pills de catégorie

État actif : fond `--navy`, texte blanc, icône blanche.  
État inactif : fond blanc, texte `--ink`, icône `--ink`, légère ombre `0 2px 8px rgba(0,0,0,0.07)`.  
Border-radius 30px. Padding 8px 14px. Font-size 12px, font-weight 500.

### Badges de catégorie (sur les cartes)

Fond `--orange`. Texte blanc. Border-radius 20px. Padding 4px 10px. Font-size 10px, font-weight 600.  
Ils contiennent toujours une icône + un label.

### Badges de statut colorés (dans les listes)

Utiliser des teintes pastel de la couleur de la catégorie pour le fond, et la version foncée de cette même couleur pour le texte. Jamais de noir ou de gris générique sur fond coloré.

| Catégorie | Fond | Texte |
|---|---|---|
| Concert | `#EEF2FF` | `#0D3B6E` |
| Soirée | `#FFF0EB` | `#C03D10` |
| Sport | `#EEF2FF` | `#0D3B6E` |
| Culture | `#F3EEFF` | `#5B21B6` |
| Gastronomie | `#FFFBEB` | `#92400E` |
| Gratuit | `#EBF7F2` | `#157A4A` |

### Barre de recherche

Fond blanc. Border-radius 16px. Ombre `0 4px 20px rgba(13,59,110,0.10)`. Padding 13px 16px. L'icône de filtre est un carré `--navy` avec border-radius 9px.

### Prix

Toujours en `--orange` et font-weight 600 pour les événements payants.  
Toujours en `--green` et font-weight 600 pour les événements gratuits.  
Ne jamais afficher le prix en `--ink` ou `--muted`.

---

## 8. Navigation

La navigation principale est en bas de l'écran (bottom navigation), avec 5 onglets fixes :

1. Accueil (`ti-home`)
2. Explorer (`ti-search`)
3. Carte (`ti-map-pin`)
4. Mes billets (`ti-ticket`)
5. Profil (`ti-user-circle`)

L'onglet actif a son icône dans un carré `--navy` avec border-radius 12px. Son label est en `--navy`, font-weight 500.  
Les onglets inactifs ont leur icône en `#B0B5BD` et leur label dans la même couleur.

Le fond de la barre de navigation est blanc, avec border-radius 24px en haut, et une légère ombre vers le haut : `box-shadow: 0 -4px 24px rgba(0,0,0,0.07)`.

---

## 9. Layout et espacements

L'application est conçue pour des écrans de 390px à 430px de largeur (standard Android milieu de gamme et haut de gamme). La référence de maquette est 393px de largeur.

Padding horizontal des sections : 20px de chaque côté.  
Espacement entre les sections : 22–26px.  
Espacement entre les cartes de liste : 12px.  
Espacement entre les cards hero : 14px.

---

## 10. Header

Le header a toujours un fond `--navy`. Il contient en haut : le logo à gauche, les boutons notification et profil à droite. En bas : la salutation personnalisée de l'utilisateur.

La barre de recherche sort du header par effet de chevauchement (`margin-top: -20px` et `z-index: 10`) pour créer une transition fluide entre le header et le contenu.

---

## 11. Cartes hero (À la une)

Scroll horizontal. Chaque carte mesure 220px de large et 240px de haut. Les cartes hero ont un fond coloré sombre (jamais blanc) avec des formes décoratives propres à leur couleur. Le badge de catégorie et les infos se placent en bas, le prix en haut à droite.

Palettes de fonds autorisées pour les cartes hero :

| Fond | Hex |
|---|---|
| Nuit | `#0D3B6E` |
| Bordeaux | `#2D1B4E` |
| Forêt | `#0B4D32` |
| Brun sombre | `#3D1F00` |
| Ardoise | `#1F2D3D` |

Aucun fond clair pour les cartes hero. Le texte est toujours blanc sur ces fonds.

---

## 12. Ce qui est interdit

Ces éléments ne doivent jamais apparaître dans l'interface MyMood :

- Dégradés (linear-gradient, radial-gradient) sur les éléments de l'interface
- Emojis, qu'ils soient dans les textes ou les boutons
- Bordures latérales colorées sur les cartes (style "border-left: 3px solid")
- Ombres lourdes noires (box-shadow avec rgba(0,0,0,0.3) ou plus)
- Texte en gras sur du corps de texte courant (bold uniquement pour les titres et les labels)
- Plus de deux couleurs principales sur un même écran hors charte

---

## 13. Accessibilité et performance

Les boutons et zones tactiles ont une taille minimale de 44px x 44px.  
Le contraste entre le texte et son fond respecte un ratio minimum de 4.5:1 (WCAG AA).  
Toutes les icônes seules (sans label visible) ont un attribut d'accessibilité équivalent.  
Les images d'événements ont toujours un texte alternatif décrivant l'événement.  
L'interface doit rester lisible et utilisable sur des écrans de 360px de largeur minimum.

---

## 14. Évolutions futures

Ces éléments sont réservés aux versions futures et ne doivent pas être intégrés avant validation :

- Mode sombre (dark mode) : la palette navy/orange se prête bien à une version dark, à concevoir séparément
- Animations de transition entre les pages
- Skeleton loaders pour les états de chargement
- Effets de parallaxe sur les cartes hero

---

*DESIGN.md — MyMood — Version 1.0 — Juillet 2025*  
*Ce fichier doit être mis à jour à chaque évolution validée de la charte graphique.*
