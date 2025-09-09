import 'package:flutter/material.dart';

class OrgCard extends StatelessWidget {
  final String title;
  final String imagePath;

  const OrgCard({super.key,
  required this.title,
  required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(imagePath, height: 80, width: 150, fit:BoxFit.cover),
          ),
          const SizedBox(height: 8,),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
