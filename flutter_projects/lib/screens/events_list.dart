import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../widgets/org_eve_card.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class OrgEventsScreen extends StatefulWidget {
  const OrgEventsScreen({super.key});

  @override
  State<OrgEventsScreen> createState() => _OrgEventsScreenState();
}

class _OrgEventsScreenState extends State<OrgEventsScreen> with SingleTickerProviderStateMixin  {
  late TabController _tabController;

  List pendingEvents = [];
  List approvedEvents = [];
  List rejectedEvents = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController  = TabController(length: 3, vsync: this);
    loadEvents();
  }

  Future<void> loadEvents() async {
    setState(() =>
      isLoading = true);

    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'org_token') ?? '';
    print("🛡️ Sending token: $token");

    final url = Uri.parse('http://10.0.2.2:8000/api/org/events/grouped/');


    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          // no Authorization header since you're not using tokens
        },
      );

      if (response.statusCode == 200) {
        print('📦 Raw response: ${response.body}');
        final Map<String, dynamic> data = jsonDecode(response.body);

        setState(() {
          isLoading = false;
          pendingEvents = data['pending'];
          approvedEvents = data['approved'];
          rejectedEvents = data["rejected"];
          print('📂 Pending: ${data['pending']}');
          print('📂 Approved: ${data['approved']}');
          print('📂 Rejected: ${data['rejected']}');

        });
      } else {
        print('Failed to load events: ${response.body}');
        setState(() => isLoading = false);
      }
    } catch (e) {
      print('Error fetching events: $e');
      setState(() => isLoading = false);
    }
  }

  Future<void> postEvent(int eventId, File imageFile) async {
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'org_token') ?? '';
    final url = Uri.parse('http://10.0.2.2:8000/api/org/events/post/$eventId/');

    final request = http.MultipartRequest('POST', url)
    ..headers['Authorization'] = 'Bearer $token'
    ..files.add(
      await http.MultipartFile.fromPath(
        'image',
        imageFile.path,
        filename: basename(imageFile.path),
      ),
    );

    try {
      final response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Event posted successfully');
        await loadEvents();
      } else {
        print('❌ Failed with code: ${response.statusCode}');
      }
    } catch (e) {
      print('❗ Error posting event: $e');
    }
  }


  Widget buildEventList(List events) {
    if (events.isEmpty) {
      return Center(child: Text('No events found'));
    }
    return ListView.builder(itemCount:events.length,
        itemBuilder: (context,index) {
      final event = events[index];
      return OrgEveCard(
        event: event,
          onPost: (eventId, imageFile) async {
        await postEvent(eventId, imageFile);
        // Then setState to refresh the list
      },);
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Events'),
          bottom: TabBar(
              controller: _tabController,
              tabs: [
                Tab(text: 'Pending'),
                Tab(text: 'Approved'),
                Tab(text: 'Rejected')
              ],
          ),
      ),
      body: isLoading
        ? Center(child: CircularProgressIndicator())
        : TabBarView(
        controller: _tabController,
        children: [
          buildEventList(pendingEvents),
          buildEventList(approvedEvents),
          buildEventList(rejectedEvents),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
