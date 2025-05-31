# Application de Messagerie Flutter

## Table des matières
1. [Introduction](#introduction)
2. [Fonctionnalités](#fonctionnalités)
3. [Architecture](#architecture)
4. [Technologies utilisées](#technologies-utilisées)
5. [Installation](#installation)
6. [Guide d'utilisation](#guide-dutilisation)
7. [Captures d'écran](#captures-décran)
8. [Difficultés rencontrées](#difficultés-rencontrées)
9. [Améliorations possibles](#améliorations-possibles)

## Introduction

Cette application de messagerie développée avec Flutter permet aux utilisateurs de visualiser et d'envoyer des messages dans différentes conversations. L'application utilise une architecture bloc pour la gestion de l'état et des données mockées pour simuler une API.

## Fonctionnalités

- Affichage de la liste des conversations
- Visualisation des messages dans une conversation
- Envoi de nouveaux messages
- Indication du nombre de messages non lus
- Affichage des horaires des messages
- Interface utilisateur intuitive et moderne
- Création de nouvelles conversations
- Réponses automatiques simulées

## Architecture

L'application est construite selon le pattern BLoC (Business Logic Component), qui sépare la logique métier de l'interface utilisateur :

- **Models** : Définition des classes de données (Conversation, Message)
- **BLoC** : Gestion de l'état et de la logique métier
- **UI (Screens)** : Affichage des données et interaction utilisateur
- **Data** : Service de données mockées

### Structure des dossiers

```
lib/
├── bloc/
│   └── conversation/
│       ├── conversation_bloc.dart
│       ├── conversation_event.dart
│       └── conversation_state.dart
├── data/
│   └── mock_data.dart
├── models/
│   ├── conversation.dart
│   └── message.dart
├── screens/
│   ├── conversation_detail_screen.dart
│   └── conversation_list_screen.dart
└── main.dart
```

## Technologies utilisées

- **Flutter** : Framework UI cross-platform
- **flutter_bloc** : Bibliothèque pour la gestion d'état
- **intl** : Formatage des dates et heures
- **uuid** : Génération d'identifiants uniques

## Installation

1. Cloner le dépôt :
```bash
git clone https://github.com/username/otamane.sabiri.exam-flutter.git
cd otamane.sabiri.exam-flutter
```

2. Installer les dépendances :
```bash
flutter pub get
```

3. Exécuter l'application :
```bash
flutter run
```

## Guide d'utilisation

1. **Écran principal** :
   - Affiche la liste des conversations
   - Chaque conversation montre le nom du contact, le dernier message, l'heure et le nombre de messages non lus
   - Appuyez sur une conversation pour voir les détails

2. **Écran de détail de conversation** :
   - Affiche tous les messages de la conversation
   - Les messages de l'utilisateur sont affichés à droite (bleu)
   - Les messages du contact sont affichés à gauche (gris)
   - Utilisez le champ de texte en bas pour envoyer un nouveau message

## Captures d'écran

> **Note**: Pour ajouter des captures d'écran à ce document, prenez des photos de l'application en cours d'exécution et placez-les dans un dossier `assets/screenshots/` avec les commandes suivantes:

```bash
mkdir -p assets/screenshots
# Placez vos captures d'écran dans ce dossier
```

### Liste des conversations
![Liste des conversations](assets/screenshots/conversation_list.png)
*Liste des conversations avec informations sur les derniers messages et les messages non lus*

### Détail d'une conversation
![Détail d'une conversation](assets/screenshots/conversation_detail.png)
*Interface de chat avec messages envoyés et reçus*

## Difficultés rencontrées

- **Gestion des états complexes** : La synchronisation des messages entre la liste des conversations et les détails d'une conversation spécifique a nécessité une attention particulière.
- **Mise à jour en temps réel** : Simuler l'arrivée de nouveaux messages et mettre à jour l'interface utilisateur en conséquence.
- **Design responsive** : Assurer que l'application s'affiche correctement sur différentes tailles d'écran.
- **Gestion du contexte Flutter** : Résolution des problèmes liés à l'utilisation de `BuildContext` à travers les gaps asynchrones.
- **BLoC state management** : Gestion correcte des états lors de la navigation entre différents écrans et conversations.

## Problèmes résolus

- **Correction des importations manquantes** : Résolution du problème d'importation dans `conversation_bloc.dart` pour `MockDataService`.
- **Gestion du BuildContext** : Ajout d'une vérification `mounted` pour éviter les erreurs lors de l'utilisation du contexte après une opération asynchrone.
- **Affichage des messages** : Correction du problème d'affichage des messages dans l'écran de détail de conversation en modifiant la gestion des états dans le BLoC.
- **Optimisation du BlocConsumer** : Implémentation d'un `buildWhen` pour éviter les reconstructions inutiles de l'interface.
- **Tri chronologique des messages** : Ajout d'un tri des messages par horodatage pour garantir l'affichage dans le bon ordre.

## Améliorations possibles

- Authentification utilisateur
- Stockage persistant des messages (SQLite ou Firebase)
- Support des images et fichiers dans les messages
- Indicateurs de saisie ("XYZ est en train d'écrire...")
- Recherche de messages et de conversations
- Notifications push pour les nouveaux messages
- Mode sombre
- Support multilingue
- Tests unitaires et d'intégration
- Architecture plus robuste avec Repository pattern
