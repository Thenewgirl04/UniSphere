import 'package:flutter/material.dart';
import '../theme/theme.dart';
import '../widgets/category_tile.dart';
import '../widgets/event_card.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Explore by Category', style: TextStyle(fontSize: 20),),
        backgroundColor: lightColorScheme.primary,
      ),
      body: SingleChildScrollView(
    child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Categories", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    CategoryTile(label: "Arts", icon: Icons.brush, onTap: () {}, backgroundColor: Colors.pink.shade100,),
                    CategoryTile(label: "Tech", icon: Icons.memory, onTap: () {}, backgroundColor: Colors.blue.shade100 ,),
                    CategoryTile(label: "Sports", icon: Icons.sports_soccer, onTap: () {}, backgroundColor: Colors.green.shade100 ,),
                    CategoryTile(label: "Wellness", icon: Icons.self_improvement, onTap: () {}, backgroundColor: Colors.purple.shade100),
                  ],
                ),
            ),

            const SizedBox(height: 20),
            Divider(thickness: 1.0, color: Colors.grey, endIndent: 10,),
            const SizedBox(height: 20),

            const Text(
              "Trending Events",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12,),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  EventCard(
                    title: "Dancing in the Rain",
                    date: "13th June, 2025",
                    time: "7:30 PM",
                    org: "SGA",
                    imageAsset: "assets/images/firstpic.jpeg",
                    cardWidth: 260,
                  ),

                  EventCard(
                    title: "Ballerina Show",
                    date: "25th June, 2025",
                    time: "10:00 AM",
                    org: "ASA",
                    imageAsset: "assets/images/secpic.jpeg",
                    cardWidth: 260,
                  ),
               ],
              ),
            ),
              const SizedBox(height: 24),

            Center(child:
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(12)
                ),
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                  const Text(
                  "Don’t miss out!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                  "Turn on notifications to stay updated with the latest campus events.",
                    textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  Center( child:
                  ElevatedButton.icon(
                  onPressed: () {
                  // TODO: Add logic to request notification permissions
                  },
                  icon: const Icon(Icons.notifications_active),
                  label: const Text("Enable Notifications"),
                  style: ElevatedButton.styleFrom(
                  backgroundColor: lightColorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  ),
                ],
              ),
             ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}
