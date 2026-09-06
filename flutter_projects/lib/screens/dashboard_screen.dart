import 'package:flutter/material.dart';
import 'package:flutter_projects/core/api/event_service.dart';
import 'package:flutter_projects/core/config/env.dart';
import 'package:flutter_projects/widgets/dashboard_scaffold.dart';
import 'package:flutter_projects/widgets/event_card.dart';

import '../theme/theme.dart';

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
  final _eventService = EventService();
  List<dynamic> postedEvents = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final events = await _eventService.fetchPostedEvents();
      if (!mounted) return;
      setState(() {
        postedEvents = events;
        isLoading = false;
      });
    } on EventException catch (e) {
      if (!mounted) return;
      setState(() {
        errorMessage = e.message;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DashboardScaffold(
      child: RefreshIndicator(
        onRefresh: _loadEvents,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
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
                    const Text(
                      'UniSphere',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.firstName.isEmpty
                          ? 'Discover campus events'
                          : 'Welcome, ${widget.firstName}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 25),
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Posted Events',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  if (isLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (errorMessage != null)
                    Text(errorMessage!, style: const TextStyle(color: Colors.red))
                  else if (postedEvents.isEmpty)
                    const Text('No events posted yet.')
                  else
                    SizedBox(
                      height: 320,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: postedEvents.length,
                        itemBuilder: (context, index) {
                          final event = postedEvents[index];
                          final flyer = event['flyer'] as String?;
                          return EventCard(
                            title: event['name'] ?? 'Untitled',
                            date: event['date'] ?? '',
                            time: event['time'] ?? '',
                            org: event['org_name'] ?? 'Unknown Org',
                            imageAsset: flyer != null && flyer.isNotEmpty
                                ? Env.mediaUrl(flyer)
                                : 'https://via.placeholder.com/300x200?text=No+Flyer',
                            cardWidth: 220,
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
