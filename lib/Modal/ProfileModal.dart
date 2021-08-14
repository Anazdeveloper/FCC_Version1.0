import 'dart:convert';

Profile ProfileFromJson(String str) => Profile.fromJson(json.decode(str));

String ProfileToJson(Profile data) => json.encode(data.toJson());

class Profile {
  Profile({
    required this.status,
    required this.message,
    required this.data,
  });

  bool status;
  String message;
  ProfileData data;

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        status: json["status"],
        message: json["message"],
        data: ProfileData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
      };
}

class ProfileData {
  ProfileData(
      {required this.name,
      required this.email,
      required this.username,
      required this.phone,
      required this.role,
      required this.image,
      required this.createdAt,
      required this.updatedAt,
      required this.profile,
      otp_created});

  String name;
  String email;
  String username;
  String phone;
  String role;
  dynamic image;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic profile;
  dynamic? otp_created;

  factory ProfileData.fromJson(Map<String, dynamic> json) => ProfileData(
        name: json["name"] ?? '',
        email: json["email"] ?? '',
        username: json["username"] ?? '',
        phone: json["phone"] ?? '',
        role: json["role"] ?? '',
        image: json["image"] ?? '',
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        profile: json["profile"] ?? '',
        otp_created: json["otp_created_at"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "username": username,
        "phone": phone,
        "role": role,
        "image": image,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "profile": profile,
        "otp_created": otp_created
  };
}
