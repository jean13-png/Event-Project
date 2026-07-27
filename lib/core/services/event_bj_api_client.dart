import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiException implements Exception {
  final int? statusCode;
  final String message;
  ApiException(this.statusCode, this.message);

  @override
  String toString() => 'ApiException($statusCode): $message';
}

class EventBjApiClient {
  EventBjApiClient({
    required this.baseUrl,
    required this.auth,
    required http.Client httpClient,
  }) : _httpClient = kIsWeb ? http.Client() : httpClient;

  final String baseUrl;
  final FirebaseAuth auth;
  final http.Client _httpClient;

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, String>? queryParameters,
  }) async {
    final uri = Uri.parse('$baseUrl$path').replace(queryParameters: queryParameters);
    final response = await _httpClient.get(await _withToken(uri), headers: _headers());
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
  }) async {
    final uri = Uri.parse('$baseUrl$path');
    final response = await _httpClient.post(
      await _withToken(uri),
      headers: _headers(),
      body: body != null ? jsonEncode(body) : null,
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> _handleResponse(http.Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      return compute(_decodeJson, response.body);
    } else {
      final data = jsonDecode(response.body);
      throw ApiException(response.statusCode, data?['error'] ?? 'Request failed');
    }
  }

  static Map<String, dynamic> _decodeJson(String body) {
    try {
      return jsonDecode(body) as Map<String, dynamic>;
    } catch (_) {
      return {'raw': body};
    }
  }

  Future<Uri> _withToken(Uri uri) async {
    final user = auth.currentUser;
    if (user == null) throw ApiException(401, 'User not authenticated');
    final token = await user.getIdToken();
    return uri.replace(fragment: 'token=$token');
  }

  Map<String, String> _headers() {
    return const {'Content-Type': 'application/json'};
  }
}
