const express = require('express');
const router = express.Router();
const multer = require('multer');
const { transcribeAudio } = require('../services/speechService');

const upload = multer({ 
  storage: multer.memoryStorage(),
  limits: { fileSize: 50 * 1024 * 1024 } // 50MB limit
});

/**
 * POST /api/transcribe
 * Transcribe audio file to text
 * Supports Hindi + English
 */
router.post('/', upload.single('audio'), async (req, res) => {
  try {
    const { language = 'hi-IN,en-IN' } = req.body;
    
    if (!req.file) {
      return res.status(400).json({ error: 'No audio file provided' });
    }

    const audioBuffer = req.file.buffer;
    const transcript = await transcribeAudio(audioBuffer, language);

    res.json({
      success: true,
      transcript: transcript,
      language: language,
      duration: req.body.duration || null
    });

  } catch (error) {
    console.error('Transcription error:', error);
    res.status(500).json({ 
      error: 'Transcription failed',
      message: error.message 
    });
  }
});

module.exports = router;
