import 'dart:convert';

EventDetails eventDetailsFromJson(String str) =>
    EventDetails.fromJson(json.decode(str));

String eventDetailsToJson(EventDetails data) => json.encode(data.toJson());

class EventDetails {
  EventDetails({
    this.status,
    this.message,
    this.data,
  });

  bool? status;
  String? message;
  Data? data;

  factory EventDetails.fromJson(Map<String, dynamic> json) => EventDetails(
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
    this.slug,
    this.title,
    this.timing_info,
    this.address,
    this.city,
    this.state,
    this.pincode,
    this.startDate,
    this.endDate,
    this.details,
    this.features,
    this.booths,
    this.bannerPath,
    this.mapPath,
    this.isFeatured,
    this.isExpired,
    this.boothTypes
  });

  String? slug;
  String? title;
  String? address;
  String? city;
  String? state;
  String? pincode;
  String ? timing_info;
  DateTime? startDate;
  dynamic? endDate;
  List<String>? details;
  List<String>? features;
  List<Booth>? booths;
  dynamic? bannerPath;
  dynamic? mapPath;
  int? isFeatured;
  int ? isExpired;
  List<BoothTypes> ? boothTypes;


  factory Data.fromJson(Map<String, dynamic> json) => Data(
    slug: json["slug"]??"",
    title: json["title"]??"",
    timing_info: json["timing_info"]??"",
    address: json["address"]??"",
    city: json["city"]??"",
    state: json["state"]??"",
    pincode: json["pincode"]??"",
    startDate: DateTime.parse(json["start_date"]),
    endDate: json["end_date"]??"",
    details: List<String>.from(json["details"].map((x) => x)??""),
    features: List<String>.from(json["features"].map((x) => x)??""),
    booths: List<Booth>.from(json["booths"].map((x) => Booth.fromJson(x))??""),
    bannerPath: json["banner_path"],
    mapPath: json["map_path"],
    isFeatured: json["is_featured"]??"",
    isExpired : json["is_expired"]??"",
    boothTypes: List<BoothTypes>.from(json["booth_types"].map((x) => BoothTypes.fromJson(x))??""),


  );

  Map<String, dynamic> toJson() => {
    "slug": slug,
    "title": title,
    "address": address,
    "city": city,
    "state": state,
    "pincode": pincode,
    "start_date": startDate!.toIso8601String(),
    "end_date": endDate,
    "details": List<dynamic>.from(details!.map((x) => x)),
    "features": List<dynamic>.from(features!.map((x) => x)),
    "booths": List<dynamic>.from(booths!.map((x) => x.toJson())),
    "banner_path": bannerPath,
    "map_path": mapPath,
    "is_featured": isFeatured,
  };
}

class Booth {
  Booth({
    this.number,
    this.name,
    this.slug,
    this.price,
    this.priceExtra,
    this.limitWristBand,
    this.limitDog,
    this.colorHex,
    this.availabile
  });

  int? number;
  String? name;
  String? slug;
  double? price;
  double? priceExtra;
  int? limitWristBand;
  int? limitDog;
  bool ? availabile;
  String ? colorHex;
  bool ? selected;

  factory Booth.fromJson(Map<String, dynamic> json) => Booth(
    number: json["number"]??"",
    name: json["name"]??"",
    slug: json["slug"]??"",
    price: json["price"].toDouble()??"",
    priceExtra: json["price_extra"].toDouble()??"",
    limitWristBand: json["limit_wrist_band"]??"",
    limitDog: json["limit_dog"]??"",
    availabile: json["availabile"]??"",
    colorHex : "0xff"+json['color_hex'],
  );

  get getStatus{
    return selected;
  }
  set setStatus(bool status){
    selected=status;
  }

  Map<String, dynamic> toJson() => {
    "number": number,
    "name": name,
    "slug": slug,
    "price": price,
    "price_extra": priceExtra,
    "limit_wrist_band": limitWristBand,
    "limit_dog": limitDog,
    "availabile": availabile,
  };
}
class BoothTypes {
  String ? name;
  String ? slug;
  int ? price;
  int ? priceExtra;
  int ? limitWristBand;
  int ? limitDog;
  String ? colorHex;

  BoothTypes(
      {this.name,
        this.slug,
        this.price,
        this.priceExtra,
        this.limitWristBand,
        this.limitDog,
        this.colorHex});

  BoothTypes.fromJson(Map<String, dynamic> json) {
    name = json['name']??"";
    slug = json['slug']??"";
    price = json['price']??"";
    priceExtra = json['price_extra']??"";
    limitWristBand = json['limit_wrist_band']??"";
    limitDog = json['limit_dog']??"";
    colorHex = "0xff"+json['color_hex'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['price'] = this.price;
    data['price_extra'] = this.priceExtra;
    data['limit_wrist_band'] = this.limitWristBand;
    data['limit_dog'] = this.limitDog;
    data['color_hex'] = this.colorHex;
    return data;
  }
}