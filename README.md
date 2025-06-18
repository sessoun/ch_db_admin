# Shepherd


A Flutter application for managing group membership, attendance, and events, with integrated AdMob ads and Firebase backend.

---

## Features 

- **Membership Management:** Add, edit, and view members of your group.
- **Attendance Tracking:** Record and view attendance for various programs.
- **Event Management:** Manage and track group events.
- **Birthday Reminders:** See upcoming member birthdays for the week.
- **AdMob Integration:** Banner ads displayed in the app.
- **Dark & Light Theme:** Switch between dark and light modes.
- **Customizable UI:** Change primary color and font size.
- **Audio Notes:** Record and save audio notes for members (if enabled).
- **Highlight & Favorite:** Highlight and favorite important verses (for Bible app module).
- **Copy & Share:** Copy and share content easily.
- **Firebase Auth & Cloud Functions:** Secure authentication and serverless backend logic.
- **Environment Variables:** Securely manage sensitive keys and configuration.

---

## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- [Firebase CLI](https://firebase.google.com/docs/cli)
- [Dart](https://dart.dev/get-dart)
- [Node.js](https://nodejs.org/) (for Firebase Functions)
- [Android Studio](https://developer.android.com/studio) or [VS Code](https://code.visualstudio.com/)

### Clone the Repository

```sh
git clone https://github.com/yourusername/ch_db_admin.git
cd ch_db_admin
```

### Install Dependencies

```sh
flutter pub get
```

### Environment Variables

This project uses environment variables for sensitive data (API keys, etc.).

1. **Create a `.env` file in the project root:**

    ```
    # .env
    EMAIL_ADDRESS=your_email@example.com
    GOOGLE_APP_PASSWORD=your_app_password
    EMAIL_VALIDATOR=your_email_validator_api_key
    FLUTTER_EMAIL=your_email@example.com
    ```

2. **For Firebase Functions:**
    - Set your SendGrid API key and other secrets using the Firebase CLI:
      ```sh
      firebase functions:env:set SENDGRID_API_KEY="SG.xxxxxxxx.yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy"
      ```

3. **Do NOT commit your `.env` file to version control.**  
   Instead, create a `.env.example` with placeholder values for sharing.

---

## Firebase Setup

1. Create a Firebase project at [console.firebase.google.com](https://console.firebase.google.com/).
2. Add Android/iOS apps and download the `google-services.json`/`GoogleService-Info.plist` files.
3. Place these files in the appropriate directories (`android/app` and `ios/Runner`).
4. Enable Authentication, Firestore, and Functions as needed.
5. Deploy Cloud Functions:
    ```sh
    cd functions
    npm install

    firebase deploy --only functions    firebase deploy --only functions
    ```

---

## Running the App

```sh
flutter run
```

---

## Project Structure

```
lib/
  main.dart                # App entry point
  shared/                  # Shared utilities, ads, 
  src/
    Members/               # Membership features
    attendance/            # Attendance features
    events/                # Event features
    main_view/             # Main UI and navigation
    auth/                  # Authentication UI and logic
functions/                 # Firebase Cloud Functions (Node.js)
.env.example               # Example environment file
```

---

## Useful Commands

- **Run app:** `flutter run`
- **Build APK:** `flutter build apk`
- **Deploy functions:** `firebase deploy --only functions`
- **Get dependencies:** `flutter pub get`

---

## Contributing

Pull requests are welcome! For major changes, please open an issue first to discuss what you would like to change.

---

## License

[MIT](LICENSE)

---

## Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Provider Package](https://pub.dev/packages/provider)
- [Google Mobile Ads for Flutter](https://pub.dev/packages/google_mobile_ads)