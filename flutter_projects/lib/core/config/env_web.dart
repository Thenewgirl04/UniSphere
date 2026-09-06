import 'dart:html' as html;

String platformApiBaseUrl() {
  final host = html.window.location.hostname;
  if (host != null && host.isNotEmpty) {
    return 'http://$host:8000';
  }
  return 'http://127.0.0.1:8000';
}
