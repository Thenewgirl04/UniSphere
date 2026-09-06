import 'package:flutter/material.dart';
import 'package:flutter_projects/screens/welcome_screen.dart';
import 'package:flutter_projects/theme/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const UniSphereApp());
}

class UniSphereApp extends StatelessWidget {
  const UniSphereApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UniSphere',
      theme: lightMode,
      home: const WelcomeScreen(),
    );
  }
}
