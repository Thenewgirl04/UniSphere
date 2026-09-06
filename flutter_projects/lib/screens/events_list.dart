import 'package:flutter/material.dart';
import 'package:flutter_projects/core/api/event_service.dart';
import 'package:flutter_projects/core/models/uploaded_file.dart';
import 'package:flutter_projects/widgets/org_eve_card.dart';

class OrgEventsScreen extends StatefulWidget {
  const OrgEventsScreen({super.key});

  @override
  State<OrgEventsScreen> createState() => _OrgEventsScreenState();
}

class _OrgEventsScreenState extends State<OrgEventsScreen>
    with SingleTickerProviderStateMixin {
  final _eventService = EventService();
  late TabController _tabController;

  List<dynamic> pendingEvents = [];
  List<dynamic> approvedEvents = [];
  List<dynamic> rejectedEvents = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    setState(() => isLoading = true);
    try {
      final data = await _eventService.fetchMyEvents();
      if (!mounted) return;
      setState(() {
        pendingEvents = List<dynamic>.from(data['pending'] as List? ?? []);
        approvedEvents = List<dynamic>.from(data['approved'] as List? ?? []);
        rejectedEvents = List<dynamic>.from(data['rejected'] as List? ?? []);
        isLoading = false;
      });
    } on EventException {
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  Future<void> _postEvent(int eventId, UploadedFile flyer) async {
    try {
      await _eventService.postApprovedEvent(eventId: eventId, flyer: flyer);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event published successfully')),
      );
      await _loadEvents();
    } on EventException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    }
  }

  Widget _buildEventList(List<dynamic> events) {
    if (events.isEmpty) {
      return const Center(child: Text('No events found'));
    }

    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return OrgEveCard(
          event: Map<String, dynamic>.from(event as Map),
          onPost: _postEvent,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Events'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Pending'),
            Tab(text: 'Approved'),
            Tab(text: 'Rejected'),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildEventList(pendingEvents),
                _buildEventList(approvedEvents),
                _buildEventList(rejectedEvents),
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
