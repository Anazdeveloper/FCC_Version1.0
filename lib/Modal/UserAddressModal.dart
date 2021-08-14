// To parse this JSON data, do
//
//     final userAddressModal = userAddressModalFromJson(jsonString);

import 'dart:convert';

UserAddressModal userAddressModalFromJson(String str) => UserAddressModal.fromJson(json.decode(str));

String userAddressModalToJson(UserAddressModal data) => json.encode(data.toJson());

class UserAddressModal {
  UserAddressModal({
    this.status,
    this.message,
    this.data,
  });

  bool ? status;
  String ? message;
  AddressData ? data;

  factory UserAddressModal.fromJson(Map<String, dynamic> json) => UserAddressModal(
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
    this.label,
    this.type,
    this.name,
    this.address,
    this.street,
    this.city,
    this.state,
    this.country,
    this.zip,
    this.isDeliverable,
    this.isActive,
  });

  String ? label;
  String ? type;
  String ? name;
  String ? address;
  String ? street;
  String ? city;
  String ? state;
  String ? country;
  String ? zip;
  int ? isDeliverable;
  int ? isActive;

  factory AddressData.fromJson(Map<String, dynamic> json) => AddressData(
    label: json["label"],
    type: json["type"],
    name: json["name"],
    address: json["address"],
    street: json["street"],
    city: json["city"],
    state: json["state"],
    country: json["country"],
    zip: json["zip"],
    isDeliverable: json["is_deliverable"],
    isActive: json["is_active"],
  );

  Map<String, dynamic> toJson() => {
    "label": label,
    "type": type,
    "name": name,
    "address": address,
    "street": street,
    "city": city,
    "state": state,
    "country": country,
    "zip": zip,
    "is_deliverable": isDeliverable,
    "is_active": isActive,
  };
}
