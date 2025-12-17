# Project Structure

Complete overview of the Smart AI Notes codebase.

## 📁 Repository Structure

```
smart-ai-notes-app/
│
├── backend/                      # Node.js backend API
│   ├── routes/                   # API route handlers
│   │   ├── transcribe.js        # Audio transcription endpoint
│   │   ├── summarize.js         # AI summarization endpoint
│   │   └── notes.js             # Notes CRUD operations
│   │
│   ├── services/                 # Business logic services
│   │   ├── speechService.js     # Google Speech-to-Text integration
│   │   └── summaryService.js    # OpenAI summarization logic
│   │
│   ├── index.js                  # Main server entry point
│   ├── package.json              # Node dependencies
│   ├── .env.example              # Environment variables template
│   └── serviceAccountKey.json    # Firebase credentials (gitignored)
│
├── mobile/                       # Flutter mobile app
│   ├── lib/
│   │   ├── main.dart            # App entry point
│   │   │
│   │   ├── config/              # Configuration files
│   │   │   ├── theme.dart       # App theme & styling
│   │   │   └── api_config.dart  # API endpoints & settings
│   │   │
│   │   ├── models/              # Data models
│   │   │   └── note_model.dart  # Note data structure
│   │   │
│   │   ├── services/            # API & business logic
│   │   │   ├── api_service.dart # Backend API client
│   │   │   ├── auth_service.dart
│   │   │   ├── audio_service.dart
│   │   │   └── storage_service.dart
│   │   │
│   │   ├── providers/           # State management
│   │   │   ├── auth_provider.dart
│   │   │   └── notes_provider.dart
│   │   │
│   │   ├── screens/             # UI screens
│   │   │   ├── splash_screen.dart
│   │   │   ├── auth/
│   │   │   │   ├── login_screen.dart
│   │   │   │   └── signup_screen.dart
│   │   │   ├── home/
│   │   │   │   └── home_screen.dart
│   │   │   ├── recording/
│   │   │   │   ├── record_screen.dart
│   │   │   │   └── transcript_screen.dart
│   │   │   ├── notes/
│   │   │   │   ├── notes_list_screen.dart
│   │   │   │   └── note_detail_screen.dart
│   │   │   └── profile/
│   │   │       └── profile_screen.dart
│   │   │
│   │   └── widgets/             # Reusable UI components
│   │       ├── custom_button.dart
│   │       ├── note_card.dart
│   │       └── waveform_widget.dart
│   │
│   ├── android/                 # Android-specific files
│   │   └── app/
│   │       └── src/main/
│   │           └── AndroidManifest.xml
│   │
│   ├── ios/                     # iOS-specific files
│   │   └── Runner/
│   │       └── Info.plist
│   │
│   ├── assets/                  # Static assets
│   │   ├── images/
│   │   ├── icons/
│   │   └── fonts/
│   │
│   └── pubspec.yaml             # Flutter dependencies
│
├── docs/                        # Documentation
│   ├── API.md                   # API documentation
│   ├── SETUP.md                 # Setup instructions
│   ├── IMPLEMENTATION_GUIDE.md  # Week-by-week guide
│   ├── PLAYSTORE.md             # Play Store listing
│   ├── PRIVACY_POLICY.md        # Privacy policy
│   └── PROJECT_STRUCTURE.md     # This file
│
├── scripts/                     # Utility scripts
│   └── deploy.sh                # Deployment automation
│
├── .gitignore                   # Git ignore rules
├── LICENSE                      # MIT License
├── README.md                    # Project overview
├── QUICKSTART.md                # Quick setup guide
├── PROJECT_SUMMARY.md           # Business summary
└── CONTRIBUTING.md              # Contribution guidelines
```

---

## 🔧 Backend Architecture

### API Endpoints

```
POST /api/transcribe
├── Input: Audio file (multipart/form-data)
├── Process: Google Speech-to-Text
└── Output: Transcript text

POST /api/summarize
├── Input: Transcript + type + language
├── Process: OpenAI GPT-4o-mini
└── Output: Summary (full/5point/exam)

GET /api/notes?userId=xxx
├── Auth: Firebase token
└── Output: List of user notes

POST /api/notes
├── Input: Note data
└── Output: Created note

PUT /api/notes/:id
├── Input: Updated fields
└── Output: Success status

DELETE /api/notes/:id
└── Output: Success status
```

### Service Layer

**speechService.js**
- `transcribeAudio()` - Convert audio to text
- `chunkAudio()` - Split long audio files

**summaryService.js**
- `generateSummary()` - Create AI summaries
- `summarizeChunk()` - Process text chunks
- `aggregateSummaries()` - Combine chunk summaries
- `chunkTranscript()` - Split long transcripts

---

## 📱 Mobile App Architecture

### State Management (Provider)

```dart
MultiProvider
├── AuthProvider
│   ├── currentUser
│   ├── isAuthenticated
│   ├── signIn()
│   ├── signUp()
│   └── signOut()
│
└── NotesProvider
    ├── notes[]
    ├── isLoading
    ├── fetchNotes()
    ├── createNote()
    ├── updateNote()
    └── deleteNote()
```

### Screen Flow

```
SplashScreen
    ↓
AuthCheck
    ├── Not Authenticated → LoginScreen → SignupScreen
    └── Authenticated → HomeScreen
                            ├── RecordScreen → TranscriptScreen → SummaryScreen
                            ├── NotesListScreen → NoteDetailScreen
                            └── ProfileScreen
```

