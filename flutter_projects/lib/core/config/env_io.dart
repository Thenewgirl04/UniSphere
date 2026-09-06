import 'dart:io' show Platform;

String platformApiBaseUrl() {
  if (Platform.isAndroid) {
    // Android emulator maps 10.0.2.2 to the host machine.
    return 'http://10.0.2.2:8000';
  }
  return 'http://127.0.0.1:8000';
}
