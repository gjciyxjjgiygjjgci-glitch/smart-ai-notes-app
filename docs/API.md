# API Documentation

Base URL: `https://your-api-domain.com/api`

## Authentication

All endpoints require Firebase Authentication token in header:
```
Authorization: Bearer <firebase-id-token>
```

## Endpoints

### 1. Transcribe Audio

**POST** `/transcribe`

Convert audio to text with Hindi + English support.

**Request:**
- Content-Type: `multipart/form-data`
- Body:
  - `audio` (file): Audio file (max 50MB)
  - `language` (string, optional): Language codes (default: "hi-IN,en-IN")
  - `duration` (number, optional): Audio duration in seconds

**Response:**
```json
{
  "success": true,
  "transcript": "Transcribed text here...",
  "language": "hi-IN,en-IN",
  "duration": 120
}
```

---

### 2. Generate Summary

**POST** `/summarize`

Generate study notes from transcript.

**Request:**
```json
{
  "transcript": "Full transcript text...",
  "type": "full",
  "language": "en"
}
```

**Parameters:**
- `transcript` (string, required): The lecture transcript
- `type` (string, required): Summary type
  - `full`: Complete structured notes
  - `5point`: 5-point exam summary
  - `exam`: Exam-ready bullet points
  - `flashcards`: Q&A flashcards
- `language` (string, optional): "en" or "hi" (default: "en")

**Response:**
```json
{
  "success": true,
  "summary": "Generated summary...",
  "type": "full",
  "language": "en"
}
```

---

### 3. Get Notes

**GET** `/notes?userId=<user-id>`

Retrieve all notes for a user.

**Query Parameters:**
- `userId` (string, required): Firebase user ID

**Response:**
```json
{
  "success": true,
  "notes": [
    {
      "id": "note123",
      "userId": "user456",
      "title": "Physics Lecture 1",
      "transcript": "...",
      "summaries": {
        "full": "...",
        "5point": "..."
      },
      "subjectTags": ["physics", "mechanics"],
      "createdAt": "2024-01-15T10:30:00Z",
      "updatedAt": "2024-01-15T10:30:00Z"
    }
  ]
}
```

---

### 4. Create Note

**POST** `/notes`

Create a new note.

**Request:**
```json
{
  "userId": "user456",
  "title": "Chemistry Lecture 3",
  "transcript": "Full transcript...",
  "summaries": {
    "full": "...",
    "5point": "..."
  },
  "subjectTags": ["chemistry", "organic"]
}
```

**Response:**
```json
{
  "success": true,
  "noteId": "note789",
  "note": { ... }
}
```

---

### 5. Update Note

**PUT** `/notes/:id`

Update an existing note.

**Request:**
```json
{
  "title": "Updated title",
  "subjectTags": ["chemistry", "organic", "reactions"]
}
```

**Response:**
```json
{
  "success": true,
  "noteId": "note789"
}
```

---

### 6. Delete Note

**DELETE** `/notes/:id`

Delete a note.

**Response:**
```json
{
  "success": true,
  "noteId": "note789"
}
```

---

## Error Responses

All endpoints return errors in this format:

```json
{
  "error": "Error type",
  "message": "Detailed error message"
}
```

**Common HTTP Status Codes:**
- `400`: Bad Request (missing/invalid parameters)
- `401`: Unauthorized (invalid/missing auth token)
- `403`: Forbidden (insufficient permissions)
- `404`: Not Found
- `500`: Internal Server Error

---

## Rate Limits

**Free Tier:**
- 2 summaries per day
- Max 15 min audio duration
- Max 50MB file size

**Premium Tier:**
- Unlimited summaries
- Max 60 min audio duration
- Max 100MB file size

---

## Example Usage

### cURL Example

```bash
# Transcribe audio
curl -X POST https://api.example.com/api/transcribe \
  -H "Authorization: Bearer <token>" \
  -F "audio=@lecture.mp3" \
  -F "language=hi-IN,en-IN"

# Generate summary
curl -X POST https://api.example.com/api/summarize \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{
    "transcript": "Lecture content...",
    "type": "5point",
    "language": "hi"
  }'
```

### JavaScript Example

```javascript
// Transcribe audio
const formData = new FormData();
formData.append('audio', audioFile);
formData.append('language', 'hi-IN,en-IN');

const response = await fetch('https://api.example.com/api/transcribe', {
  method: 'POST',
  headers: {
    'Authorization': `Bearer ${firebaseToken}`
  },
  body: formData
});

const data = await response.json();
console.log(data.transcript);
```
