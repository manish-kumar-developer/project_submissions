import 'package:intl/intl.dart';

class Event {
  final int id;
  final String name;
  final String description;
  final DateTime eventDate;
  final String? imagePath;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  Event({
    required this.id,
    required this.name,
    required this.description,
    required this.eventDate,
    this.imagePath,
    this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      eventDate: DateTime.parse(json['event_date']),
      imagePath: json['image_path'],
      imageUrl: json['image_url'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  String get formattedDate {
    return DateFormat('MMM dd, yyyy - hh:mm a').format(eventDate);
  }

  String get daysUntil {
    final now = DateTime.now();
    final difference = eventDate.difference(now).inDays;
    return '$difference days';
  }

  bool get isUpcoming => eventDate.isAfter(DateTime.now());
}