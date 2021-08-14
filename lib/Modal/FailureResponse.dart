// To parse this JSON data, do
//
//     final failureResponse = failureResponseFromJson(jsonString);

import 'dart:convert';

FailureResponse failureResponseFromJson(String str) => FailureResponse.fromJson(json.decode(str));

String failureResponseToJson(FailureResponse data) => json.encode(data.toJson());

class FailureResponse {
  FailureResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  bool status;
  String message;
  Data data;

  factory FailureResponse.fromJson(Map<String, dynamic> json) => FailureResponse(
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
