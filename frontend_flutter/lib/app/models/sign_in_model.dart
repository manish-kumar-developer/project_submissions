class SignInModel {
  String? status;
  String? token;
  User? user;

  SignInModel({
    this.status,
    this.token,
    this.user,
  });

  SignInModel copyWith({
    String? status,
    String? token,
    User? user,
  }) =>
      SignInModel(
        status: status ?? this.status,
        token: token ?? this.token,
        user: user ?? this.user,
      );

  factory SignInModel.fromJson(Map<String, dynamic> json) => SignInModel(
    status: json["status"],
    token: json["token"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "token": token,
    "user": user?.toJson(),
  };
}

class User {
  int? id;
  String? name;
  String? email;
  String? role;

  User({
    this.id,
    this.name,
    this.email,
    this.role,
  });

  User copyWith({
    int? id,
    String? name,
    String? email,
    String? role,
  }) =>
      User(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        role: role ?? this.role,
      );

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    role: json["role"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "role": role,
  };
}
