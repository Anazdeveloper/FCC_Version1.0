// To parse this JSON data, do
//
//     final editProfileFailure = editProfileFailureFromJson(jsonString);

import 'dart:convert';

EditProfileFailure editProfileFailureFromJson(String str) => EditProfileFailure.fromJson(json.decode(str));

String editProfileFailureToJson(EditProfileFailure data) => json.encode(data.toJson());

class EditProfileFailure {
  EditProfileFailure({
    required this.status,
    required this.message,
    required this.data,
  });

  bool status;
  String message;
  Data data;

  factory EditProfileFailure.fromJson(Map<String, dynamic> json) => EditProfileFailure(
    status: json["status"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  Data({
    required this.username,
  });

  List<String> username;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    username: List<String>.from(json["username"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "username": List<dynamic>.from(username.map((x) => x)),
  };
}
