import 'dart:convert';

import 'package:http/http.dart';

class ApiHandler {
  final String baseUrl;
  final Map<String, String> defaultHeaders;

  ApiHandler(
      {required this.baseUrl,
      this.defaultHeaders = const {'Content-Type': 'application/json'}});

  Future<dynamic> postRequest(String endpoint,
      {Map<String, dynamic>? body}) async {
    final response = await post(
      Uri.parse('$baseUrl$endpoint'),
      headers: defaultHeaders,
      body: body != null ? jsonEncode(body) : null,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<T>> getList<T>(String endpoint,
      {Map<String, dynamic>? body,
      required T Function(Map<String, dynamic>) fromJson}) async {
    final data = await postRequest(endpoint, body: body);
    List<dynamic> dataList = data['results'];
    return dataList.map<T>((item) => fromJson(item)).toList();
  }
}

// Example usage
// SleepQuality sleepQuality = await apiHandler.getSingle(
// '/getSleepQuality',
// body: {'userId': 'user123'},
// fromJson: (json) => SleepQuality.fromJson(json),
// );
