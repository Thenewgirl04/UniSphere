import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_projects/core/config/env.dart';
import 'package:flutter_projects/core/models/uploaded_file.dart';
import 'package:image_picker/image_picker.dart';

class OrgEveCard extends StatefulWidget {
  const OrgEveCard({
    super.key,
    required this.event,
    required this.onPost,
  });

  final Map<String, dynamic> event;
  final Future<void> Function(int eventId, UploadedFile flyer) onPost;

  @override
  State<OrgEveCard> createState() => _OrgEveCardState();
}

class _OrgEveCardState extends State<OrgEveCard> {
  Uint8List? _previewBytes;
  UploadedFile? _selectedFile;
  bool _isPosting = false;

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'posted':
        return Colors.blue;
      default:
        return Colors.orange;
    }
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    final file = await UploadedFile.fromXFile(picked);
    setState(() {
      _selectedFile = file;
      _previewBytes = file.bytes;
    });
  }

  Future<void> _publish(int eventId) async {
    if (_selectedFile == null) return;

    setState(() => _isPosting = true);
    try {
      await widget.onPost(eventId, _selectedFile!);
    } finally {
      if (mounted) setState(() => _isPosting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.event['name'] ?? 'Untitled';
    final status = widget.event['status'] ?? 'pending';
    final eventId = widget.event['id'] as int;
    final flyer = widget.event['flyer'] as String?;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: _statusColor(status).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                status[0].toUpperCase() + status.substring(1),
                style: TextStyle(color: _statusColor(status), fontWeight: FontWeight.w600),
              ),
            ),
            if (status == 'approved') ...[
              const SizedBox(height: 12),
              if (_previewBytes != null)
                Image.memory(
                  _previewBytes!,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.image),
                label: const Text('Choose Flyer'),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: _selectedFile == null || _isPosting
                    ? null
                    : () => _publish(eventId),
                icon: _isPosting
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.send),
                label: const Text('Publish Event'),
              ),
            ],
            if (status == 'posted' && flyer != null && flyer.isNotEmpty) ...[
              const SizedBox(height: 12),
              Image.network(
                Env.mediaUrl(flyer),
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
