// To parse this JSON data, do
//
//     final myEventCancelModal = myEventCancelModalFromJson(jsonString);

import 'dart:convert';

MyEventCancelModal myEventCancelModalFromJson(String str) => MyEventCancelModal.fromJson(json.decode(str));

String myEventCancelModalToJson(MyEventCancelModal data) => json.encode(data.toJson());

class MyEventCancelModal {
  MyEventCancelModal({
    this.status,
    this.message,
    this.data,
  });

  bool ? status;
  String ? message;
  Data ? data;

  factory MyEventCancelModal.fromJson(Map<String, dynamic> json) => MyEventCancelModal(
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
    this.reference,
  });

  String ? reference;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    reference: json["reference"],
  );

  Map<String, dynamic> toJson() => {
    "reference": reference,
  };
}
