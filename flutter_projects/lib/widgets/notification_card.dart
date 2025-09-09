import 'package:flutter/material.dart';

class NotificationCard extends StatelessWidget {
  final String title;
  final String org;
  final String time;
  final bool unread;

  const NotificationCard({
    super.key,
  required this.title,
  required this.org,
  required this.time,
  this.unread = false
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          if (unread)
            const Padding(
              padding: EdgeInsets.only(right: 8),
              child: Icon(Icons.circle, size: 8, color: Colors.green),
            ),
          const Icon(Icons.notifications_none, color: Colors.orange),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14)),
                const SizedBox(height: 4),
                Text(
                  "$org • $time",
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        ]
      ),

    );
  }
}
