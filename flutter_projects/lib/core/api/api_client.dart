import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/env.dart';
import '../storage/token_storage.dart';

class ApiClient {
  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<Map<String, String>> _headers({bool authenticated = false}) async {
    final headers = {'Content-Type': 'application/json'};
    if (authenticated) {
      var token = await TokenStorage.getAccessToken();
      if (token != null && _isExpired(token)) {
        token = await _refreshAccessToken();
      }
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  bool _isExpired(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return true;
      final payload =
          jsonDecode(
                utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
              )
              as Map<String, dynamic>;
      final expiresAt = payload['exp'] as int?;
      if (expiresAt == null) return true;
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      return expiresAt <= now + 30;
    } catch (_) {
      return true;
    }
  }

  Future<String?> _refreshAccessToken() async {
    final refreshToken = await TokenStorage.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) return null;

    final response = await _client.post(
      Uri.parse(Env.apiUrl('/api/token/refresh/')),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refresh': refreshToken}),
    );
    if (response.statusCode != 200) return null;

    final data = decodeBody(response) as Map<String, dynamic>;
    final accessToken = data['access'] as String?;
    if (accessToken == null || accessToken.isEmpty) return null;
    await TokenStorage.saveAccessToken(accessToken);
    return accessToken;
  }

  Future<http.Response> get(String path, {bool authenticated = false}) async {
    return _client.get(
      Uri.parse(Env.apiUrl(path)),
      headers: await _headers(authenticated: authenticated),
    );
  }

  Future<http.Response> post(
    String path, {
    Map<String, dynamic>? body,
    bool authenticated = false,
  }) async {
    return _client.post(
      Uri.parse(Env.apiUrl(path)),
      headers: await _headers(authenticated: authenticated),
      body: body == null ? null : jsonEncode(body),
    );
  }

  Future<http.StreamedResponse> multipart(
    String path, {
    required String method,
    Map<String, String>? fields,
    List<http.MultipartFile>? files,
    bool authenticated = true,
  }) async {
    final request = http.MultipartRequest(method, Uri.parse(Env.apiUrl(path)));
    final headers = await _headers(authenticated: authenticated);
    headers.remove('Content-Type');
    request.headers.addAll(headers);
    if (fields != null) request.fields.addAll(fields);
    if (files != null) request.files.addAll(files);
    return _client.send(request);
  }

  static dynamic decodeBody(http.Response response) {
    if (response.body.isEmpty) return {};
    return jsonDecode(response.body);
  }
}
