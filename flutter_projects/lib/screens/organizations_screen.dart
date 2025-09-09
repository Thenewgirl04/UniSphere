import 'package:flutter/material.dart';
import 'package:flutter_projects/screens/orgdetails_screen.dart';
import 'package:flutter_projects/theme/theme.dart';

class OrganizationsScreen extends StatelessWidget {
  const OrganizationsScreen({super.key});


  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> orgs = [
      {
        'name': 'Tech Innovators',
        'bio': 'Pioneering the future',
        'logo': 'assets/image/logou.png',
        'description': 'A student-run club for tech lovers.',
        'category':'tech',
      },
      {
        'name': 'Tech Innovators',
        'bio': 'Pioneering the future',
        'logo': 'assets/image/logou.png',
        'category': 'tech',
        'description': 'A student-run club for tech lovers.',
      }

    ];
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Organizations',
        style: TextStyle(color: Colors.white)),
        backgroundColor: lightColorScheme.primary,
        actions: [
          IconButton(onPressed: (){}, icon: const Icon(Icons.search))
        ],
      ),
      body: ListView.builder(
        itemCount: orgs.length,
        itemBuilder: (content,index) {
          final org = orgs[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(org['logo']!),
              backgroundColor: Colors.grey.shade200,
            ),
            title: Text(
              org['name']!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
              subtitle: Text(org['bio']!),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
              builder: (context) => OrgdetailsScreen(name: org['name']!, logo: org['logo']!, description: org['description']!, category: org["category"]!,
              ),
              ),
              );
            },
          );
        },
      ),
    );
  }
}
