// To parse this JSON data, do
//
//     final staticDataModal = staticDataModalFromJson(jsonString);

import 'dart:convert';

StaticDataModal staticDataModalFromJson(String str) =>
    StaticDataModal.fromJson(json.decode(str));

String staticDataModalToJson(StaticDataModal data) =>
    json.encode(data.toJson());

class StaticDataModal {
  StaticDataModal({
    this.status,
    this.message,
    this.data,
  });

  bool? status;
  String? message;
  StaticData? data;

  factory StaticDataModal.fromJson(Map<String, dynamic> json) =>
      StaticDataModal(
        status: json["status"],
        message: json["message"],
        data: StaticData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data!.toJson(),
  };
}

class StaticData {
  StaticData({
    this.aboutUs,
    this.contactUs,
    this.privacyPolicy,
    this.terms,
    this.cancelationNote
  });

  TUs? aboutUs;
  TUs? contactUs;
  TUs? privacyPolicy;
  TUs? terms;
  TUs? cancelationNote;
  factory StaticData.fromJson(Map<String, dynamic> json) => StaticData(
    aboutUs: TUs.fromJson(json["about_us"]),
    contactUs: TUs.fromJson(json["contact_us"]),
    privacyPolicy: TUs.fromJson(json["privacy_policy"]),
    terms: TUs.fromJson(json["terms"]),
    cancelationNote: TUs.fromJson(json["cancellation_note"]),
  );

  Map<String, dynamic> toJson() => {
    "about_us": aboutUs!.toJson(),
    "contact_us": contactUs!.toJson(),
    "privacy_policy": privacyPolicy!.toJson(),
    "terms": terms!.toJson(),
    "cancellation_note": cancelationNote!.toJson(),
  };
}

class TUs {
  TUs({
    this.title,
    this.description,
  });

  String? title;
  String? description;

  factory TUs.fromJson(Map<String, dynamic> json) => TUs(
    title: json["title"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "description": description,
  };
}
