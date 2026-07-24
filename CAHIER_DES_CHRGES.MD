

CAHIER DES CHARGES
Application Mobile de Référence pour
les Événements et Divertissements au Bénin



Version 2.0    |    Juillet 2025
Plateforme : Flutter + Firebase    |    Android & iOS

Fiche d'Identité du Projet

Nom du projet : EventBJ
Application mobile événements & divertissements Bénin
Type
Application mobile (Android & iOS)
Stack technique
Flutter (mobile) + Firebase (backend)
Secteur
Événementiel / Culture / Divertissement
Marché cible
Grand public béninois
Déploiement
Bénin (Cotonou, Porto-Novo, Parakou et villes secondaires)
Modèle économique
Commissions sur ventes de tickets (différées)
Paiement
Mobile Money (MTN, Moov) + Carte bancaire
Version du document
2.0 – Juillet 2025

1. Présentation du Projet
1.1 Description générale
Ce projet vise à créer la première application mobile de référence dédiée à l'information événementielle au Bénin. Elle fonctionne comme une marketplace événementielle : tout organisateur peut y publier son événement, générer un lien partageable unique, et recevoir des paiements de tickets directement sur la plateforme.
Le modèle est inspiré de plateformes comme Gumroad ou Lemon Squeezy, mais adapté au contexte béninois, avec les moyens de paiement locaux (Mobile Money MTN et Moov) et une expérience utilisateur pensée pour le public béninois.
1.2 Vision du produit
Devenir la référence numéro 1 de l'événementiel au Bénin : une plateforme où chaque soirée, concert, festival ou événement culturel est accessible en un clic, et où n'importe qui peut acheter son ticket en quelques secondes depuis son téléphone.
1.3 Parties prenantes

Partie prenante
Rôle
Attentes principales
Grand public
Acheteur de tickets
Découvrir les événements et payer facilement depuis son téléphone
Organisateurs
Créateurs d'événements
Publier, partager, vendre des tickets et recevoir l'argent
Équipe admin
Modération & gestion
Valider les comptes, surveiller la qualité et gérer les litiges
Partenaires
Sponsors & annonceurs
Promouvoir leurs marques auprès du public béninois


2. Contexte et Problématique
2.1 Contexte local
Le Bénin connaît une scène événementielle particulièrement dynamique. Chaque semaine, des dizaines de soirées, concerts, festivals, compétitions sportives et événements culturels sont organisés à Cotonou, Porto-Novo, Parakou et dans les villes secondaires.
Aujourd'hui, la vente de tickets se fait encore majoritairement en espèces, par virement ou via des circuits informels. Il n'existe aucune plateforme locale fiable centralisant les événements et permettant l'achat en ligne avec les moyens de paiement du quotidien des Béninois.
2.2 Problèmes identifiés
    • Les informations sur les événements sont éparpillées (WhatsApp, flyers, bouche-à-oreille) sans centralisation.
    • Aucune solution locale de vente de tickets en ligne adaptée au Mobile Money béninois.
    • Les organisateurs n'ont pas d'outil professionnel pour vendre et suivre leurs ventes en temps réel.
    • Le public est souvent informé trop tard et n'a pas de moyen simple de payer à distance.
    • Pas de traçabilité des ventes : ni pour l'organisateur, ni pour le contrôle à l'entrée le jour J.-
    - Pas de possibilté de payer des tickets en ligne
    

3. Objectifs du Projet
3.1 Objectifs principaux
    • Créer une plateforme mobile de référence pour l'information et la billetterie événementielle au Bénin.
    • Permettre à tout organisateur de publier un événement et de générer un lien de paiement partageable.
-payer des tickets en ligne
    • Offrir au grand public un moyen simple et rapide d'acheter ses tickets via Mobile Money ou carte.
    • Assurer une traçabilité complète des ventes grâce à un système de tickets numériques avec QR code.
3.2 Objectifs secondaires
    • Développer une communauté autour de la vie culturelle et festive béninoise.
    • Permettre aux organisateurs de gérer leurs revenus via un portefeuille intégré avec option de retrait.
    • Proposer des suggestions d'autres événements sur chaque page d'événement pour augmenter les découvertes.
    • Générer des revenus via des commissions sur les ventes de tickets à terme.

