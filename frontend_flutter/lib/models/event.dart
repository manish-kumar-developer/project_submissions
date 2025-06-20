class Event {
  final int id;
  final String name;
  final String description;
  final DateTime eventDate;
  final String imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  Event({
    required this.id,
    required this.name,
    required this.description,
    required this.eventDate,
    required this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Event.fromJson(Map<String, dynamic> json) => Event(
    id: int.parse(json['id'].toString()),
    name: json['name'],
    description: json['description'],
    eventDate: DateTime.parse(json['event_date']),
    imageUrl: json['image_url'],
    createdAt: DateTime.parse(json['created_at']),
    updatedAt: DateTime.parse(json['updated_at']),
  );
}