import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_projects/core/api/auth_service.dart';
import 'package:flutter_projects/core/api/event_service.dart';
import 'package:flutter_projects/core/config/env.dart';
import 'package:flutter_projects/core/models/uploaded_file.dart';
import 'package:flutter_projects/screens/entry_screen.dart';
import 'package:image_picker/image_picker.dart';

class OrgProfileScreen extends StatefulWidget {
  const OrgProfileScreen({super.key});

  @override
  State<OrgProfileScreen> createState() => _OrgProfileScreenState();
}

class _OrgProfileScreenState extends State<OrgProfileScreen> {
  final _eventService = EventService();
  final _authService = AuthService();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  String selectedCategory = 'Technology';
  Uint8List? _previewBytes;
  UploadedFile? _selectedLogo;
  String? existingLogoUrl;
  bool isLoading = true;
  bool isEditable = false;
  bool isSaving = false;

  final categoryOptions = ['Technology', 'Arts', 'Health', 'Sports'];

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    try {
      final profile = await _eventService.fetchOrgProfile();
      if (!mounted) return;
      setState(() {
        nameController.text = profile['name'] as String? ?? '';
        descriptionController.text = profile['description'] as String? ?? '';
        selectedCategory = profile['category'] as String? ?? 'Technology';
        existingLogoUrl = profile['logo'] as String?;
        isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    final file = await UploadedFile.fromXFile(picked);
    setState(() {
      _selectedLogo = file;
      _previewBytes = file.bytes;
    });
  }

  Widget _avatar() {
    if (_previewBytes != null) {
      return CircleAvatar(radius: 50, backgroundImage: MemoryImage(_previewBytes!));
    }
    if (existingLogoUrl != null && existingLogoUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: 50,
        backgroundImage: NetworkImage(Env.mediaUrl(existingLogoUrl)),
      );
    }
    return const CircleAvatar(radius: 50, child: Icon(Icons.business, size: 40));
  }

  Future<void> _saveProfile() async {
    setState(() => isSaving = true);
    try {
      await _eventService.updateOrgProfile(
        name: nameController.text.trim(),
        category: selectedCategory,
        description: descriptionController.text.trim(),
        logo: _selectedLogo,
      );
      if (!mounted) return;
      setState(() {
        isEditable = false;
        isSaving = false;
        _selectedLogo = null;
        _previewBytes = null;
      });
      await _loadProfile();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated')),
      );
    } on EventException catch (e) {
      if (!mounted) return;
      setState(() => isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    }
  }

  Future<void> _logout() async {
    await _authService.logout();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const EntryScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Organization Profile'),
        actions: [
          IconButton(onPressed: _logout, icon: const Icon(Icons.logout)),
          TextButton(
            onPressed: isLoading
                ? null
                : () {
                    if (isEditable) {
                      _saveProfile();
                    } else {
                      setState(() => isEditable = true);
                    }
                  },
            child: Text(isEditable ? (isSaving ? 'Saving...' : 'Save') : 'Edit'),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: isEditable ? _pickImage : null,
                    child: _avatar(),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: nameController,
                    enabled: isEditable,
                    decoration: const InputDecoration(labelText: 'Organization Name'),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: categoryOptions.contains(selectedCategory)
                        ? selectedCategory
                        : categoryOptions.first,
                    items: categoryOptions
                        .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                        .toList(),
                    onChanged: isEditable
                        ? (value) {
                            if (value != null) setState(() => selectedCategory = value);
                          }
                        : null,
                    decoration: const InputDecoration(labelText: 'Category'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: descriptionController,
                    enabled: isEditable,
                    maxLines: 5,
                    decoration: const InputDecoration(labelText: 'Description'),
                  ),
                ],
              ),
            ),
    );
  }
}
