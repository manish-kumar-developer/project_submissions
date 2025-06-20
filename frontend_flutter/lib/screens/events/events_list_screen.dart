import 'package:flutter/material.dart';
import 'package:frontend_flutter/models/event.dart';
import 'package:frontend_flutter/providers/event_provider.dart';
import 'package:frontend_flutter/screens/events/event_create_screen.dart';
import 'package:frontend_flutter/screens/events/event_detail_screen.dart';
import 'package:frontend_flutter/widgets/event_card.dart';
import 'package:provider/provider.dart';

class EventsListScreen extends StatefulWidget {
  const EventsListScreen({super.key});

  @override
  State<EventsListScreen> createState() => _EventsListScreenState();
}

class _EventsListScreenState extends State<EventsListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<EventProvider>();
      if (provider.events.isEmpty) {
        provider.loadInitialEvents();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final eventProvider = context.watch<EventProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Upcoming Events'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: eventProvider.refreshEvents,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildEventList(eventProvider),
          ),
          _buildPaginationControls(eventProvider),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToCreateEvent(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEventList(EventProvider eventProvider) {
    if (eventProvider.isLoading && eventProvider.events.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (eventProvider.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: ${eventProvider.error}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: eventProvider.refreshEvents,
              child: const Text('Retry'),
            )
          ],
        ),
      );
    }

    if (eventProvider.events.isEmpty) {
      return const Center(
        child: Text('No events found', style: TextStyle(fontSize: 18)),
      );
    }

    return RefreshIndicator(
      onRefresh: () => eventProvider.refreshEvents(),
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: eventProvider.events.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final event = eventProvider.events[index];
          return EventCard(
            event: event,
            onTap: () => _navigateToEventDetail(context, event),
          );
        },
      ),
    );
  }

  Widget _buildPaginationControls(EventProvider eventProvider) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      color: Colors.grey[100],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (eventProvider.currentPage > 1)
            OutlinedButton(
              onPressed: eventProvider.isLoading
                  ? null
                  : () => _loadPreviousPage(eventProvider),
              child: const Text('Previous'),
            ),
          const SizedBox(width: 20),
          Text(
            'Page ${eventProvider.currentPage} of ${eventProvider.lastPage ?? '?'}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 20),
          if (eventProvider.canLoadMore)
            ElevatedButton(
              onPressed: eventProvider.isLoading
                  ? null
                  : () => eventProvider.loadNextPage(),
              child: const Text('Next Page'),
            ),
          if (eventProvider.isLoading)
            const Padding(
              padding: EdgeInsets.only(left: 16),
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
        ],
      ),
    );
  }

  void _loadPreviousPage(EventProvider eventProvider) {
    if (eventProvider.currentPage > 1) {
      eventProvider.currentPage = eventProvider.currentPage - 1;
      eventProvider.refreshEvents();
    }
  }

  void _navigateToEventDetail(BuildContext context, Event event) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventDetailScreen(event: event),
      ),
    );
  }

  void _navigateToCreateEvent(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EventCreateScreen(),
      ),
    );
  }
}