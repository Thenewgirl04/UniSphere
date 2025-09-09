import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../theme/theme.dart';
import 'org_login_screen.dart';

class OrgRegisterScreen extends StatefulWidget {
  const OrgRegisterScreen({super.key});

  @override
  State<OrgRegisterScreen> createState() => _OrgRegisterScreenState();
}

class _OrgRegisterScreenState extends State<OrgRegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String errorText = '';
  bool isLoading = false;

  Future<void> registerOrg() async{
    final url = Uri.parse('http://10.0.2.2:8000/api/org/register/');
    setState(() => isLoading = true);

    final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
        "name": nameController.text.trim(),
        "email": emailController.text.trim(),
        "password": passwordController.text.trim(),
        }),
    );

    setState(() => isLoading = false);

    if (response.statusCode == 201) {
      final responseBody = jsonDecode(response.body);
      print('Org name from backend: ${responseBody['org']}');
      final orgName = responseBody['org'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('orgName', orgName);


      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration successful. Please log in.')),
      );

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OrgLoginScreen()),
      );
    } else {
      print('Registration error response: ${response.body}');
      final data = jsonDecode(response.body);
      setState(() {
        errorText =  data['email']?.join(', ') ??
            data['password']?.join(', ') ??
            data['name']?.join(', ') ??
            data['non_field_errors']?.join(', ') ??
            'Registration failed';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Organization Register")),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Organization Name"),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: "Email"),
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              if (errorText.isNotEmpty)
                Text(errorText, style: TextStyle(color: Colors.red)),
              SizedBox(height: 20,),
              isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                  onPressed: (){
                    if (!isLoading) {
                              registerOrg();
                          }},
                    child: Text('Register'),
                    ),
                    Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    const Text(
                    'Already have an account? ',
                    style: TextStyle(
                    color: Colors.black45,
                    ),
                    ),
                    GestureDetector(
                    onTap: () {
                    Navigator.push(
                    context,
                    MaterialPageRoute(
                    builder: (e) => OrgLoginScreen(),
                    ),
                    );
                    },
                    child: Text(
                    'Sign in',
                    style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: lightColorScheme.primary,
                    ),
                    ),
                    )
                ],
              ),
              ],
          ),
      ),
    );
  }
}
