// import 'dart:convert';

// import 'package:http/http.dart';

// class ApiHandler {
//   final String baseUrl;
//   final Map<String, String> defaultHeaders;

//   ApiHandler(
//       {required this.baseUrl,
//       this.defaultHeaders = const {'Content-Type': 'application/json'}});

//   Future<dynamic> postRequest(String endpoint,
//       {Map<String, dynamic>? body}) async {
//     final response = await post(
//       Uri.parse('$baseUrl$endpoint'),
//       headers: defaultHeaders,
//       body: body != null ? jsonEncode(body) : null,
//     );

//     if (response.statusCode == 200) {
//       return jsonDecode(response.body);
//     } else {
//       throw Exception('Failed to load data');
//     }
//   }

//   Future<List<T>> getList<T>(String endpoint,
//       {Map<String, dynamic>? body,
//       required T Function(Map<String, dynamic>) fromJson}) async {
//     final data = await postRequest(endpoint, body: body);
//     List<dynamic> dataList = data['results'];
//     return dataList.map<T>((item) => fromJson(item)).toList();
//   }
// }

// // Example usage
// // SleepQuality sleepQuality = await apiHandler.getSingle(
// // '/getSleepQuality',
// // body: {'userId': 'user123'},
// // fromJson: (json) => SleepQuality.fromJson(json),
// // );

import 'dart:io';
import 'package:dio/dio.dart';

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
}