4. Concept Clé : La Page Événement avec Lien Partageable
C'est le mécanisme central de la plateforme, inspiré du fonctionnement de Chariot. Voici comment il fonctionne de bout en bout.

4.1 Fonctionnement du lien partageable
Chaque événement publié sur la plateforme génère automatiquement une URL unique et partageable du type :
app.nomplateforme.bj/events/concert-cotonou-juillet-2025
L'organisateur partage ce lien via WhatsApp, Instagram, Facebook, SMS ou tout autre canal. Toute personne qui clique sur le lien atterrit directement sur la page de l'événement, sans avoir besoin d'un compte.
4.2 Ce que voit l'acheteur sur la page événement
    • Photo et affiche officielle de l'événement.
    • Titre, date, heure, lieu exact avec carte.
    • Description complète (artistes, programme, ambiance attendue).
    • Types de tickets disponibles et leurs prix (standard, VIP, VVIP...).
    • Bouton d'achat bien visible.
    • Section « Autres événements » en bas de page, suggérant des événements similaires sur la plateforme.
4.3 Processus d'achat (sans compte obligatoire)

Étape
Action
Résultat
1
L'acheteur clique sur le lien partagé
Affichage de la page de l'événement
2
Il choisit son type de ticket et la quantité
Récapitulatif de commande
3
Il saisit son numéro de téléphone et son nom
Identification minimale pour envoi du ticket
4
Il choisit son mode de paiement (MTN, Moov, Carte)
Redirection vers la passerelle de paiement
5
Il confirme le paiement
Paiement traité et validé
6
Il reçoit son ticket numérique par SMS et notification, mails
Ticket avec QR code unique
7
L'organisateur reçoit une notification de vente
Mise à jour du solde de son portefeuille

4.4 Le ticket numérique reçu par l'acheteur
    • Ticket numérique au format image ou PDF envoyé par SMS et email (si renseigné).
    • Contient un QR code unique, le nom de l'acheteur, le type de ticket, la date et le lieu.
    • Visible directement dans l'application (section Mes billets) si l'acheteur a un compte.
    • Consultable hors connexion pour présentation le jour de l'événement.
4.5 Contrôle à l'entrée le jour J
    • L'organisateur ou son équipe utilise l'application pour scanner les QR codes des participants.
    • Scan en temps réel avec confirmation visuelle (vert = valide, rouge = déjà utilisé ou invalide).
    • Liste des participants téléchargeable (CSV) pour un contrôle manuel en cas de problème réseau.
    • Option d'impression de tickets physiques : l'organisateur peut imprimer les tickets depuis son espace.

5. Périmètre Fonctionnel

Module
Description
Priorité
Page événement et lien partageable
Page publique accessible sans compte, avec achat de ticket
Haute
Billetterie et paiement
Achat en ligne, Mobile Money, génération de ticket QR code
Haute
Espace organisateur
Publication, gestion des événements, tableau de bord des ventes
Haute
Portefeuille et retraits
Solde des ventes, demande de retrait vers Mobile Money
Haute
Découverte d'événements
Fil d'actualité, recherche, filtres, suggestions
Haute
Notifications temps réel
Alertes vente, rappels événements, notifications push
Haute
Scanner QR code
Validation des tickets à l'entrée de l'événement
Haute
Profil utilisateur
Compte optionnel(pas forcé, mais proposé en haut), historique des tickets(si connecté), favoris
Moyenne
Suggestions d'événements
Recommandations en bas de page événement
Moyenne
Carte et géolocalisation
Carte des événements proches
Moyenne
Calendrier personnel
Événements sauvegardés et achetés
Moyenne
Communauté et partage
Avis, partage réseaux sociaux
Basse
Administration
Back-office de validation et modération
Haute


