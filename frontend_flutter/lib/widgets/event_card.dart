import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:frontend_flutter/models/event.dart';
import 'package:intl/intl.dart';

class EventCard extends StatelessWidget {
  final Event event;
  final VoidCallback? onTap;
  final bool showStatusBadge;

  const EventCard({
    Key? key,
    required this.event,
    this.onTap,
    this.showStatusBadge = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isUpcoming = event.eventDate.isAfter(DateTime.now());
    final daysUntil = event.eventDate.difference(DateTime.now()).inDays;

    return Card(
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Event Image with Status Badge
            Stack(
              alignment: Alignment.topRight,
              children: [
                _buildImageSection(),
                if (showStatusBadge) _buildStatusBadge(isUpcoming, daysUntil),
              ],
            ),

            // Event Details
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.name,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    event.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 16, color: Colors.grey[700]),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          DateFormat('MMM dd, yyyy • hh:mm a').format(event.eventDate),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.access_time, size: 16, color: Colors.grey[700]),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return event.imageUrl.isNotEmpty
        ? CachedNetworkImage(
      imageUrl: event.imageUrl,
      height: 180,
      width: double.infinity,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
        height: 180,
        color: Colors.grey[200],
        child: const Center(
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        height: 180,
        color: Colors.grey[200],
        child: const Center(
          child: Icon(Icons.error_outline, color: Colors.red),
        ),
      ),
    )
        : Container(
      height: 180,
      color: Colors.grey[200],
      child: const Center(
        child: Icon(Icons.event, size: 64, color: Colors.grey),
      ),
    );
  }

  Widget _buildStatusBadge(bool isUpcoming, int daysUntil) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isUpcoming ? Colors.green : Colors.grey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isUpcoming ? 'In $daysUntil days' : 'Past Event',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}