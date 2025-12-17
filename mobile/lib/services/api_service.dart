import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_ai_notes/config/api_config.dart';

class ApiService {
  late final Dio _dio;

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: ApiConfig.connectionTimeout,
      receiveTimeout: ApiConfig.receiveTimeout,
      headers: {
        'Content-Type': 'application/json',
      },
    ));

    // Add interceptor for auth token
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final token = await user.getIdToken();
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    ));
  }

  // Transcribe audio
  Future<Map<String, dynamic>> transcribeAudio(
    File audioFile, {
    String language = 'hi-IN,en-IN',
    int? duration,
  }) async {
    try {
      final formData = FormData.fromMap({
        'audio': await MultipartFile.fromFile(
          audioFile.path,
          filename: 'audio.m4a',
        ),
        'language': language,
        if (duration != null) 'duration': duration,
      });

      final response = await _dio.post(
        ApiConfig.transcribeEndpoint,
        data: formData,
      );

      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Generate summary
  Future<Map<String, dynamic>> generateSummary({
    required String transcript,
    required String type,
    String language = 'en',
  }) async {
    try {
      final response = await _dio.post(
        ApiConfig.summarizeEndpoint,
        data: {
          'transcript': transcript,
          'type': type,
          'language': language,
        },
      );

      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Get all notes
  Future<List<dynamic>> getNotes(String userId) async {
    try {
      final response = await _dio.get(
        ApiConfig.notesEndpoint,
        queryParameters: {'userId': userId},
      );

      return response.data['notes'] ?? [];
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Create note
  Future<Map<String, dynamic>> createNote(Map<String, dynamic> noteData) async {
    try {
      final response = await _dio.post(
        ApiConfig.notesEndpoint,
        data: noteData,
      );

      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Update note
  Future<Map<String, dynamic>> updateNote(
    String noteId,
    Map<String, dynamic> updates,
  ) async {
    try {
      final response = await _dio.put(
        '${ApiConfig.notesEndpoint}/$noteId',
        data: updates,
      );

      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Delete note
  Future<void> deleteNote(String noteId) async {
    try {
      await _dio.delete('${ApiConfig.notesEndpoint}/$noteId');
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Error handler
  String _handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
          return 'Connection timeout. Please check your internet.';
        case DioExceptionType.badResponse:
          return error.response?.data['message'] ?? 'Server error occurred';
        default:
          return 'Network error. Please try again.';
      }
    }
    return error.toString();
  }
}
