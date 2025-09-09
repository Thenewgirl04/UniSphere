import 'package:flutter/material.dart';
import 'package:flutter_projects/widgets/dashboard_scaffold.dart';
import 'package:flutter_projects/widgets/event_card.dart';
import 'package:flutter_projects/widgets/notification_card.dart';
import '../theme/theme.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DashboardScreen extends StatefulWidget {
  final String firstName;
  final String lastName;

  const DashboardScreen({
    super.key,
    this.firstName = '',
    this.lastName = '',
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();

}

class _DashboardScreenState extends State<DashboardScreen> {
  List<dynamic> postedEvents = [];
  bool isLoading = true;

  Future<void> fetchPostedEvents() async {
    final url = Uri.parse('http://10.0.2.2:8000/api/events/posted/');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        postedEvents = data;
        isLoading = false;
      });
    } else {
      print("Error fetching events: ${response.statusCode}");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchPostedEvents();
  }

  @override
  Widget build(BuildContext context) {
    return DashboardScaffold(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // 🔶 Orange Header
          Container(
            decoration: BoxDecoration(
              color: lightColorScheme.primary,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            padding: const EdgeInsets.all(20.0),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.menu, size: 28),
                      ),
                      const Text(
                        "UniSphere",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.account_circle,
                                size: 28, color: Colors.white),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.message_outlined,
                                size: 28, color: Colors.white),
                          ),
                        ],
                      )
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Welcome Text
                  Text(
                    "Welcome, ${widget.firstName}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Search Bar
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "search events, organizations...",
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),
                ],
              ),
            ),
          ),

          // ⬜️ White Body Section
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Today’s Events",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                isLoading
                  ? const Center(child: CircularProgressIndicator())
                    : postedEvents.isEmpty
                        ? const Text("No events posted yet")
                        : SizedBox(
                  height: 320, // Make sure to give it a fixed height
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: postedEvents.length,
                    itemBuilder: (context, index) {
                      final event = postedEvents[index];
                      return EventCard(
                        title: event['name'] ?? "Untitled",
                        date: event['date'] ?? "",
                        time: event["time"] ?? "",
                        org: event['org_name'] ?? "Unknown Org",
                        imageAsset: event['flyer'] != null
                            ? 'http://10.0.2.2:8000${event['flyer']}'
                            : 'https://via.placeholder.com/300x200?text=No+Flyer',
                        cardWidth: 220,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 28),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Notifications",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          DropdownButton(
            value: "Today",
            items: ["Today", "This Week", "All"].map((filter) {
              return DropdownMenuItem(
                  value: filter, child: Text(filter));
            }).toList(),
            onChanged: (value) {},
          ),
        ],
      ),
      const SizedBox(height: 12),
      NotificationCard(
        title: "SGA just posted a new event",
        org: "Student Government",
        time: "2 mins ago",
        unread: true,
      ),
      NotificationCard(
        title: "SGA just posted a new event",
        org: "Student Government",
        time: "15 mins ago",
        unread: false,
      ),
      NotificationCard(
        title: "Traditional week posted",
        org: "African Student Association",
        time: "1 hr ago",
        unread: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
