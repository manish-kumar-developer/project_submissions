import 'package:flutter/material.dart';
import 'package:frontend_flutter/models/event.dart';
import 'package:frontend_flutter/providers/event_provider.dart';
import 'package:frontend_flutter/screens/events/event_edit_screen.dart';
import 'package:frontend_flutter/widgets/role_based_widget.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class EventDetailScreen extends StatelessWidget {
  final Event event;

  const EventDetailScreen({super.key, required this.event});

  // Computed properties moved to screen
  String get formattedDate => DateFormat('MMM dd, yyyy - hh:mm a').format(event.eventDate);
  bool get isUpcoming => event.eventDate.isAfter(DateTime.now());
  String get daysUntil {
    if (!isUpcoming) return 'Past Event';
    final difference = event.eventDate.difference(DateTime.now());
    return 'In ${difference.inDays} days';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(event.name),
        actions: [
          RoleBasedWidget(
            allowedRoles: ['admin'],
            child: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventEditScreen(event: event),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (event.imageUrl.isNotEmpty)
              Image.network(
                event.imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            const SizedBox(height: 16),
            Text(
              event.name,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  formattedDate,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              event.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Chip(
              label: Text(
                isUpcoming ? 'Upcoming: $daysUntil' : 'Past Event',
                style: TextStyle(
                  color: isUpcoming ? Colors.green : Colors.grey,
                ),
              ),
              backgroundColor: isUpcoming
                  ? Colors.green[50]
                  : Colors.grey[200],
            ),
          ],
        ),
      ),
      floatingActionButton: RoleBasedWidget(
        allowedRoles: ['admin'],
        child: FloatingActionButton(
          onPressed: () async {
            final confirmed = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Delete Event'),
                content: const Text('Are you sure you want to delete this event?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Delete', style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            );

            if (confirmed == true) {
              final eventProvider = Provider.of<EventProvider>(context, listen: false);
              await eventProvider.deleteEvent(event.id);
              Navigator.pop(context);
            }
          },
          backgroundColor: Colors.red,
          child: const Icon(Icons.delete),
        ),
      ),
    );
  }
}