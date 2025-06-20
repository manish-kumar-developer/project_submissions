class EventModel {
  final String name;
  final String description;
  final String place;
  final String imagePath;
  final DateTime dateTime;

  EventModel({
    required this.name,
    required this.description,
    required this.place,
    required this.imagePath,
    required this.dateTime,
  });

  EventModel copyWith({
    String? name,
    String? description,
    String? place,
    String? imagePath,
    DateTime? dateTime,
  }) {
    return EventModel(
      name: name ?? this.name,
      description: description ?? this.description,
      place: place ?? this.place,
      imagePath: imagePath ?? this.imagePath,
      dateTime: dateTime ?? this.dateTime,
    );
  }
}
