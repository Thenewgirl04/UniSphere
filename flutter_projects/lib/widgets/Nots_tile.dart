import 'package:flutter/material.dart';
import 'package:flutter_projects/theme/theme.dart';

class NotsTile extends StatelessWidget {
  final IconData icon;
  final String message;

  const NotsTile({super.key,
  required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      leading: Icon(icon, color: lightColorScheme.primary),
      title: Text(message),
    );
  }
}
