import 'dart:io';
import 'package:dio/dio.dart';
import 'package:url_launcher/url_launcher.dart';

class SkinApiClient {
  // بعد ما تعمل adb reverse
  static const String baseUrl = "http://127.0.0.1:5000";

  final Dio _dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 20),
    receiveTimeout: const Duration(seconds: 20),
    headers: {"Accept": "application/json"},
  ));

  /// POST /predict
  Future<({String sessionId, String? userMessage, String response})> analyze({
    required File imageFile,
    String? message,
  }) async {
    final form = FormData.fromMap({
      "image": await MultipartFile.fromFile(
        imageFile.path,
        filename: imageFile.uri.pathSegments.last,
      ),
      if (message != null && message.trim().isNotEmpty) "message": message,
    });

    final res = await _dio.post("/predict", data: form);
    if (res.statusCode == 200 && res.data['success'] == true) {
      return (
        sessionId: res.data['session_id'] as String,
        userMessage: res.data['user_message'] as String?,
        response: res.data['response'] as String,
      );
    }
    throw Exception(res.data?['error'] ?? 'Analyze failed');
  }

  /// POST /chat
  Future<String> followUp({
    required String sessionId,
    required String message,
  }) async {
    final res = await _dio.post("/chat", data: {
      "session_id": sessionId,
      "message": message,
    });

    if (res.statusCode == 200 && res.data['success'] == true) {
      return res.data['response'] as String;
    }
    throw Exception(res.data?['error'] ?? 'Chat failed');
  }

  /// فتح Gemini Chat مع اسم المرض
  static Future<void> launchGeminiChat(String diseaseName) async {
    final geminiUrl = 'https://gemini.google.com/app';
    final prompt =
        "What creams and treatments should I use for $diseaseName? Please provide detailed skincare recommendations.";
    final encodedPrompt = Uri.encodeComponent(prompt);
    final fullUrl = '$geminiUrl?prompt=$encodedPrompt';

    try {
      await launchUrl(Uri.parse(fullUrl), mode: LaunchMode.externalApplication);
    } catch (e) {
      throw Exception('Failed to open Gemini: $e');
    }
  }
}
