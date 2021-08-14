// To parse this JSON data, do
//
//     final myEventErrorModal = myEventErrorModalFromJson(jsonString);

import 'dart:convert';

MyEventErrorModal myEventErrorModalFromJson(String str) => MyEventErrorModal.fromJson(json.decode(str));

String myEventErrorModalToJson(MyEventErrorModal data) => json.encode(data.toJson());

class MyEventErrorModal {
  MyEventErrorModal({
    this.status,
    this.message,
    this.data,
  });

  bool ? status;
  String ? message;
  Data ? data;

  factory MyEventErrorModal.fromJson(Map<String, dynamic> json) => MyEventErrorModal(
    status: json["status"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data!.toJson(),
  };
}

class Data {
  Data({
    this.nonFieldError,
  });

  List<String> ? nonFieldError;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    nonFieldError: List<String>.from(json["non_field_error"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "non_field_error": List<dynamic>.from(nonFieldError!.map((x) => x)),
  };
}
