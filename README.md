# Smart AI Notes — Voice to Study 📚🎙️

A mobile app that converts voice/text lectures into structured study notes with Hindi + English support.

## 🎯 Target Users
- College students
- Competitive exam aspirants
- Working professionals

## ✨ Key Features

### MVP (Current)
- 🎤 Record audio lectures (10-15 min)
- 📝 Transcribe Hindi + English (Indian accents)
- 📊 Generate 3 summary formats:
  - Full structured notes
  - 5-point exam summary
  - Exam-ready bullet points
- 🏷️ Organize by subject/tags
- 📤 Export to PDF/text
- 📱 Mobile-first design

### Roadmap
- **v1**: Longer recordings, flashcards, quiz generator, premium tier
- **v2**: YouTube/PDF integration, collaboration, offline mode

## 🛠️ Tech Stack

### Frontend
- Flutter (cross-platform)
- Material Design UI

### Backend
- Node.js + Express
- Firebase Functions (serverless)

### Services
- **Auth**: Firebase Auth
- **Database**: Firestore
- **Storage**: Firebase Storage
- **Speech-to-Text**: Google Speech API / Device SpeechRecognizer
- **AI Summarization**: OpenAI/Gemini API
- **Analytics**: Firebase Analytics
- **Monetization**: AdMob + In-app purchases

## 📁 Project Structure

```
smart-ai-notes-app/
├── mobile/              # Flutter mobile app
│   ├── lib/
│   │   ├── main.dart
│   │   ├── screens/
│   │   ├── services/
│   │   └── models/
│   └── pubspec.yaml
├── backend/             # Node.js API
│   ├── functions/
│   │   ├── index.js
│   │   ├── transcribe.js
│   │   └── summarize.js
│   └── package.json
├── docs/               # Documentation
└── scripts/            # Utility scripts
```

## 🚀 Quick Start

### Prerequisites
- Flutter SDK
- Node.js 18+
- Firebase CLI
- Android Studio / Xcode

### Setup

1. **Clone repository**
```bash
git clone https://github.com/gjciyxjjgiygjjgci-glitch/smart-ai-notes-app.git
cd smart-ai-notes-app
```

2. **Backend setup**
```bash
cd backend
npm install
firebase login
firebase init
```

3. **Mobile setup**
```bash
cd mobile
flutter pub get
flutter run
```

## 💰 Monetization

- **Free Tier**: 2 summaries/day with ads
- **Premium** (₹99/month): Unlimited transcripts, no ads, PDF export
- **Subject Packs**: Exam-specific note collections

## 📊 Data Model

- **User**: id, name, email, preferences, premium_flag
- **Note**: id, user_id, title, subject_tags, timestamps
- **Recording**: id, note_id, storage_url, duration, transcript
- **Summary**: id, note_id, summary_type, summary_text

## 🔒 Privacy & Security

- Clear privacy policy
- User consent before recording
- Data deletion options
- Secure audio storage

## 📈 Growth Strategy

- Campus ambassadors
- WhatsApp/Telegram groups
- Short demo videos (Reels/TikTok)
- Early adopter benefits

## 🤝 Contributing

Contributions welcome! Please read CONTRIBUTING.md first.

## 📄 License

MIT License - see LICENSE file

## 📞 Contact

For questions or support, open an issue or contact the team.

---

**Built with ❤️ for students by students**
