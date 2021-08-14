// To parse this JSON data, do
//
//     final bookingListModal = bookingListModalFromJson(jsonString);

import 'dart:convert';

BookingListModal bookingListModalFromJson(String str) => BookingListModal.fromJson(json.decode(str));

String bookingListModalToJson(BookingListModal data) => json.encode(data.toJson());

class BookingListModal {
  BookingListModal({
    this.status,
    this.message,
    this.data,
  });

  bool ? status;
  String ? message;
  BookingData ? data;

  factory BookingListModal.fromJson(Map<String, dynamic> json) => BookingListModal(
    status: json["status"],
    message: json["message"],
    data: BookingData.fromJson(json["data"].length>0?json["data"]:{
      "upcoming":[],
      "other":[]
    }),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data!.toJson(),
  };
}

class BookingData {
  BookingData({
    this.upcoming,
    this.other,
  });

  List<Other> ? upcoming;
  List<Other> ? other;

  factory BookingData.fromJson(Map<String, dynamic> json) => BookingData(
    upcoming: List<Other>.from(json["upcoming"].map((x) => Other.fromJson(x))),
    other: List<Other>.from(json["other"].map((x) => Other.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "upcoming": List<dynamic>.from(upcoming!.map((x) => x)),
    "other": List<dynamic>.from(other!.map((x) => x.toJson())),
  };
}

class Other {
  Other({
    this.reference,
    this.bookedDate,
    this.totalAmount,
    this.bookingStatus,
    this.payStatus,
    this.eventBanner,
    this.event,
    this.startDate,
    this.statusLabel,
  });

  String ? reference;
  DateTime ? bookedDate;
  int ? totalAmount;
  String ? bookingStatus;
  String ? payStatus;
  String ? eventBanner;
  String ? event;
  DateTime ? startDate;
  String ? statusLabel;

  factory Other.fromJson(Map<String, dynamic> json) => Other(
    reference: json["reference"],
    bookedDate: DateTime.parse(json["booked_date"]),
    totalAmount: json["total_amount"],
    bookingStatus: json["booking_status"],
    payStatus: json["pay_status"],
    eventBanner: json["event_banner"],
    event: json["event"],
    startDate: DateTime.parse(json["start_date"]),
    statusLabel:json["status_label"],
  );

  Map<String, dynamic> toJson() => {
    "reference": reference,
    "booked_date": bookedDate!.toIso8601String(),
    "total_amount": totalAmount,
    "booking_status": bookingStatus,
    "pay_status": payStatus,
    "event_banner": eventBanner,
    "event": event,
    "start_date": startDate!.toIso8601String(),
  };
}