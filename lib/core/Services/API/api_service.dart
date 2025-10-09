import 'dart:io';
import 'package:dio/dio.dart';
import 'package:url_launcher/url_launcher.dart';

class SkinApiClient {
  // بعد ما تعمل adb reverse
  static const String baseUrl = "http://127.0.0.1:5001";

  final Dio _dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 20),
    receiveTimeout: const Duration(seconds: 20),
    headers: {"Accept": "application/json"},
  ));

  /// التحقق من حالة الخادم
  Future<bool> checkServerStatus() async {
    try {
      // استخدام POST /chat مع بيانات فارغة للتحقق من الاتصال
      final response = await _dio
          .post('/chat', data: {"session_id": "test", "message": "test"});
      return response.statusCode == 200;
    } catch (e) {
      // إذا فشل /chat، جرب GET / (إذا كان موجود)
      try {
        final response = await _dio.get('/');
        return response.statusCode == 200;
      } catch (e2) {
        return false;
      }
    }
  }

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
    if (res.statusCode == 200) {
      return (
        sessionId: res.data['session_id'] as String? ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        userMessage: res.data['user_message'] as String?,
        response: res.data['response'] as String? ?? res.data.toString(),
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

    if (res.statusCode == 200) {
      // التحقق من وجود خطأ في الاستجابة
      if (res.data['error'] != null) {
        // إرسال خطأ خاص للتعامل مع انتهاء الجلسة
        if (res.data['error'].toString().contains('Session expired')) {
          throw Exception('Session expired. Please start a new analysis.');
        }
        throw Exception(res.data['error']);
      }

      // التحقق من وجود response في البيانات
      if (res.data['response'] != null) {
        return res.data['response'] as String;
      } else if (res.data['message'] != null) {
        return res.data['message'] as String;
      } else if (res.data['reply'] != null) {
        return res.data['reply'] as String;
      } else {
        // إذا لم نجد response، نعيد البيانات كاملة
        return res.data.toString();
      }
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
