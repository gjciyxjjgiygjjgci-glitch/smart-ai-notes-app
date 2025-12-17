const OpenAI = require('openai');

const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY
});

// Prompts for different summary types
const PROMPTS = {
  full_en: `You are an expert academic note-taker. Given the following lecture transcript, produce structured study notes in English. Use headings, short paragraphs, numbered lists for processes, and bold key terms. Include:
- A 2-sentence overview.
- Important definitions (bullet list).
- Key points with short explanations (5–12 bullets).
- Example(s) if present in transcript.
- 3 quick "Exam Tips" (one-liners).
Output format: Markdown.`,

  full_hi: `आप एक अनुभवी स्टडी नोट-मेकर हैं। नीचे दिया गया लेक्चर ट्रांसक्रिप्ट पढ़कर हिंदी में स्टडी नोट्स बनाइए। आवश्यक चीजें:
- 2 वाक्य का overview.
- आवश्यक परिभाषाएँ (बुलेट सूची).
- मुख्य बिंदु (5–12 बुलेट) — हर बुलेट में 1–2 वाक्य की short explanation.
- यदि वे उदाहरण बोले हैं तो एक छोटा उदाहरण दें.
- 3 तेज़ "Exam Tips" (one-liner).
Output format: Markdown.`,

  '5point': `Task: Convert the transcript into a 5-point exam-ready summary. Each point max 18 words. Also include up to 3 key formulas or dates (if any). Write in the user's preferred language: {lang}.
Output: Plain text, 5 short bullets + "Key facts" section.`,

  exam: `Create exam-ready bullet points from this transcript. Focus on:
- Key definitions (bold)
- Important dates/formulas
- Cause-effect relationships
- Examples
- Quick revision points
Language: {lang}
Output: Concise bullet points.`,

  flashcards: `Given the transcript, extract up to 10 Q/A flashcards. Each Q should be concise (one question). Each A should be 1–2 sentences. Prefer fact-based or definitional Qs. Language: {lang}.
Output: JSON array of objects: [{"q":"...","a":"..."}, ...]`
};

/**
 * Generate summary from transcript using OpenAI
 */
async function generateSummary(transcript, type = 'full', language = 'en') {
  try {
    // Select appropriate prompt
    let promptKey = type;
    if (type === 'full') {
      promptKey = language === 'hi' ? 'full_hi' : 'full_en';
    }

    let systemPrompt = PROMPTS[promptKey] || PROMPTS.full_en;
    systemPrompt = systemPrompt.replace('{lang}', language);

    // Chunk transcript if too long (>4000 tokens ≈ 3000 words)
    const chunks = chunkTranscript(transcript, 3000);
    
    if (chunks.length === 1) {
      // Single chunk - direct summarization
      return await summarizeChunk(transcript, systemPrompt);
    } else {
      // Multiple chunks - summarize each then aggregate
      const chunkSummaries = await Promise.all(
        chunks.map(chunk => summarizeChunk(chunk, systemPrompt))
      );
      
      // Aggregate summaries
      return await aggregateSummaries(chunkSummaries, systemPrompt);
    }

  } catch (error) {
    console.error('Summary generation error:', error);
    throw new Error('Failed to generate summary');
  }
}

/**
 * Summarize a single chunk
 */
async function summarizeChunk(text, systemPrompt) {
  const response = await openai.chat.completions.create({
    model: 'gpt-4o-mini',
    messages: [
      { role: 'system', content: systemPrompt },
      { role: 'user', content: `Transcript:\n${text}` }
    ],
    max_tokens: 800,
    temperature: 0.3
  });

  return response.choices[0].message.content;
}

/**
 * Aggregate multiple chunk summaries
 */
async function aggregateSummaries(summaries, systemPrompt) {
  const combined = summaries.join('\n\n---\n\n');
  
  const response = await openai.chat.completions.create({
    model: 'gpt-4o-mini',
    messages: [
      { role: 'system', content: systemPrompt + '\n\nCombine these summaries into one coherent summary, removing duplicates.' },
      { role: 'user', content: combined }
    ],
    max_tokens: 1000,
    temperature: 0.3
  });

  return response.choices[0].message.content;
}

/**
 * Chunk transcript by word count
 */
function chunkTranscript(text, maxWords = 3000) {
  const words = text.split(/\s+/);
  const chunks = [];
  
  for (let i = 0; i < words.length; i += maxWords) {
    chunks.push(words.slice(i, i + maxWords).join(' '));
  }
  
  return chunks;
}

module.exports = {
  generateSummary
};
