# Studier

A peer-to-peer tutoring platform built with Flutter and Firebase.

## Tech Stack

- **Frontend:** Flutter (Dart)
- **Backend:** Firebase (Auth, Firestore, Storage)
- **Platforms:** Android, iOS, Web

## Getting Started

### Prerequisites

- Flutter SDK (3.0+)
- Firebase CLI
- Android Studio / Xcode (for mobile development)

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/SittiphonRodmanee-6731503040/Studier.git
   cd Studier/studier_flutter
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Configure Firebase:
   - Create a Firebase project at https://console.firebase.google.com
   - Run `flutterfire configure` to generate `firebase_options.dart`
   - Place `google-services.json` in `android/app/`
   - Place `GoogleService-Info.plist` in `ios/Runner/`

4. Run the app:
   ```bash
   flutter run
   ```

## Project Structure

```
studier_flutter/
├── lib/
│   ├── components/     # Reusable UI components (atoms, molecules)
│   ├── context/        # State management (UserProvider)
│   ├── models/         # Data models (User, Tutor, Review)
│   ├── navigation/     # App routing
│   ├── screens/        # App screens (auth, profile, search, tutor)
│   ├── services/       # Firebase & Auth services
│   └── utils/          # Constants, config, mock data
├── assets/             # Images, fonts
├── firestore.rules     # Firestore security rules
└── storage.rules       # Storage security rules
```

## Features

- 🔐 User authentication (email/password)
- 👨‍🏫 Tutor profiles with ratings & reviews
- 🔍 Search tutors by subject, name, university
- ⭐ Review and rate tutors
- 📱 Contact tutors via Line, Instagram, or phone
- 🎓 Register as a tutor

## Security

- Firebase security rules enforce data access control
- No hardcoded credentials in source code
- HTTPS enforced for all network requests
- Mock mode disabled in release builds

## License

MIT