import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart'; // for mime types


class OrgProfileScreen extends StatefulWidget {
  const OrgProfileScreen({super.key});

  @override
  State<OrgProfileScreen> createState() => _OrgProfileScreenState();
}

class _OrgProfileScreenState extends State<OrgProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String selectedCategory = 'Technology';
  File? selectedImage;
  bool isLoading = true;
  bool isEditable = false;

  final List<String> categoryOptions = [
    'Technology',
    'Wellness',
    'Arts',
    'Community',
    'Education',
  ];

  final OutlineInputBorder inputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: Colors.grey),
  );

  @override
  void initState(){
    super.initState();
    loadOrgProfile();
  }

  Future<void> loadOrgProfile() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      nameController.text = 'Tech Club';
      descriptionController.text = 'We host events about coding, AI, and robotics.';
      selectedCategory = 'Technology';
      selectedImage = null; // or File from assets for demo
      isLoading = false;
    });
  }
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        selectedImage = File(picked.path);
      });
    }
  }

  void saveProfile() async {
    final url = Uri.parse('http://10.0.2.2:8000/api/org/profile/update/');
    final request = http.MultipartRequest('PUT',url);

    request.fields['name'] = nameController.text;
    request.fields['category'] = selectedCategory;
    request.fields['description'] = descriptionController.text;

    if (selectedImage != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'logo', // Django field name
          selectedImage!.path,
          contentType: MediaType('image', 'jpeg'), // or 'png' depending on input
        ),
      );
    }
    request.headers['Authorization'] = 'Bearer YOUR_ACCESS_TOKEN';

    // Send request
    final response = await request.send();

    if (response.statusCode == 200) {
      print('Profile updated successfully!');
    } else {
      print('Failed to update profile. Status: ${response.statusCode}');
    }
  }


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        actions: [
          TextButton(onPressed: () {
            setState(() {
              isEditable = !isEditable;
            });
          }, child: Text(
            isEditable ? 'Done' : 'Edit Profile',
            style: const TextStyle(color: Colors.black),
          ))
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: pickImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: selectedImage != null
                        ? FileImage(selectedImage!)
                          : const AssetImage('assets/images/secpic.jpeg')
                              as ImageProvider,
                      child: selectedImage ==  null
                          ? const Icon(Icons.camera_alt, size: 30, color: Colors.white,)
                          : null,

                    ),
                  ),
                  const SizedBox(height: 20,),

                  TextField(
                    controller: nameController,
                    enabled: isEditable,
                    style: TextStyle(
                      color: isEditable ? Colors.black : Colors.black,
                    ),
                    decoration:  InputDecoration(
                      labelText: 'Organization Name',
                      border: inputBorder,
                      enabledBorder: inputBorder,
                      focusedBorder: inputBorder,
                    ),
                  ),
                  const SizedBox(height: 16),

                  DropdownButtonFormField(
                    value: selectedCategory,
                      items: categoryOptions
                        .map((cat) => DropdownMenuItem<String>(
                          value: cat,
                          child: Text(cat),
                      ))
                      .toList(),
                      onChanged: isEditable
                          ? (String? value) {
                      if (value != null) {
                        setState(() {
                          selectedCategory = value;
                        });
                      }
                      }
                      : null,
                    decoration: InputDecoration(
                    labelText: 'Category',
                    border:inputBorder,
                      enabledBorder: inputBorder,
                      focusedBorder: inputBorder,
                      )
                  ),
                  const SizedBox(height: 16),

                  TextField(
                    controller: descriptionController,
                    enabled: isEditable,
                    maxLines: 5,
                    style: TextStyle(
                      color: isEditable ? Colors.black : Colors.black,
                    ),
                    decoration:InputDecoration(
                      labelText: 'Description',
                      border: inputBorder,
                      enabledBorder: inputBorder,
                      focusedBorder: inputBorder,
                    ),
                  ),
                  const SizedBox(height: 24),

                  if (isEditable)
                    ElevatedButton(
                      onPressed:()
                       {
                         saveProfile();
                            setState(() {
                              isEditable = false;
                            });
                          },
                      style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      child: const Text('Save Changes'),
                    ),
                ],
              ),
      ),
    );
  }
}
