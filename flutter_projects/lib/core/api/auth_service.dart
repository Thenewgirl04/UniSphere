import '../api/api_client.dart';
import '../storage/token_storage.dart';

class AuthService {
  AuthService({ApiClient? apiClient}) : _api = apiClient ?? ApiClient();

  final ApiClient _api;

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await _api.post(
      '/api/token/',
      body: {'email': email, 'password': password},
    );
    final data = ApiClient.decodeBody(response);

    if (response.statusCode != 200) {
      final detail = data['detail'];
      final message = detail is List
          ? detail.first.toString()
          : detail?.toString() ?? 'Login failed';
      throw AuthException(message);
    }

    await TokenStorage.saveSession(
      accessToken: data['access'] as String,
      refreshToken: data['refresh'] as String,
      name: data['name'] as String? ?? data['first_name'] as String? ?? '',
      userType: data['user_type'] as String,
    );

    return Map<String, dynamic>.from(data as Map);
  }

  Future<void> registerStudent({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final response = await _api.post(
      '/api/register/',
      body: {
        'full_name': fullName,
        'email': email,
        'password': password,
      },
    );
    final data = ApiClient.decodeBody(response);

    if (response.statusCode != 201) {
      final message = data['email']?.first ??
          data['error'] ??
          data.values.first?.first ??
          'Registration failed';
      throw AuthException(message.toString());
    }
  }

  Future<void> registerOrganization({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await _api.post(
      '/api/org/register/',
      body: {
        'name': name,
        'email': email,
        'password': password,
      },
    );
    final data = ApiClient.decodeBody(response);

    if (response.statusCode != 201) {
      final message = data['email']?.first ??
          data['name']?.first ??
          data['password']?.first ??
          'Registration failed';
      throw AuthException(message.toString());
    }
  }

  Future<void> logout() => TokenStorage.clear();
}

class AuthException implements Exception {
  AuthException(this.message);
  final String message;

  @override
  String toString() => message;
}
