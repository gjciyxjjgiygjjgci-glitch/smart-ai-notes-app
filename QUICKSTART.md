# Quick Start Guide 🚀

Get Smart AI Notes running in 15 minutes!

## Prerequisites

Install these first:
- [Node.js 18+](https://nodejs.org/)
- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- [Firebase CLI](https://firebase.google.com/docs/cli): `npm install -g firebase-tools`
- [Git](https://git-scm.com/)

## Step 1: Clone & Setup (2 min)

```bash
# Clone repository
git clone https://github.com/gjciyxjjgiygjjgci-glitch/smart-ai-notes-app.git
cd smart-ai-notes-app

# Install backend dependencies
cd backend
npm install
cd ..

# Install Flutter dependencies
cd mobile
flutter pub get
cd ..
```

## Step 2: Firebase Setup (5 min)

### Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project" → Name it "smart-ai-notes"
3. Enable Google Analytics (optional) → Create

### Enable Services
1. **Authentication**: Enable Email/Password + Google
2. **Firestore**: Create database (production mode)
3. **Storage**: Enable with default rules

### Get Credentials

**For Backend:**
```bash
# In Firebase Console:
# Project Settings → Service Accounts → Generate new private key
# Save as: backend/serviceAccountKey.json
```

**For Mobile:**
```bash
# Add Android app in Firebase Console
# Package name: com.smartainotes.app
# Download google-services.json → Place in mobile/android/app/

# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase
cd mobile
flutterfire configure
```

## Step 3: API Keys (3 min)

### OpenAI API Key
1. Go to [OpenAI Platform](https://platform.openai.com/)
2. Create account / Login
3. API Keys → Create new key
4. Copy the key

### Configure Backend
```bash
cd backend
cp .env.example .env
```

Edit `.env`:
```env
PORT=3000
FIREBASE_PROJECT_ID=smart-ai-notes
FIREBASE_STORAGE_BUCKET=smart-ai-notes.appspot.com
OPENAI_API_KEY=sk-your-key-here
GOOGLE_APPLICATION_CREDENTIALS=./serviceAccountKey.json
```

## Step 4: Run Backend (2 min)

```bash
cd backend
npm run dev
```

You should see:
```
🚀 Server running on port 3000
```

Test it: Open http://localhost:3000/health

## Step 5: Run Mobile App (3 min)

**In a new terminal:**

```bash
cd mobile

# Update API endpoint for local testing
# Edit lib/config/api_config.dart:
# Change baseUrl to 'http://10.0.2.2:3000/api' (Android emulator)
# Or 'http://localhost:3000/api' (iOS simulator)

# Run app
flutter run
```

## Step 6: Test the App! 🎉

1. **Sign Up**: Create account with email/password
2. **Record**: Tap mic button, speak in Hindi/English
3. **Transcribe**: Stop recording → See transcript
4. **Summarize**: Tap "Generate Summary" → Choose type
5. **Save**: Add title and tags → Save note

## Troubleshooting

### Backend won't start
```bash
# Check Node version
node --version  # Should be 18+

# Check port availability
lsof -ti:3000 | xargs kill  # Kill process on port 3000

# Verify Firebase credentials
ls backend/serviceAccountKey.json  # Should exist
```

### Flutter build fails
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter run
```

### Audio recording not working
- **Android**: Check microphone permission in settings
- **iOS**: Add microphone permission in Info.plist

### Transcription fails
- Verify OpenAI API key in `.env`
- Check backend logs for errors
- Ensure audio file is valid format

## Next Steps

✅ **You're running locally!** Now:

1. **Read Full Docs**: [docs/SETUP.md](docs/SETUP.md)
2. **Follow Implementation Guide**: [docs/IMPLEMENTATION_GUIDE.md](docs/IMPLEMENTATION_GUIDE.md)
3. **Check API Docs**: [docs/API.md](docs/API.md)
4. **Deploy**: Use [scripts/deploy.sh](scripts/deploy.sh)

## Common Commands

```bash
# Backend
npm run dev          # Development server
npm start            # Production server
npm test             # Run tests

# Mobile
flutter run          # Run app
flutter build apk    # Build APK
flutter test         # Run tests
flutter clean        # Clean build files
```

## Need Help?

- 📖 [Full Setup Guide](docs/SETUP.md)
- 🐛 [Report Issues](https://github.com/gjciyxjjgiygjjgci-glitch/smart-ai-notes-app/issues)
- 💬 [Discussions](https://github.com/gjciyxjjgiygjjgci-glitch/smart-ai-notes-app/discussions)

---

**Happy coding! 🎓**
