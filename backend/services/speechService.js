const speech = require('@google-cloud/speech');

// Initialize Google Speech client
const client = new speech.SpeechClient();

/**
 * Transcribe audio buffer to text
 * Supports Hindi + English with Indian accent optimization
 */
async function transcribeAudio(audioBuffer, language = 'hi-IN,en-IN') {
  try {
    const audio = {
      content: audioBuffer.toString('base64'),
    };

    const config = {
      encoding: 'LINEAR16',
      sampleRateHertz: 16000,
      languageCode: language.split(',')[0], // Primary language
      alternativeLanguageCodes: language.split(',').slice(1), // Additional languages
      enableAutomaticPunctuation: true,
      enableWordTimeOffsets: false,
      model: 'default',
      useEnhanced: true,
    };

    const request = {
      audio: audio,
      config: config,
    };

    const [response] = await client.recognize(request);
    const transcription = response.results
      .map(result => result.alternatives[0].transcript)
      .join('\n');

    return transcription;

  } catch (error) {
    console.error('Speech-to-text error:', error);
    throw new Error('Failed to transcribe audio');
  }
}

/**
 * Chunk long audio for processing
 * Split audio into manageable segments
 */
function chunkAudio(audioBuffer, chunkSizeSeconds = 60) {
  // Implementation for chunking audio
  // This is a placeholder - actual implementation depends on audio format
  return [audioBuffer];
}

module.exports = {
  transcribeAudio,
  chunkAudio
};
