import 'package:flutter/material.dart';
import 'package:flutter_projects/core/api/auth_service.dart';
import 'package:flutter_projects/screens/org_main_page.dart';
import 'package:flutter_projects/screens/org_register_screen.dart';
import 'package:flutter_projects/theme/theme.dart';

class OrgLoginScreen extends StatefulWidget {
  const OrgLoginScreen({super.key});

  @override
  State<OrgLoginScreen> createState() => _OrgLoginScreenState();
}

class _OrgLoginScreenState extends State<OrgLoginScreen> {
  final _authService = AuthService();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isLoading = false;
  String _errorText = '';

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _errorText = '';
    });

    try {
      final data = await _authService.login(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (!mounted) return;

      if (data['user_type'] != 'organization') {
        setState(() => _errorText = 'This account is not an organization.');
        await _authService.logout();
        return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OrgMainPage()),
      );
    } on AuthException catch (e) {
      setState(() => _errorText = e.message);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Organization Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            if (_errorText.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(_errorText, style: const TextStyle(color: Colors.red)),
              ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(onPressed: _login, child: const Text('Login')),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const OrgRegisterScreen()),
                );
              },
              child: Text(
                'Need an account? Register',
                style: TextStyle(color: lightColorScheme.primary, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
