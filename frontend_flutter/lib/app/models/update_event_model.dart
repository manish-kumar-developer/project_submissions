class UpdateEventModel {
  String? status;
  String? message;
  Data? data;

  UpdateEventModel({
    this.status,
    this.message,
    this.data,
  });

  UpdateEventModel copyWith({
    String? status,
    String? message,
    Data? data,
  }) =>
      UpdateEventModel(
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory UpdateEventModel.fromJson(Map<String, dynamic> json) => UpdateEventModel(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  int? id;
  String? name;
  String? description;
  DateTime? eventDate;
  String? imageUrl;
  DateTime? createdAt;
  DateTime? updatedAt;

  Data({
    this.id,
    this.name,
    this.description,
    this.eventDate,
    this.imageUrl,
    this.createdAt,
    this.updatedAt,
  });

  Data copyWith({
    int? id,
    String? name,
    String? description,
    DateTime? eventDate,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      Data(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        eventDate: eventDate ?? this.eventDate,
        imageUrl: imageUrl ?? this.imageUrl,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    eventDate: json["event_date"] == null ? null : DateTime.parse(json["event_date"]),
    imageUrl: json["image_url"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "event_date": eventDate?.toIso8601String(),
    "image_url": imageUrl,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