### Key Services

**ApiService**
- HTTP client (Dio)
- Auth token injection
- Error handling
- API calls to backend

**AudioService**
- Record audio
- Play audio
- Save to file
- Upload to backend

**StorageService**
- Local storage (SharedPreferences)
- Cache management
- Offline data

---

## 🗄️ Data Models

### Note Model

```dart
class Note {
  String id;
  String userId;
  String title;
  String transcript;
  Map<String, String> summaries;  // {full, 5point, exam}
  List<String> subjectTags;
  DateTime createdAt;
  DateTime updatedAt;
}
```

### User Model

```dart
class User {
  String id;
  String email;
  String name;
  bool isPremium;
  int dailySummariesUsed;
  DateTime lastResetDate;
}
```

---

## 🔐 Security

### Backend
- Firebase Admin SDK for auth verification
- Environment variables for secrets
- CORS configuration
- Rate limiting (planned)

### Mobile
- Firebase Authentication
- Secure token storage
- HTTPS only
- Certificate pinning (planned)

### Database (Firestore)
```javascript
// Security Rules
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /notes/{noteId} {
      allow read, write: if request.auth.uid == resource.data.userId;
    }
  }
}
```

---

## 🎨 UI/UX Structure

### Theme System

**Colors**
- Primary: #6C63FF (Purple)
- Secondary: #4CAF50 (Green)
- Accent: #FF6B6B (Red)
- Background: #F5F7FA
- Text: #2D3436

**Typography**
- Font: Poppins
- Display: 32px, Bold
- Heading: 24px, Bold
- Body: 16px, Regular
- Caption: 14px, Regular

### Component Library

**Buttons**
- Primary Button
- Secondary Button
- Icon Button
- Floating Action Button

**Cards**
- Note Card
- Summary Card
- Feature Card

**Inputs**
- Text Field
- Search Bar
- Tag Input

---

## 📦 Dependencies

### Backend (package.json)
```json
{
  "express": "^4.18.2",
  "firebase-admin": "^12.0.0",
  "openai": "^4.20.1",
  "@google-cloud/speech": "^6.0.0",
  "multer": "^1.4.5",
  "cors": "^2.8.5",
  "dotenv": "^16.3.1"
}
```

### Mobile (pubspec.yaml)
```yaml
dependencies:
  firebase_core: ^2.24.2
  firebase_auth: ^4.15.3
  cloud_firestore: ^4.13.6
  firebase_storage: ^11.5.6
  record: ^5.0.4
  audioplayers: ^5.2.1
  dio: ^5.4.0
  provider: ^6.1.1
  pdf: ^3.10.7
  google_fonts: ^6.1.0
```

---

## 🧪 Testing Structure

### Backend Tests
```
backend/
└── tests/
    ├── routes/
    │   ├── transcribe.test.js
    │   ├── summarize.test.js
    │   └── notes.test.js
    └── services/
        ├── speechService.test.js
        └── summaryService.test.js
```

### Mobile Tests
```
mobile/
└── test/
    ├── unit/
    │   ├── models/
    │   └── services/
    ├── widget/
    │   └── screens/
    └── integration/
        └── app_test.dart
```

---

## 🚀 Deployment Structure

### Backend Deployment Options

**Option 1: Railway**
```
railway.json
├── build: npm install
├── start: npm start
└── env: Production variables
```

**Option 2: Firebase Functions**
```
firebase.json
├── functions/
│   ├── source: backend
│   └── runtime: nodejs18
└── hosting: (optional)
```

### Mobile Deployment

**Android**
```
mobile/android/
├── app/
│   ├── build.gradle
│   └── key.properties
└── gradle.properties
```

**Build Commands**
```bash
flutter build apk --release
flutter build appbundle --release
```

---

## 📊 Analytics Structure

### Events to Track

**User Actions**
- app_open
- sign_up
- sign_in
- record_start
- record_stop
- transcribe_success
- summarize_request
- note_save
- note_share
- premium_purchase

**Performance**
- transcription_duration
- summarization_duration
- api_response_time
- app_crash

---

## 🔄 CI/CD Pipeline (Future)

```yaml
# .github/workflows/deploy.yml
name: Deploy
on: [push]
jobs:
  backend:
    - Test backend
    - Deploy to Railway
  mobile:
    - Test Flutter app
    - Build APK
    - Upload to Play Store (beta)
```

---

## 📝 Configuration Files

### Environment Variables

**Backend (.env)**
```env
PORT=3000
NODE_ENV=production
FIREBASE_PROJECT_ID=xxx
OPENAI_API_KEY=xxx
GOOGLE_APPLICATION_CREDENTIALS=xxx
```

**Mobile (api_config.dart)**
```dart
static const String baseUrl = 'https://api.example.com';
static const int maxAudioDuration = 900;
static const int freeSummariesPerDay = 2;
```

---

## 🎯 Next Steps

1. **Complete missing files** (screens, providers, services)
2. **Implement authentication flow**
3. **Build recording functionality**
4. **Integrate AI services**
5. **Test end-to-end**
6. **Deploy & launch**

---

**For detailed implementation, see [IMPLEMENTATION_GUIDE.md](IMPLEMENTATION_GUIDE.md)**
