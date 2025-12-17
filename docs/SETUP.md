# Setup Guide

Complete setup instructions for Smart AI Notes app.

## Prerequisites

- **Node.js** 18+ ([Download](https://nodejs.org/))
- **Flutter SDK** 3.0+ ([Install Guide](https://docs.flutter.dev/get-started/install))
- **Firebase CLI** ([Install](https://firebase.google.com/docs/cli))
- **Android Studio** (for Android) or **Xcode** (for iOS)
- **Git**

## Step 1: Clone Repository

```bash
git clone https://github.com/gjciyxjjgiygjjgci-glitch/smart-ai-notes-app.git
cd smart-ai-notes-app
```

## Step 2: Firebase Setup

### 2.1 Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project"
3. Enter project name: `smart-ai-notes`
4. Enable Google Analytics (optional)
5. Create project

### 2.2 Enable Services

**Authentication:**
1. Go to Authentication → Get Started
2. Enable Email/Password and Google sign-in

**Firestore Database:**
1. Go to Firestore Database → Create database
2. Start in production mode
3. Choose location (asia-south1 for India)

**Storage:**
1. Go to Storage → Get Started
2. Use default security rules

### 2.3 Get Configuration Files

**For Backend:**
1. Project Settings → Service Accounts
2. Click "Generate new private key"
3. Save as `backend/serviceAccountKey.json`

**For Mobile App:**
1. Project Settings → General
2. Add Android app:
   - Package name: `com.smartainotes.app`
   - Download `google-services.json`
   - Place in `mobile/android/app/`
3. Add iOS app (if needed):
   - Bundle ID: `com.smartainotes.app`
   - Download `GoogleService-Info.plist`
   - Place in `mobile/ios/Runner/`

## Step 3: Backend Setup

```bash
cd backend
npm install
```

### 3.1 Configure Environment

```bash
cp .env.example .env
```

Edit `.env` and add your keys:

```env
PORT=3000
FIREBASE_PROJECT_ID=smart-ai-notes
FIREBASE_STORAGE_BUCKET=smart-ai-notes.appspot.com
OPENAI_API_KEY=sk-your-key-here
```

### 3.2 Get API Keys

**OpenAI API Key:**
1. Go to [OpenAI Platform](https://platform.openai.com/)
2. Sign up / Log in
3. Go to API Keys → Create new key
4. Copy and add to `.env`

**Google Cloud (for Speech-to-Text):**
1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Enable Speech-to-Text API
3. Use same service account key from Firebase

### 3.3 Test Backend

```bash
npm run dev
```

Visit `http://localhost:3000/health` - should see:
```json
{"status":"ok","message":"Smart AI Notes API is running"}
```

## Step 4: Deploy Backend (Optional)

### Option A: Railway

```bash
# Install Railway CLI
npm install -g @railway/cli

# Login
railway login

# Initialize project
railway init

# Add environment variables
railway variables set OPENAI_API_KEY=sk-...
railway variables set FIREBASE_PROJECT_ID=smart-ai-notes

# Deploy
railway up
```

### Option B: Firebase Functions

```bash
firebase login
firebase init functions
firebase deploy --only functions
```

## Step 5: Mobile App Setup

```bash
cd mobile
flutter pub get
```

### 5.1 Configure Firebase

```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase
flutterfire configure
```

### 5.2 Update API Endpoint

Edit `mobile/lib/config/api_config.dart`:

```dart
class ApiConfig {
  static const String baseUrl = 'https://your-backend-url.com/api';
  // Or for local testing: 'http://10.0.2.2:3000/api'
}
```

### 5.3 Run App

**Android:**
```bash
flutter run
```

**iOS:**
```bash
cd ios
pod install
cd ..
flutter run
```

## Step 6: Testing

### Test Transcription

1. Open app
2. Tap "Record" button
3. Speak in Hindi/English
4. Stop recording
5. Check transcript appears

### Test Summarization

1. After transcription
2. Tap "Generate Summary"
3. Select summary type
4. Verify summary appears

## Step 7: Firebase Security Rules

### Firestore Rules

Go to Firestore → Rules and add:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /notes/{noteId} {
      allow read, write: if request.auth != null 
        && request.auth.uid == resource.data.userId;
    }
    
    match /users/{userId} {
      allow read, write: if request.auth != null 
        && request.auth.uid == userId;
    }
  }
}
```

### Storage Rules

Go to Storage → Rules and add:

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /audio/{userId}/{allPaths=**} {
      allow read, write: if request.auth != null 
        && request.auth.uid == userId;
    }
  }
}
```

## Troubleshooting

### Backend Issues

**Port already in use:**
```bash
# Change PORT in .env or kill process
lsof -ti:3000 | xargs kill
```

**Firebase Admin SDK errors:**
- Verify `serviceAccountKey.json` path
- Check Firebase project ID matches

### Mobile App Issues

**Build failures:**
```bash
flutter clean
flutter pub get
flutter run
```

**Firebase not connecting:**
- Verify `google-services.json` is in correct location
- Run `flutterfire configure` again

**Audio recording not working:**
- Check microphone permissions in `AndroidManifest.xml`
- For iOS, check `Info.plist` permissions

## Next Steps

1. ✅ Test all features locally
2. ✅ Deploy backend to production
3. ✅ Build release APK
4. ✅ Submit to Play Store
5. ✅ Set up analytics and monitoring

## Support

For issues, check:
- [GitHub Issues](https://github.com/gjciyxjjgiygjjgci-glitch/smart-ai-notes-app/issues)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Flutter Documentation](https://docs.flutter.dev/)
