import 'package:flutter/material.dart';
import 'package:flutter_projects/core/api/auth_service.dart';
import 'package:flutter_projects/screens/org_login_screen.dart';
import 'package:flutter_projects/theme/theme.dart';

class OrgRegisterScreen extends StatefulWidget {
  const OrgRegisterScreen({super.key});

  @override
  State<OrgRegisterScreen> createState() => _OrgRegisterScreenState();
}

class _OrgRegisterScreenState extends State<OrgRegisterScreen> {
  final _authService = AuthService();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isLoading = false;
  String _errorText = '';

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    setState(() {
      _isLoading = true;
      _errorText = '';
    });

    try {
      await _authService.registerOrganization(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration successful. Please log in.')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OrgLoginScreen()),
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
      appBar: AppBar(title: const Text('Organization Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Organization Name'),
            ),
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
                : ElevatedButton(onPressed: _register, child: const Text('Register')),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const OrgLoginScreen()),
                );
              },
              child: Text(
                'Already have an account? Sign in',
                style: TextStyle(color: lightColorScheme.primary, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
