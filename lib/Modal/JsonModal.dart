// To parse this JSON data, do
//
//     final jsonModal = jsonModalFromJson(jsonString);

import 'dart:convert';

JsonModal jsonModalFromJson(String str) => JsonModal.fromJson(json.decode(str));

String jsonModalToJson(JsonModal data) => json.encode(data.toJson());

class JsonModal {
  JsonModal({
    this.status,
    this.message,
    this.data,
  });

  bool ? status;
  String ? message;
  Data ? data;

  factory JsonModal.fromJson(Map<String, dynamic> json) => JsonModal(
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
    this.appToken,
  });

  String ? appToken;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    appToken: json["app_token"],
  );

  Map<String, dynamic> toJson() => {
    "app_token": appToken,
  };
}
