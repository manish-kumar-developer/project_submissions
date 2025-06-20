class ListViewModel {
  String? status;
  List<Datum>? data;
  Meta? meta;

  ListViewModel({
    this.status,
    this.data,
    this.meta,
  });

  ListViewModel copyWith({
    String? status,
    List<Datum>? data,
    Meta? meta,
  }) =>
      ListViewModel(
        status: status ?? this.status,
        data: data ?? this.data,
        meta: meta ?? this.meta,
      );

  factory ListViewModel.fromJson(Map<String, dynamic> json) => ListViewModel(
    status: json["status"],
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "meta": meta?.toJson(),
  };
}

class Datum {
  int? id;
  String? name;
  String? description;
  DateTime? eventDate;
  String? imageUrl;
  DateTime? createdAt;
  DateTime? updatedAt;

  Datum({
    this.id,
    this.name,
    this.description,
    this.eventDate,
    this.imageUrl,
    this.createdAt,
    this.updatedAt,
  });

  Datum copyWith({
    int? id,
    String? name,
    String? description,
    DateTime? eventDate,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      Datum(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        eventDate: eventDate ?? this.eventDate,
        imageUrl: imageUrl ?? this.imageUrl,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
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

class Meta {
  int? currentPage;
  int? perPage;
  int? total;
  int? lastPage;

  Meta({
    this.currentPage,
    this.perPage,
    this.total,
    this.lastPage,
  });

  Meta copyWith({
    int? currentPage,
    int? perPage,
    int? total,
    int? lastPage,
  }) =>
      Meta(
        currentPage: currentPage ?? this.currentPage,
        perPage: perPage ?? this.perPage,
        total: total ?? this.total,
        lastPage: lastPage ?? this.lastPage,
      );

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    currentPage: json["current_page"],
    perPage: json["per_page"],
    total: json["total"],
    lastPage: json["last_page"],
  );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "per_page": perPage,
    "total": total,
    "last_page": lastPage,
  };
}
