import 'package:flutter/material.dart';
import 'package:frontend_flutter/providers/event_provider.dart';
import 'package:frontend_flutter/screens/events/event_create_screen.dart';
import 'package:frontend_flutter/widgets/event_card.dart';
import 'package:frontend_flutter/widgets/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';


class EventsListScreen extends StatefulWidget {
  const EventsListScreen({super.key});

  @override
  State<EventsListScreen> createState() => _EventsListScreenState();
}

class _EventsListScreenState extends State<EventsListScreen> {
  final RefreshController _refreshController = RefreshController();
  late EventProvider _eventProvider;

  @override
  void initState() {
    super.initState();
    _eventProvider = Provider.of<EventProvider>(context, listen: false);
    _loadInitialEvents();
  }

  Future<void> _loadInitialEvents() async {
    await _eventProvider.loadEvents();
  }

  Future<void> _onRefresh() async {
    await _eventProvider.refreshEvents();
    _refreshController.refreshCompleted();
  }

  Future<void> _onLoading() async {
    await _eventProvider.loadEvents();
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EventCreateScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<EventProvider>(
        builder: (context, provider, child) {
          if (provider.error != null) {
            return Center(child: Text(provider.error!));
          }

          if (provider.events.isEmpty && provider.isLoading) {
            return const Center(child: LoadingIndicator());
          }

          return SmartRefresher(
            controller: _refreshController,
            enablePullDown: true,
            enablePullUp: provider.hasMore,
            onRefresh: _onRefresh,
            onLoading: _onLoading,
            child: ListView.builder(
              itemCount: provider.events.length,
              itemBuilder: (context, index) {
                final event = provider.events[index];
                return EventCard(event: event);
              },
            ),
          );
        },
      ),
    );
  }
}