import 'env_stub.dart'
    if (dart.library.io) 'env_io.dart'
    if (dart.library.html) 'env_web.dart' as platform;

/// Resolves the Django API base URL for the current platform.
class Env {
  /// Override at build/run time: --dart-define=API_BASE_URL=http://192.168.1.5:8000
  static String get apiBaseUrl {
    const override = String.fromEnvironment('API_BASE_URL');
    if (override.isNotEmpty) return override;
    return platform.platformApiBaseUrl();
  }

  static String apiUrl(String path) {
    final normalized = path.startsWith('/') ? path : '/$path';
    return '$apiBaseUrl$normalized';
  }

  static String mediaUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    if (path.startsWith('http')) return path;
    return '$apiBaseUrl$path';
  }
}
