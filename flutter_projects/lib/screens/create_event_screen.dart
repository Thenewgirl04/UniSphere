import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final contactController = TextEditingController();


  String? selectedCategory;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String? orgName;

  List<String> categoryOptions = ['Technology', 'Arts', 'Health', 'Sports'];

  @override
  void initState() {
    super.initState();
    loadOrgName(); // ✅ load SharedPreferences value here
  }

  Future<void> loadOrgName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      orgName = prefs.getString('orgName');
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Request Event Approval')),
        body: Padding(
        padding: const EdgeInsets.all(16.0),
    child: Form(
    key: _formKey,
    child: ListView(
    children: [
    TextFormField(
    controller: nameController,
    decoration: const InputDecoration(labelText: 'Event Name'),
    validator: (value) => value!.isEmpty ? 'Required' : null,
    ),
    const SizedBox(height: 16),
    DropdownButtonFormField<String>(
    value: selectedCategory,
    decoration: const InputDecoration(labelText: 'Category'),
    items: categoryOptions.map((cat) => DropdownMenuItem(
    value: cat,
    child: Text(cat),
    )).toList(),
    onChanged: (value) {
    setState(() => selectedCategory = value);
    },
    validator: (value) => value == null ? 'Please select a category' : null,
    ),
    const SizedBox(height: 16),
    TextFormField(
    readOnly: true,
    decoration: InputDecoration(
    labelText: selectedDate == null ? 'Event Date' : selectedDate.toString().split(' ')[0],
    suffixIcon: const Icon(Icons.calendar_today),
    ),
    onTap: () async {
    final date = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime.now(),
    lastDate: DateTime(2100),
    );
    if (date != null) {
    setState(() => selectedDate = date);
    }
    },
    ),
    const SizedBox(height: 16),
    const SizedBox(height: 16),

    TextFormField(
    readOnly: true,
    decoration: InputDecoration(
    labelText: selectedTime == null ? 'Event Time' : selectedTime!.format(context),
    suffixIcon: const Icon(Icons.access_time),
    ),
    onTap: () async {
    final time = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
    );
    if (time != null) {
    setState(() => selectedTime = time);
    }
    },
    ),
    const SizedBox(height: 16),
    TextFormField(
    controller: descriptionController,
    maxLines: 4,
    decoration: const InputDecoration(labelText: 'Description'),
    validator: (value) => value!.isEmpty ? 'Required' : null,
    ),
    const SizedBox(height: 16),

    TextFormField(
    controller: contactController,
    decoration: const InputDecoration(labelText: 'Organizer Contact Info (optional)'),
    ),
    const SizedBox(height: 24),

    ElevatedButton(
    onPressed: () async {
    if (_formKey.currentState!.validate()) {
      if (selectedDate == null || selectedTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please pick both date and time.')),
        );
        return;
      }
      final formattedDate = "${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}";
      final formattedTime = "${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}:00";
    // Submit request to backend'
      final storage = FlutterSecureStorage();
      final token = await storage.read(key: 'org_token') ?? '';
      print("🔐 Sending token: $token");

      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/api/org/events/create/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',  // ✅ Add token here
        },
        body: jsonEncode({
          "name": nameController.text.trim(),
          "category": selectedCategory,
          "description": descriptionController.text.trim(),
          "date": formattedDate,
          "time": formattedTime,
          "contact": contactController.text,
        }),
      );

      if (response.statusCode == 201) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Event submitted for approval')),
    );

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!context.mounted) return;
      Navigator.pop(context);
    });
    }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Submission failed. Try again.')),
      );
    }
    },
    child: const Text('Submit for Approval'),
    )
    ],
    ),
    ),
        ),
    );
  }
}
