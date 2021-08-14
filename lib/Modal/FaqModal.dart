// To parse this JSON data, do
//
//     final faqModal = faqModalFromJson(jsonString);

import 'dart:convert';

FaqModal faqModalFromJson(String str) => FaqModal.fromJson(json.decode(str));

String faqModalToJson(FaqModal data) => json.encode(data.toJson());

class FaqModal {
  FaqModal({
    this.status,
    this.message,
    this.data,
  });

  bool ? status;
  String ? message;
  List<FaqData> ? data;

  factory FaqModal.fromJson(Map<String, dynamic> json) => FaqModal(
    status: json["status"],
    message: json["message"],
    data: List<FaqData>.from(json["data"].map((x) => FaqData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class FaqData {
  FaqData({
    this.id,
    this.question,
    this.answer,
  });

  int ? id;
  String ? question;
  String ? answer;

  factory FaqData.fromJson(Map<String, dynamic> json) => FaqData(
    id: json["id"],
    question: json["question"],
    answer: json["answer"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "question": question,
    "answer": answer,
  };
}
