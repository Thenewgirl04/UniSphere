import 'package:flutter/material.dart';
import 'package:flutter_projects/core/api/auth_service.dart';
import 'package:flutter_projects/screens/signin_screen.dart';
import 'package:flutter_projects/widgets/custom_scaffold.dart';

import '../theme/theme.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      await _authService.registerStudent(
        fullName: fullNameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account created. Please sign in.')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SignInScreen()),
      );
    } on AuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not reach server. Is the backend running?\n$e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
          const Expanded(flex: 1, child: SizedBox(height: 10)),
          Expanded(
            flex: 7,
            child: Container(
              padding: const EdgeInsets.fromLTRB(25.0, 50.0, 25.0, 20.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Text(
                        'Get Started',
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.w900,
                          color: lightColorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 40),
                      TextFormField(
                        controller: fullNameController,
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Enter your full name' : null,
                        decoration: InputDecoration(
                          labelText: 'Full Name',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      const SizedBox(height: 25),
                      TextFormField(
                        controller: emailController,
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Enter your email' : null,
                        decoration: InputDecoration(
                          labelText: 'School Email',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      const SizedBox(height: 25),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        validator: (value) =>
                            value == null || value.length < 6 ? 'Password must be at least 6 characters' : null,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      const SizedBox(height: 25),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _register,
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Text('Sign up'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
