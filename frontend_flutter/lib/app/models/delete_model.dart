class DeleteModel {
  String? status;
  String? message;

  DeleteModel({
    this.status,
    this.message,
  });

  DeleteModel copyWith({
    String? status,
    String? message,
  }) =>
      DeleteModel(
        status: status ?? this.status,
        message: message ?? this.message,
      );

  factory DeleteModel.fromJson(Map<String, dynamic> json) => DeleteModel(
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
  };
}
