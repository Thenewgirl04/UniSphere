import 'package:flutter/material.dart';
import 'package:flutter_projects/core/config/env.dart';
import 'package:flutter_projects/screens/signin_screen.dart';
import 'package:flutter_projects/theme/theme.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/custom_scaffold.dart';
import 'org_login_screen.dart';

class EntryScreen extends StatelessWidget {
  const EntryScreen({super.key});

  Future<void> _openAdminDashboard() async {
    final url = Uri.parse('${Env.apiBaseUrl}/admin/');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Continue as...',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                backgroundColor: lightColorScheme.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.school),
              label: const Text('Student'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SignInScreen()),
                );
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                backgroundColor: lightColorScheme.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.business),
              label: const Text('Organization'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const OrgLoginScreen()),
                );
              },
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: _openAdminDashboard,
              child: const Text(
                'Open Django Admin',
                style: TextStyle(
                  color: Colors.white,
                  decoration: TextDecoration.underline,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
