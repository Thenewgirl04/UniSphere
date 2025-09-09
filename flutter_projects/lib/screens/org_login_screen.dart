import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../theme/theme.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'org_dash_screen.dart';
import 'org_main_page.dart';
import 'org_register_screen.dart';


class OrgLoginScreen extends StatefulWidget {
  const OrgLoginScreen({super.key});

  @override
  State<OrgLoginScreen> createState() => _OrgLoginScreenState();
}

class _OrgLoginScreenState extends State<OrgLoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final storage = FlutterSecureStorage();
  String errorText = '';
  
  Future<void> loginOrganization() async {
    final url = Uri.parse('http://10.0.2.2:8000/api/org/login/');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": emailController.text,
        "password": passwordController.text,
      })
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final orgName = data['name'];


      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('orgName', orgName);
      final token = data['access'];

      await storage.write(key: 'org_token', value: token);

      setState(() {
        errorText = '';
      });

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => OrgMainPage(),)
      );
    } else {
      print('Login failed: ${response.body}');
      final data = jsonDecode(response.body);
      setState(() {
        errorText = data['error'] ?? 'Login failed';
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Organization Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            if (errorText.isNotEmpty)
              Text(errorText, style: TextStyle(color: Colors.red)),
            SizedBox(height: 20,),
            ElevatedButton(onPressed: loginOrganization, child: Text('Login'),
            ),
    const SizedBox(height: 40,),
    Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    const Text(
    'Don\'t have an account? ',
    style: TextStyle(
    color: Colors.black45,
    ),
    ),
    GestureDetector(
    onTap: () {
    Navigator.push(
    context,
    MaterialPageRoute(
    builder: (e) => const OrgRegisterScreen(),
    ),
    );
    },
    child: Text(
    'Sign up',
    style: TextStyle(
    fontWeight: FontWeight.bold,
    color: lightColorScheme.primary,
    ),
    ),
    ),
    ],
    ),
          ],
        )
      ),
    );
  }
}