6. Description Détaillée des Fonctionnalités
6.1 Publication d'un événement (Espace Organisateur)
6.1.1 Création de compte organisateur
    • Inscription avec numéro de téléphone (OTP SMS) ou email.
    • Renseignement du profil : nom ou nom de l'organisation, photo, description courte.
    • Compte actif immédiatement pour la publication, mais badge « Vérifié » après validation par l'admin.
6.1.2 Formulaire de création d'événement
    • Titre de l'événement.
    • Catégorie (soirée, concert, sport, culture, gastronomie, formation, etc.).
    • Description détaillée (artistes, programme, dress code, infos pratiques).
    • Date(s) et heure(s) de début et de fin.
    • Lieu : nom du lieu + adresse + épingle sur carte Google Maps.
    • Upload de l'affiche principale et photos supplémentaires.
    • Lien vidéo de teaser (YouTube, TikTok) optionnel.
    • Paramétrage des tickets : nom du type, prix, nombre de places disponibles, description.
    • Choix de visibilité : public (accessible via lien et visible sur la plateforme) ou privé (accessible via lien uniquement).
6.1.3 Après publication
    • Génération automatique d'un lien partageable unique.
    • Boutons de partage rapide : copier le lien, partager sur WhatsApp, partager sur Facebook.
    • Aperçu de la page telle que la verra l'acheteur.

6.2 Tableau de Bord de l'Organisateur
    • Vue d'ensemble : nombre de tickets vendus, chiffre d'affaires total, solde disponible.
    • Détail par événement : ventes en temps réel, courbe des ventes sur le temps, tickets restants.
    • Liste des participants : nom, numéro de téléphone, type de ticket, date d'achat.
    • Export CSV ou PDF de la liste des participants pour la gestion à l'entrée.
    • Historique complet de toutes les transactions.
    • Notifications push à chaque nouvelle vente de ticket.

6.3 Billetterie et Paiement
6.3.1 Modes de paiement supportés
    • MTN Mobile Money (Bénin).
    • Moov Money (Bénin).
    • Carte bancaire Visa et Mastercard.
    • Intégration via FedaPay ou Kkiapay (passerelles de paiement locales béninoises).
6.3.2 Sécurité des paiements
    • Toutes les transactions sont chiffrées (HTTPS/TLS).
    • Les données bancaires ne transitent pas par nos serveurs (traitement direct par la passerelle).
    • Chaque transaction génère un identifiant unique et une référence de paiement.
6.3.3 Remboursements et annulations
    • En cas d'annulation d'un événement par l'organisateur, les acheteurs sont notifiés automatiquement.
    • La politique de remboursement est définie par l'organisateur lors de la création de l'événement.
    • Les remboursements sont traités manuellement par l'équipe d'administration dans un premier temps.

6.4 Notifications en Temps Réel
    • Notification push à l'organisateur à chaque vente de ticket (nom de l'acheteur, type de ticket, montant).
    • Notification push à l'acheteur après paiement confirmé (avec lien vers son ticket).
    • SMS de confirmation envoyé à l'acheteur avec le ticket ou un lien vers son ticket.
    • Rappels automatiques à l'acheteur : J-1 et H-3 avant l'événement.
    • Alertes à l'organisateur : places limitées (moins de 10% restantes), événement complet.

6.5 Découverte d'Événements (Fil d'actualité)
    • Page d'accueil avec fil des événements à venir, triés par date et popularité.
    • Section « Ce soir » et « Ce week-end » pour les événements imminents.
    • Section « À la une » pour les événements mis en avant (futurs événements sponsorisés).
    • Filtres par catégorie, ville, date, prix (gratuit ou payant).
    • Barre de recherche par mot-clé.
    • Sur la page de chaque événement, section « Autres événements » suggérant d'autres événements de la plateforme par catégorie ou par proximité de date.

