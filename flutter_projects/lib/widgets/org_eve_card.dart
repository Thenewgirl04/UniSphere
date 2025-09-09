import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import "package:path/path.dart";

class OrgEveCard extends StatefulWidget {
  final Map event;
  final Future<void> Function(int eventId, File imageFile) onPost;


  const OrgEveCard({super.key, required this.event, required this.onPost});

  @override
  State<OrgEveCard> createState() => _OrgEveCardState();
}

class _OrgEveCardState extends State<OrgEveCard> {
  File? _selectedImage;


  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'pending':
      default:
        return Colors.orange;
    }
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final String title = widget.event['name'] ?? 'Untitled';
    final String status = widget.event['status'] ?? 'Pending';
    final bool isPosted = widget.event['is_posted'] ?? false;
    final int eventId = widget.event['id'];

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1.5,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          // Event title
          Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: _getStatusColor(status).withOpacity(0.2),
            border: Border.all(color: _getStatusColor(status)),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            status[0].toUpperCase() + status.substring(1),
            style: TextStyle(
              color: _getStatusColor(status),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
            const SizedBox(height: 12),
          if (status == 'approved' && isPosted == false) ...[
            // Image preview if selected
            if (_selectedImage != null) ...[
            Image.file(
            _selectedImage!,
            height: 120,
            width: double.infinity,
            fit: BoxFit.cover,
            ),
              const SizedBox(height: 8),
              ],
              // Upload button
              ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.image),
              label: const Text("Upload Flyer"),
              ),

              ElevatedButton.icon(
            onPressed: _selectedImage == null
              ? null
              : () async {
              await widget.onPost(eventId, _selectedImage!);
            },
            icon: const Icon(Icons.send),
            label: const Text("Post"),
          ),
          ],
            if (isPosted && widget.event['flyer'] != null) ...[
              SizedBox(height: 8),
              Image.network(
                'http://10.0.2.2:8000${widget.event['flyer']}',
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image),
              ),
            ],
          ],
          ),
          ),
        );
  }
}
