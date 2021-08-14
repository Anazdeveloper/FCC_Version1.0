// To parse this JSON data, do
//
//     final createAddressSuccess = createAddressSuccessFromJson(jsonString);

import 'dart:convert';

CreateAddressSuccess createAddressSuccessFromJson(String str) => CreateAddressSuccess.fromJson(json.decode(str));

String createAddressSuccessToJson(CreateAddressSuccess data) => json.encode(data.toJson());

class CreateAddressSuccess {
  CreateAddressSuccess({
    this.status,
    this.message,
    this.data,
  });

  bool ? status;
  String ? message;
  AddressData ? data;

  factory CreateAddressSuccess.fromJson(Map<String, dynamic> json) => CreateAddressSuccess(
    status: json["status"],
    message: json["message"],
    data: AddressData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data!.toJson(),
  };
}

class AddressData {
  AddressData({
    this.id,
  });

  int ? id;

  factory AddressData.fromJson(Map<String, dynamic> json) => AddressData(
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
  };
}
