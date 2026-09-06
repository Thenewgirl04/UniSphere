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
  final _formKey = GlobalKey<FormState>();
  final _eventService = EventService();
  final _authService = AuthService();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  String selectedCategory = 'Technology';
  Uint8List? _previewBytes;
  UploadedFile? _selectedLogo;
  String? existingLogoUrl;
  String email = '';
  String? loadError;
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
        email = profile['email'] as String? ?? '';
        loadError = null;
        isLoading = false;
      });
    } on EventException catch (error) {
      if (!mounted) return;
      setState(() {
        loadError = error.message;
        isLoading = false;
      });
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
      return CircleAvatar(
        radius: 50,
        backgroundImage: MemoryImage(_previewBytes!),
      );
    }
    if (existingLogoUrl != null && existingLogoUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: 50,
        backgroundImage: NetworkImage(Env.mediaUrl(existingLogoUrl)),
      );
    }
    return const CircleAvatar(
      radius: 50,
      child: Icon(Icons.business, size: 40),
    );
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
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
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Profile updated')));
    } on EventException catch (e) {
      if (!mounted) return;
      setState(() => isSaving = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  Future<void> _cancelEditing() async {
    setState(() {
      isEditable = false;
      _selectedLogo = null;
      _previewBytes = null;
    });
    await _loadProfile();
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
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
            tooltip: 'Log out',
          ),
        ],
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : loadError != null
              ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Colors.redAccent,
                      ),
                      const SizedBox(height: 12),
                      Text(loadError!, textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      FilledButton.icon(
                        onPressed: () {
                          setState(() => isLoading = true);
                          _loadProfile();
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Try again'),
                      ),
                    ],
                  ),
                ),
              )
              : SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 680),
                    child: Card(
                      elevation: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(28),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Center(
                                child: GestureDetector(
                                  onTap: isEditable ? _pickImage : null,
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      _avatar(),
                                      if (isEditable)
                                        const Positioned(
                                          right: -4,
                                          bottom: -4,
                                          child: CircleAvatar(
                                            radius: 18,
                                            child: Icon(
                                              Icons.camera_alt,
                                              size: 18,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 28),
                              TextFormField(
                                controller: nameController,
                                readOnly: !isEditable,
                                validator:
                                    (value) =>
                                        value == null || value.trim().isEmpty
                                            ? 'Enter an organization name'
                                            : null,
                                decoration: const InputDecoration(
                                  labelText: 'Organization name',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.business_outlined),
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                initialValue: email,
                                readOnly: true,
                                decoration: const InputDecoration(
                                  labelText: 'Email',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.email_outlined),
                                ),
                              ),
                              const SizedBox(height: 16),
                              DropdownButtonFormField<String>(
                                key: ValueKey(selectedCategory),
                                initialValue:
                                    categoryOptions.contains(selectedCategory)
                                        ? selectedCategory
                                        : categoryOptions.first,
                                items:
                                    categoryOptions
                                        .map(
                                          (cat) => DropdownMenuItem(
                                            value: cat,
                                            child: Text(cat),
                                          ),
                                        )
                                        .toList(),
                                onChanged:
                                    isEditable
                                        ? (value) {
                                          if (value != null) {
                                            setState(
                                              () => selectedCategory = value,
                                            );
                                          }
                                        }
                                        : null,
                                decoration: const InputDecoration(
                                  labelText: 'Category',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.category_outlined),
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: descriptionController,
                                readOnly: !isEditable,
                                minLines: 3,
                                maxLines: 5,
                                decoration: const InputDecoration(
                                  labelText: 'Description',
                                  alignLabelWithHint: true,
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.description_outlined),
                                ),
                              ),
                              const SizedBox(height: 24),
                              if (isEditable)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      onPressed:
                                          isSaving ? null : _cancelEditing,
                                      child: const Text('Cancel'),
                                    ),
                                    const SizedBox(width: 12),
                                    FilledButton.icon(
                                      onPressed: isSaving ? null : _saveProfile,
                                      icon:
                                          isSaving
                                              ? const SizedBox(
                                                width: 16,
                                                height: 16,
                                                child:
                                                    CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                    ),
                                              )
                                              : const Icon(Icons.save_outlined),
                                      label: Text(
                                        isSaving ? 'Saving...' : 'Save changes',
                                      ),
                                    ),
                                  ],
                                )
                              else
                                FilledButton.icon(
                                  onPressed:
                                      () => setState(() => isEditable = true),
                                  icon: const Icon(Icons.edit_outlined),
                                  label: const Text('Edit profile'),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
    );
  }
}
