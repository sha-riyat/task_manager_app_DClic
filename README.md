# Task Manager — Flutter + SQLite

Application Flutter de gestion de tâches (auth locale + SQLite), architecture **feature-first** (Clean MVVM), police **Inter**.

## Prérequis

- **Flutter SDK** (canal stable) + **Dart**  
  Vérifiez l’installation : `flutter --version`
- **Android** : Android SDK (API 35 recommandé), Build-Tools, Platform-Tools (NDK si Gradle le demande)  
  Acceptez les licences : `flutter doctor --android-licenses`
- **iOS (optionnel, macOS uniquement)** : Xcode + CocoaPods
- **Éditeur** : Android Studio **ou** VS Code (extensions Flutter/Dart)

> Exécutez `flutter doctor` et corrigez tout ce qui s’affiche en rouge.

## Installation & Lancement (rapide)

```bash
# 1) Cloner le repo
git clone https://github.com/sha-riyat/task_manager_app_DClic.git
cd task_manager_app

# 2) Récupérer les dépendances
flutter pub get

# 3) Lancer sur le device/émulateur par défaut
flutter run
