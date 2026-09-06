import 'package:flutter/material.dart';
import 'package:flutter_projects/core/api/event_service.dart';
import 'package:flutter_projects/core/config/env.dart';
import 'package:flutter_projects/core/storage/token_storage.dart';
import 'package:flutter_projects/screens/create_event_screen.dart';
import 'package:flutter_projects/widgets/event_card.dart';

class OrgDashScreen extends StatefulWidget {
  const OrgDashScreen({super.key});

  @override
  State<OrgDashScreen> createState() => _OrgDashScreenState();
}

class _OrgDashScreenState extends State<OrgDashScreen> {
  final _eventService = EventService();
  List<dynamic> upcomingEvents = [];
  bool isLoading = true;
  String? orgName;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    orgName = await TokenStorage.getUserName();
    try {
      final data = await _eventService.fetchMyEvents();
      final approved = List<dynamic>.from(data['approved'] as List? ?? []);
      final posted = List<dynamic>.from(data['posted'] as List? ?? []);
      if (!mounted) return;
      setState(() {
        upcomingEvents = [...approved, ...posted];
        isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Organization Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome, ${orgName ?? 'Organization'}',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const CreateEventScreen()),
                        );
                        _loadData();
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Create New Event'),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Approved & Posted Events',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: upcomingEvents.isEmpty
                        ? const Center(child: Text('No approved events yet.'))
                        : ListView.separated(
                            itemCount: upcomingEvents.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final event = upcomingEvents[index];
                              final flyer = event['flyer'] as String?;
                              return EventCard(
                                title: event['name'] ?? 'Untitled',
                                date: event['date'] ?? '',
                                time: event['time'] ?? '',
                                org: event['org_name'] ?? orgName ?? '',
                                imageAsset: flyer != null && flyer.isNotEmpty
                                    ? Env.mediaUrl(flyer)
                                    : 'https://via.placeholder.com/300x200?text=No+Flyer',
                                cardWidth: double.infinity,
                              );
                            },
                          ),
                  ),
                ],
              ),
      ),
    );
  }
}
