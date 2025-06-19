# IUTables'O - SAE 4.04 - Développement Mobile

## 📌 Présentation
L'application **IUTables'O** est une application mobile développée en **Flutter** dans le cadre de la SAE 4.04. Elle permet aux utilisateurs authentifiés de :

- **Donner des avis** et **noter des restaurants** d'Orléans
- **Aimer des restaurants** et gérer leurs favoris
- **Choisir des types de cuisine préférés**
- **Prendre et publier des photos des restaurants**
- **Accéder aux restaurants proches** grâce à la géolocalisation

L'application repose sur une base de données centralisée gérée avec **Supabase** et une base locale sur smartphone via **Sqflite**.

## 🚀 Installation et lancement

### 🛠 Prérequis
Avant d'exécuter l'application, assurez-vous d'avoir installé :

- **Flutter SDK** (>=3.0.0) → [Documentation Flutter](https://docs.flutter.dev/get-started/install)
- **Dart SDK** (inclus avec Flutter)
- **Un émulateur Android/iOS** ou un **appareil physique**
- **Un compte Supabase** avec une base de données configurée

### 📥 Cloner le projet
```sh
git clone https://gitlab.com/votre-repository.git
cd votre-repository
```

### 🔧 Installation des dépendances
```sh
flutter pub get
```

### 🔑 Configuration de l’environnement
1. **Créer un fichier `.env`** à la racine avec les variables suivantes :
   ```env
   SUPABASE_URL=your_supabase_url
   SUPABASE_ANON_KEY=your_supabase_anon_key
   ```
2. **Assurez-vous que votre base Supabase contient les tables nécessaires** (voir le MCD fourni dans la documentation).

### ▶ Lancer l'application
```sh
flutter run
```

## 📌 Fonctionnalités implémentées

✅ **Authentification** (Inscription / Connexion via Supabase)  
✅ **Gestion des préférences utilisateur** (types de cuisine, favoris)  
✅ **Ajout et consultation des avis** (notes, critiques)  
✅ **Affichage des restaurants préférés**  
✅ **Prise et affichage de photos des restaurants**  
✅ **Géolocalisation des restaurants proches**  
✅ **Stockage local via Sqflite**  
✅ **Tests unitaires avec `flutter test` (80% de couverture minimale)**  

## 🗄 Modèle de données

L'application utilise **deux bases de données** :

- **Supabase** : base principale contenant les restaurants, utilisateurs, avis, photos...
- **Sqflite** : stockage local pour les préférences utilisateur (favoris, types de cuisine...)

### 📊 Modèles de données fournis :
- **MCD de Supabase** (si modifié, voir documentation)
- **MCD de Sqflite** (stockage local sur mobile)
- **Diagramme de classes Flutter**

## 📂 Structure du projet
```bash
📦 iutableso
 ┣ 📂 lib # Code principal
 ┃ ┣ 📂 models # Modèles de données
 ┃ ┣ 📂 screens # Interfaces utilisateur
 ┃ ┣ 📂 services # Interaction avec Supabase / Sqflite
 ┃ ┣ 📂 widgets # Composants réutilisables
 ┣ 📂 test # Tests unitaires
 ┣ 📜 pubspec.yaml # Dépendances Flutter
 ┣ 📜 .env.example # Exemple de configuration Supabase
 ┣ 📜 README.md # Documentation du projet
```

## ✅ Contraintes techniques respectées

- Utilisation de **Flutter** avec **Dart** ✅
- Authentification avec **Supabase** ✅
- Stockage local avec **Sqflite** et **Shared Preferences** ✅
- Navigation fluide avec **go_router** ✅
- Respect des principes de codage et ergonomie soignée ✅
- Tests unitaires via `flutter test` avec **80% de couverture** ✅

## 📝 Dépôt et rendu
- **Lien GitLab/GitHub** : [URL du dépôt](https://gitlab.com/votre-repository)
- **Ajout des enseignants en `Reporter` sur le dépôt** ✅
- **Fichier ZIP du projet déposé sur CELENE** ✅
- **Présentation orale à planifier avec les chargés de TP** ✅

---
