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
      final token = await TokenStorage.getAccessToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  Future<http.Response> get(
    String path, {
    bool authenticated = false,
  }) async {
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
