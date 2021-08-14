// To parse this JSON data, do
//
//     final myEventModal = myEventModalFromJson(jsonString);

import 'dart:convert';

MyEventModal myEventModalFromJson(String str) => MyEventModal.fromJson(json.decode(str));

String myEventModalToJson(MyEventModal data) => json.encode(data.toJson());

class MyEventModal {
  MyEventModal({
    this.status,
    this.message,
    this.data,
  });

  bool ? status;
  String ? message;
  Data ? data;

  factory MyEventModal.fromJson(Map<String, dynamic> json) => MyEventModal(
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
    this.kennelName,
    this.bookedDate,
    this.totalAmount,
    this.createdAt,
    this.bookingStatus,
    this.payStatus,
    this.name,
    this.email,
    this.address,
    this.city,
    this.state,
    this.pincode,
    this.eventBanner,
    this.timingInfo,
    this.event,
    this.startDate,
    this.slots,
    this.paymentLogs,
    this.txnId,
    this.statusLabel
  });

  String ? reference;
  dynamic ? kennelName;
  DateTime ? bookedDate;
  int ? totalAmount;
  DateTime ? createdAt;
  String ? bookingStatus;
  String ? payStatus;
  String ? statusLabel;
  String ? name;
  String ? email;
  String ? address;
  String ? city;
  String ? state;
  String ? pincode;
  String ? eventBanner;
  String ? timingInfo;
  String ? event;
  DateTime ? startDate;
  List<Slot> ? slots;
  List<PaymentLog> ? paymentLogs;
  String ? txnId;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    reference: json["reference"]??"",
    kennelName: json["kennel_name"]??"",
    bookedDate: DateTime.parse(json["booked_date"]??""),
    totalAmount: json["total_amount"]??"",
    createdAt: DateTime.parse(json["created_at"]??""),
    bookingStatus: json["booking_status"]??"",
    payStatus: json["pay_status"]??"",
    statusLabel: json["status_label"]??"",
    name: json["name"]??"",
    email: json["email"]??"",
    address: json["address"]??"",
    city: json["city"]??"",
    state: json["state"]??"",
    pincode: json["pincode"]??"",
    eventBanner: json["event_banner"]??"",
    timingInfo: json["timing_info"]??"",
    event: json["event"]??"",
    startDate: DateTime.parse(json["start_date"]??""),
    slots: List<Slot>.from(json["slots"].map((x) => Slot.fromJson(x))),
    paymentLogs: List<PaymentLog>.from(json["payment_logs"].map((x) => PaymentLog.fromJson(x))),
    txnId: json["txn_id"]??"",
  );

  Map<String, dynamic> toJson() => {
    "reference": reference,
    "kennel_name": kennelName,
    "booked_date": bookedDate!.toIso8601String(),
    "total_amount": totalAmount,
    "created_at": createdAt!.toIso8601String(),
    "booking_status": bookingStatus,
    "pay_status": payStatus,
    "name": name,
    "email": email,
    "address": address,
    "city": city,
    "state": state,
    "pincode": pincode,
    "event_banner": eventBanner,
    "timing_info": timingInfo,
    "event": event,
    "start_date": startDate!.toIso8601String(),
    "slots": List<dynamic>.from(slots!.map((x) => x.toJson())),
    "payment_logs": List<dynamic>.from(paymentLogs!.map((x) => x.toJson())),
    "txn_id": txnId,
  };
}

class PaymentLog {
  PaymentLog({
    this.date,
    this.type,
    this.amount,
    this.status,
    this.txnId,
  });

  DateTime ? date;
  String ? type;
  int ? amount;
  String ? status;
  String ? txnId;

  factory PaymentLog.fromJson(Map<String, dynamic> json) => PaymentLog(
    date: DateTime.parse(json["date"]??""),
    type: json["type"]??"",
    amount: json["amount"]??"",
    status: json["status"]??"",
    txnId: json["txn_id"]??"",
  );

  Map<String, dynamic> toJson() => {
    "date": date!.toIso8601String(),
    "type": type,
    "amount": amount,
    "status": status,
    "txn_id": txnId,
  };
}

class Slot {
  Slot({
    this.name,
    this.slotNumber,
    this.additionalPets,
  });

  String ? name;
  int ? slotNumber;
  int ? additionalPets;

  factory Slot.fromJson(Map<String, dynamic> json) => Slot(
    name: json["name"]??"",
    slotNumber: json["slot_number"]??"",
    additionalPets: json["additional_pets"]??"",
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "slot_number": slotNumber,
    "additional_pets": additionalPets,
  };
}
