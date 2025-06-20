class SignOutModel {
  String? status;
  String? message;

  SignOutModel({
    this.status,
    this.message,
  });

  SignOutModel copyWith({
    String? status,
    String? message,
  }) =>
      SignOutModel(
        status: status ?? this.status,
        message: message ?? this.message,
      );

  factory SignOutModel.fromJson(Map<String, dynamic> json) => SignOutModel(
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
  };
}
