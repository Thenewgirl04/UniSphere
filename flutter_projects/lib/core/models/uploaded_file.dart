import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

class UploadedFile {
  const UploadedFile({
    required this.bytes,
    required this.filename,
  });

  final Uint8List bytes;
  final String filename;

  static Future<UploadedFile> fromXFile(XFile file) async {
    final name = file.name.isNotEmpty ? file.name : 'upload.jpg';
    return UploadedFile(
      bytes: await file.readAsBytes(),
      filename: name,
    );
  }
}