6.6 Scanner QR Code (Contrôle à l'entrée)
    • Fonctionnalité accessible depuis l'app de l'organisateur.
    • Scan de la caméra du téléphone pour lire le QR code du ticket.
    • Retour visuel immédiat : vert (ticket valide et non encore scanné), rouge (ticket invalide ou déjà utilisé).
    • Historique des entrées consultable en temps réel.
    • Mode hors ligne : les tickets peuvent être pré-téléchargés pour un scan sans connexion internet.

6.7 Profil Utilisateur
    • Création de compte optionnelle pour l'acheteur : il peut acheter sans compte, avec un simple numéro de téléphone.
    • Avec un compte : historique de tous ses tickets, liste de favoris, suivi des organisateurs.
    • Portefeuille acheteur : affichage des tickets achetés avec leur QR code.
    • Préférences : catégories favorites pour personnaliser le fil d'actualité.

6.8 Administration et Modération
    • Back-office web dédié à l'équipe de la plateforme.
    • Validation des comptes organisateurs et vérification des pièces justificatives.
    • Modération des événements publiés (suppression des contenus frauduleux ou inappropriés).
    • Gestion des demandes de retrait des organisateurs.
    • Tableau de bord global : utilisateurs, événements, tickets vendus, revenus totaux.
    • Gestion des catégories, des villes, des mises en avant.

7. Parcours Utilisateurs (UX)
7.1 Parcours Acheteur : Acheter un ticket via un lien partagé

Étape
Action de l'utilisateur
Ce qui se passe
1
Reçoit un lien sur WhatsApp ou Instagram
Il clique sur le lien depuis son téléphone
2
Atterrit sur la page de l'événement
Affichage immédiat sans connexion requise : affiche, infos, tarifs
3
Fait défiler la page
Voit les types de tickets disponibles et les suggestions d'autres événements
4
Clique sur « Acheter un ticket »
Sélection du type et de la quantité
5
Saisit son nom et numéro de téléphone
Identification minimale pour réception du ticket
6
Choisit Mobile Money (MTN ou Moov)
Redirection ou prompt de confirmation paiement
7
Confirme le paiement sur son téléphone
Paiement validé par la passerelle
8
Reçoit son ticket par SMS et notification
QR code unique avec ses informations
9
Le jour J : présente son QR code
Scan par l'équipe de l'organisateur à l'entrée

7.2 Parcours Organisateur : Publier et gérer un événement

Étape
Action
Résultat
1
Crée son compte organisateur
Accès immédiat à l'espace organisateur
2
Clique sur « Créer un événement »
Formulaire de création multi-étapes
3
Remplit les informations, upload l'affiche
Prévisualisation de la page publique
4
Configure les tickets (types et prix)
Paramétrage de la billetterie
5
Publie l'événement
Génération du lien partageable unique
6
Partage le lien sur WhatsApp, Instagram...
Les acheteurs arrivent sur la page
7
Reçoit des notifications à chaque vente
Tableau de bord mis à jour en temps réel
8
Suit ses ventes sur le tableau de bord
Courbe des ventes, liste des participants
9
Exporte la liste des participants
Fichier CSV pour gestion à l'entrée
10
Après l'événement : demande un retrait
Virement vers son Mobile Money sous 24-48h


8. Système de Portefeuille et Retraits
8.1 Fonctionnement du portefeuille
Chaque organisateur dispose d'un portefeuille virtuel intégré à l'application. Chaque vente de ticket crédite automatiquement ce portefeuille, déduction faite de la commission de la plateforme (le cas échéant).

État du solde
Description
Solde en attente
Montant des ventes récentes, en cours de traitement (délai anti-fraude de 24h)
Solde disponible
Montant disponible pour retrait immédiat
Historique
Liste complète de toutes les transactions créditrices et débitrices

8.2 Processus de retrait
    • L'organisateur clique sur « Retirer » depuis son portefeuille.
    • Il saisit le montant à retirer (minimum défini par la plateforme, ex : 1 000 FCFA).
    • Il sélectionne son numéro Mobile Money (MTN ou Moov) pré-enregistré dans son profil.
    • Il confirme la demande de retrait.
    • La demande est traitée par l'équipe d'administration sous 24 à 48 heures ouvrables.
    • L'organisateur reçoit une notification push et un SMS de confirmation quand le virement est effectué.
8.3 Sécurité du portefeuille
    • Le numéro Mobile Money de l'organisateur est vérifié lors de la configuration du compte.
    • Un code PIN ou une confirmation biométrique est requis pour toute demande de retrait.
    • Toutes les transactions sont enregistrées et consultables dans l'historique.
    • L'équipe d'administration valide manuellement les retraits dans un premier temps, pour garantir la sécurité.

9. Architecture Technique (Flutter + Firebase)
9.1 Pourquoi Flutter + Firebase ?
Flutter permet de développer une application mobile unique déployée simultanément sur Android et iOS, avec des performances natives et une interface fluide. Firebase offre un backend complet (base de données temps réel, authentification, notifications, hébergement) sans nécessiter de serveur dédié dans un premier temps, ce qui réduit les coûts de démarrage et accélère le développement.

9.2 Stack technique détaillée

Composant
Technologie
Rôle
Application mobile
Flutter (Dart)
Application unique Android & iOS
Base de données
Firebase Firestore
Stockage temps réel des événements, tickets, utilisateurs
Authentification
Firebase Auth
Connexion par téléphone (OTP), Google, email
Stockage fichiers
Firebase Storage
Hébergement des affiches et photos d'événements
Notifications push
Firebase Cloud Messaging (FCM)
Envoi des notifications en temps réel
Notifications SMS
Twilio ou Africa's Talking
Envoi des tickets et confirmations par SMS
Paiement
FedaPay ou Kkiapay
MTN Mobile Money, Moov Money, Carte bancaire
Fonctions serveur
Firebase Cloud Functions
Logique métier : génération QR code, commission, retrait
Scanner QR
mobile_scanner (plugin Flutter)
Lecture des QR codes à l'entrée
Cartes
Google Maps Flutter plugin
Affichage de la localisation des événements
Liens partageables
Firebase Dynamic Links
Génération des liens profonds (deep links)
Administration
Flutter Web ou React.js
Back-office de gestion de la plateforme

9.3 Architecture des données (Firestore)
Collections principales
    • events : titre, description, catégorie, date, lieu, organisateurId, types de tickets, statut, compteurs de ventes.
    • users : profil, type (acheteur / organisateur), préférences, solde portefeuille.
    • tickets : référence de l'événement, acheteur, type, QR code, statut (actif / scanné / annulé).
    • transactions : montant, type (crédit vente / débit retrait), statut, date, références associées.
    • withdrawals : demandes de retrait, montant, numéro Mobile Money, statut, date de traitement.
    • notifications : historique des notifications envoyées aux utilisateurs.
9.4 Sécurité
    • Règles de sécurité Firestore : chaque utilisateur ne peut lire et modifier que ses propres données.
    • Les Cloud Functions gèrent la logique sensible (paiement, génération de QR code, retrait) côté serveur.
    • Toutes les communications sont chiffrées via HTTPS/TLS.
    • Les QR codes sont des identifiants uniques générés côté serveur et ne peuvent pas être falsifiés.

10. Exigences Non Fonctionnelles

Critère
Exigence
Performance
Chargement de la page événement en moins de 2 secondes sur une connexion 3G
Disponibilité
Disponibilité de la plateforme à 99,5% (Firebase garantit une haute disponibilité)
Compatibilité
Android 6.0+ et iOS 12+ (couvrant 95%+ des appareils au Bénin)
Mode hors ligne
Affichage des tickets achetés et scan QR code fonctionnels sans connexion internet
Langue
Français exclusivement (langue officielle du Bénin)
Accessibilité
Police lisible, tailles ajustables, boutons larges adaptés aux écrans moyens
Scalabilité
Firebase Firestore et FCM scalent automatiquement selon le trafic
Temps réel
Mise à jour instantanée du tableau de bord de l'organisateur à chaque vente


11. Modèle Économique
11.1 Phase de lancement (Gratuit pour attirer les organisateurs)
Durant la phase de lancement, aucune commission n'est prélevée sur les ventes de tickets. L'objectif est d'attirer un maximum d'organisateurs et de constituer un catalogue d'événements riche et varié. La plateforme est totalement gratuite pour les organisateurs comme pour les acheteurs.
11.2 Phase de monétisation (à définir avec les partenaires)
Une fois la plateforme bien établie, plusieurs options de monétisation seront mises en place progressivement, après concertation avec les organisateurs partenaires.

Source de revenus
Modèle
Montant estimé
Commission sur tickets
% prélevé sur chaque vente
Entre 3% et 8% selon le volume
Mise en avant d'événements
Frais de promotion payants
À définir (forfait fixe)
Abonnement organisateur
Plan mensuel avec avantages
À définir selon le marché
Publicité ciblée
Bannières dans le fil d'actualité
À définir selon l'audience
Partenariats institutionnels
Contrats avec mairies, offices de tourisme
Négociation au cas par cas

11.3 Note sur les commissions
Les commissions, quand elles seront appliquées, seront définies en accord avec les organisateurs. L'idée directrice est d'offrir une valeur suffisante (visibilité, outils de gestion, sécurité des paiements) pour que la commission soit perçue comme un investissement, et non comme une charge.

12. Planning Prévisionnel

Phase
Contenu
Durée estimée
Phase 0 : Cadrage
Validation du CDC, choix des outils Firebase, configuration initiale
1 semaine
Phase 1 : Design UI/UX
Maquettes Figma de toutes les pages (page événement, achat, dashboard)
3 semaines
Phase 2 : Backend Firebase
Configuration Firestore, Auth, Storage, Cloud Functions, paiement
4 semaines
Phase 3 : App Flutter
Développement de toutes les fonctionnalités mobiles
8 semaines
Phase 4 : Admin Web
Back-office d'administration (validation, modération, retraits)
3 semaines
Phase 5 : Tests
Tests unitaires, tests d'intégration, tests utilisateurs réels
2 semaines
Phase 6 : Beta
Déploiement Beta avec un groupe d'organisateurs pilotes au Bénin
2 semaines
Phase 7 : Lancement
Mise en ligne officielle sur Play Store et App Store + campagne marketing
2 semaines

Durée totale estimée : 25 semaines (environ 6 mois).

13. Livrables Attendus
    • Cahier des charges validé (ce document).
    • Maquettes UI/UX haute fidélité sur Figma (toutes les pages).
    • Code source Flutter de l'application mobile (Android & iOS).
    • Configuration Firebase complète (Firestore, Auth, Storage, FCM, Cloud Functions).
    • Intégration paiement FedaPay ou Kkiapay opérationnelle.
    • Back-office web d'administration.
    • Application publiée sur Google Play Store et Apple App Store.
    • Documentation technique (architecture, déploiement, maintenance).
    • Guide d'utilisation pour les organisateurs.
    • Rapport de tests et de validation.

14. Glossaire

Terme
Définition
Flutter
Framework de développement mobile de Google permettant de créer des applications Android et iOS depuis un seul code source en langage Dart
Firebase
Plateforme backend de Google offrant base de données temps réel, authentification, stockage, notifications et fonctions serveur
Firestore
Base de données NoSQL de Firebase, synchronisée en temps réel entre le serveur et les applications
Cloud Functions
Fonctions serveur Firebase exécutées automatiquement en réponse à des événements (ex : paiement validé)
FCM
Firebase Cloud Messaging : service d'envoi de notifications push sur Android et iOS
QR Code
Code graphique scannable contenant les informations d'un ticket de manière unique et infalsifiable
OTP
One-Time Password : code temporaire envoyé par SMS pour valider une inscription ou une connexion
Deep Link
Lien URL qui ouvre directement une page spécifique dans l'application mobile
FedaPay / Kkiapay
Passerelles de paiement locales béninoises supportant MTN Mobile Money, Moov Money et les cartes bancaires
Mobile Money
Service de paiement mobile par téléphone, très répandu au Bénin (MTN Mobile Money, Moov Money)
Portefeuille
Compte virtuel dans l'application où l'organisateur accumule ses revenus de vente
FCFA
Franc CFA : monnaie officielle du Bénin


Fin du Cahier des Charges   |   Version 2.0   |   Juillet 2025   |   Flutter + Firebase
