const express = require('express');
const router = express.Router();
const { generateSummary } = require('../services/summaryService');

/**
 * POST /api/summarize
 * Generate study notes from transcript
 * Types: full, 5point, exam
 */
router.post('/', async (req, res) => {
  try {
    const { transcript, type = 'full', language = 'en' } = req.body;

    if (!transcript) {
      return res.status(400).json({ error: 'Transcript is required' });
    }

    const validTypes = ['full', '5point', 'exam', 'flashcards'];
    if (!validTypes.includes(type)) {
      return res.status(400).json({ 
        error: 'Invalid summary type',
        validTypes 
      });
    }

    const summary = await generateSummary(transcript, type, language);

    res.json({
      success: true,
      summary: summary,
      type: type,
      language: language
    });

  } catch (error) {
    console.error('Summarization error:', error);
    res.status(500).json({ 
      error: 'Summarization failed',
      message: error.message 
    });
  }
});

module.exports = router;
