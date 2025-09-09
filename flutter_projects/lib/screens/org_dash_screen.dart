import 'package:flutter/material.dart';
import 'package:flutter_projects/screens/create_event_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/event_card.dart';

class Event {
  final String title;
  final String date;
  final String time;
  final String org;
  final String imageAsset;
  final double cardWidth;

  Event({
    required this.title,
    required this.date,
    required this.time,
    required this.org,
    required this.imageAsset,
    required this.cardWidth,
});
}

class OrgDashScreen extends StatefulWidget {
  const OrgDashScreen({super.key});

  @override
  State<OrgDashScreen> createState() => _OrgDashScreenState();
}

class _OrgDashScreenState extends State<OrgDashScreen> {
  List<Event> events = [];
  bool isLoading = true;
  String? orgName;


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
    loadOrgName(); });
    fetchEvents();
  }

  Future<void> loadOrgName() async {
    final prefs = await SharedPreferences.getInstance();
    final storedName = prefs.getString('orgName');
    setState(() {
      orgName = storedName ?? 'Organization';
    });
  }


  Future<void> fetchEvents() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      events = [
        Event(title: 'Hackathon', date: 'July 10', time: '10:00 AM', org: 'Tech Club', imageAsset: 'assets/images/secpic.jpg',cardWidth: 220,),
        Event(title: 'Food Drive', date: 'July 21', time: '3:00 PM',org: 'Tech Club', imageAsset: 'assets/images/secpic.jpeg',cardWidth: 220),
      ];
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Organization Dashboard'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               Text(
              'Welcome,${orgName ?? ''}',
              style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
            ),
           const SizedBox(height: 20,),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(context,MaterialPageRoute(
                    builder: (e) => CreateEventScreen(),
                  ),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('Create New Event'),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Upcoming Events',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 10),


            SizedBox(
              height: 270,
              child: events.isEmpty
                  ? const Center(child: Text('No events posted yet.'))
                  : ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: events.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final event = events[index];
                  return EventCard(
                    title: event.title,
                    date: event.date, time: event.time, org: event.org, imageAsset: event.imageAsset, cardWidth:event.cardWidth,
                  );
                },
              ),
            ),
          ],
      )),
    );
  }
}

