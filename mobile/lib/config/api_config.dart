class ApiConfig {
  // Base URL - Update this with your deployed backend URL
  static const String baseUrl = 'http://10.0.2.2:3000/api'; // For Android emulator
  // static const String baseUrl = 'http://localhost:3000/api'; // For iOS simulator
  // static const String baseUrl = 'https://your-backend-url.com/api'; // For production
  
  // API Endpoints
  static const String transcribeEndpoint = '/transcribe';
  static const String summarizeEndpoint = '/summarize';
  static const String notesEndpoint = '/notes';
  
  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 60);
  
  // Limits
  static const int maxAudioDurationSeconds = 900; // 15 minutes
  static const int maxFileSizeMB = 50;
  static const int freeSummariesPerDay = 2;
}
