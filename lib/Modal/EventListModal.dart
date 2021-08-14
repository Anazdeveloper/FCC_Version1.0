import 'dart:convert';

EventList eventlistFromJson(String str) => EventList.fromJson(json.decode(str));

String eventlistToJson(EventList data) => json.encode(data.toJson());

class EventList {
  EventList({required this.status, required this.message, required this.data});

  bool status;
  String message;
  List<EventData> data;

  factory EventList.fromJson(Map<String, dynamic> json) => EventList(
      status: json["status"],
      message: json["message"],
      data: List<EventData>.from(json["data"].map((x) => EventData.fromJson(x))),
  );

  Map<String,dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };

  // Future<List<EventData>?>getData() async{
  //   final response= await Future.delayed(Duration(seconds: 1));
  //   return data.map((json) => EventData.fromJson(json)).toList();
  // }

}

class EventData {
  EventData({
    required this.slug,
    required this.title,
    required this.address,
    required this.city,
    required this.state,
    required this.pincode,
    required this.startDate,
    this.endDate,
    this.bannerPath,
    this.mapPath,
  });

  String slug;
  String title;
  String address;
  String city;
  String state;
  String pincode;
  DateTime startDate;
  dynamic endDate;
  dynamic bannerPath;
  dynamic mapPath;

  factory EventData.fromJson(Map<String, dynamic> json) => EventData(
    slug: json["slug"]==null?"":json["slug"],
    title: json["title"]==null?"":json["title"],
    address: json["address"]==null?"":json["address"],
    city: json["city"]==null?"":json["city"],
    state: json["state"]==null?"":json["state"],
    pincode:json["pincode"]==null?"":json["pincode"],
    startDate: DateTime.parse(json["start_date"]),
    endDate: json["end_date"]==null?"":json["end_date"],
    bannerPath: json["banner_path"]==null?"":json["banner_path"],
    mapPath: json["map_path"]==null?"":json["map_path"],
  );

  Map<String, dynamic> toJson() => {
    "slug": slug,
    "title": title,
    "address": address,
    "city": city,
    "state": state,
    "pincode": pincode,
    "start_date": startDate.toIso8601String(),
    "end_date": endDate,
    "banner_path": bannerPath,
    "map_path": mapPath,
  };

}







// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

// import 'dart:convert';
//
// Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));
//
// String welcomeToJson(Welcome data) => json.encode(data.toJson());
//
// class Welcome {
//   Welcome({
//     this.status,
//     this.message,
//     this.data,
//   });
//
//   bool status;
//   String message;
//   List<Datum> data;
//
//   factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
//     status: json["status"],
//     message: json["message"],
//     data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "status": status,
//     "message": message,
//     "data": List<dynamic>.from(data.map((x) => x.toJson())),
//   };
// }

