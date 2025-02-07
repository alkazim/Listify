# Lisifyy - Flutter E-Commerce App

## Overview
Lisifyy is a Flutter-based e-commerce application that allows users to browse, search, and view product details. The app is integrated with Firebase for authentication and Firestore for data storage. Users can sign up, log in, browse a list of items, and view detailed product information.

## Tech Stack
- **Frontend:** Flutter (Dart)
- **Backend:** Firebase Authentication, Firestore Database
- **State Management:** setState
- **Storage:** Firebase Firestore for product data

## Features
- User authentication (Sign Up, Log In, Logout)
- Home screen displaying a list of items from Firestore
- Search functionality for filtering items dynamically
- Detailed screen for viewing product details
- Pagination for efficient data loading
- Pull-to-refresh functionality

## Installation Steps
1. **Clone the repository**:
   ```sh
   git clone https://github.com/yourusername/lisifyy.git
   cd lisifyy
   ```
2. **Install dependencies**:
   ```sh
   flutter pub get
   ```
3. **Set up Firebase**:
   - Create a Firebase project in the Firebase Console.
   - Add an Android/iOS app and download the `google-services.json` file (for Android) or `GoogleService-Info.plist` (for iOS).
   - Place the file in the `android/app/` directory (for Android) or `ios/Runner/` directory (for iOS).
   - Enable Firebase Authentication and Firestore Database in the Firebase Console.
4. **Run the app**:
   ```sh
   flutter run
   ```

## Project Structure
```
lib/
│-- main.dart          # Entry point of the application
│-- home_screen.dart   # Home screen displaying products
│-- login_page.dart    # Login screen for authentication
│-- signup_page.dart   # Signup screen for new users
│-- detailed_screen.dart  # Product details page
│-- firebase_options.dart # Firebase configuration
```

## Dependencies
The app uses the following dependencies:
```yaml
  dependencies:
    flutter:
      sdk: flutter
    firebase_core: ^2.27.2
    firebase_auth: ^4.17.3
    firebase_storage: ^11.7.2
    cloud_firestore: ^4.15.3
    carousel_slider: ^5.0.0
    shared_preferences: ^2.5.1
```

