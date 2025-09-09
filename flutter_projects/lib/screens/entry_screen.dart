import "package:flutter/material.dart";
import "package:flutter_projects/screens/signin_screen.dart";
import "package:flutter_projects/theme/theme.dart";
import "package:url_launcher/url_launcher.dart";
import "../widgets/custom_scaffold.dart";
import "org_login_screen.dart";

class EntryScreen extends StatelessWidget {
  const EntryScreen({super.key});

  void _openAdminDashboard() async {
    const url = 'http://10.0.2.2:8000/api/event-requests/'; // Change this if you're on real device
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Continue as...',
            style: TextStyle(
          height: 3.0,
          fontSize: 20.0,
              color: Colors.white
        ),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 30),
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
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 30),
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
            const SizedBox(height: 8,),
            Text(
              "or",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8,),
    GestureDetector(
    onTap: _openAdminDashboard,
    child: Text(
    'Go to Admin Dashboard',
    style: TextStyle(
    color: Colors.white,
    decoration: TextDecoration.underline,
    fontSize: 16,
    ),
    ),
    ),
          ],
        ),
      );
  }
}
