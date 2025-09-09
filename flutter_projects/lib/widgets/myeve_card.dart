import 'package:flutter/material.dart';

class MyeveCard extends StatelessWidget {
  final String title;
  final String date;

  const MyeveCard({super.key,
  required this.title,
  required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(date, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
      ),
    );
  }
}
