import 'dart:convert';

import 'package:first_class_canine_demo/Repo/Repo.dart';
import 'package:first_class_canine_demo/Service/Api.dart';
import 'package:first_class_canine_demo/Service/Urls.dart';
import 'package:first_class_canine_demo/Storage/Database/Booking.dart';
import 'package:first_class_canine_demo/Storage/Pref/Shared.dart';
import 'dart:core';

import '../Service/Api.dart';
class BookingRepo extends Repo{
  final inputData;
  BookingRepo({this.inputData});
  @override
  Future getData() async{
    final pref=await Shared().getSharedStorage();
    print("event${inputData.event}");
    if(pref.containsKey("user_token"))
    {
      if(pref.get("user_token")==null)
      {
        await RefreshToken().getData();
      }
    }
    else{
      await RefreshToken().getData();
    }
    print(jsonDecode(jsonEncode({"event":inputData.event,"slot_number":inputData.booth})));
    print("event${inputData.event}");
    final response=await Http().post(jsonEncode({"event":inputData.event,"slot_number":inputData.booth}),Urls.slotBooking,pref.getString('user_token'),ContentType.json);
    switch(response.statusCode)
    {
      case 200:
        return jsonDecode(response.body);
      case 403:
        await RefreshToken().getData();
        final response=await Http().post(jsonEncode({"event":inputData.event,"slot_number":inputData.booth}),Urls.slotBooking,pref.getString('user_token'),ContentType.json);
        return jsonDecode(response.body);
      default:
        print(response.body);
        return jsonDecode(response.body);
    }
  }
  Future getDB() async
  {
    return await LocalDB().getLocalDB();
  }
  Future deleteData() async
  {
    final pref=await Shared().getSharedStorage();
    if(pref.containsKey("user_token"))
    {
      if(pref.get("user_token")==null)
      {
        await RefreshToken().getData();
      }
    }
    else{
      await RefreshToken().getData();
    }
    final response=await Http().delete(jsonEncode({"event":inputData.event,"slot_number":inputData.booth}),Urls.slotBooking,pref.getString('user_token'),ContentType.json);
    print(response.body);
    switch(response.statusCode)
    {
      case 200:
        return jsonDecode(response.body);
      case 403:
        await RefreshToken().getData();
        final response=await Http().delete(jsonEncode({"event":inputData.event,"slot_number":inputData.booth}),Urls.slotBooking,pref.getString('user_token'),ContentType.json);
        return jsonDecode(response.body);
      default:
        return jsonDecode(response.body);
    }
  }
  Future cartData() async
  {
    final pref=await Shared().getSharedStorage();
    if(pref.containsKey("user_token"))
    {
      if(pref.get("user_token")==null)
      {
        await RefreshToken().getData();
      }
    }
    else{
      await RefreshToken().getData();
    }
    final response=await Http().get(Urls.slotBooking,pref.getString('user_token'),ContentType.urlEncode);
    switch(response.statusCode)
    {
      case 200:
        return jsonDecode(response.body);
      case 403:
        await RefreshToken().getData();
        final response=await Http().get(Urls.slotBooking,pref.getString('user_token'),ContentType.urlEncode);
        return jsonDecode(response.body);
      default:
        return jsonDecode(response.body);
    }
  }
  Future bookingConfirm(Map<String,String> json) async
  {
    final pref=await Shared().getSharedStorage();
    if(pref.containsKey("user_token"))
    {
      if(pref.get("user_token")==null)
      {
        await RefreshToken().getData();
      }
    }
    else{
      await RefreshToken().getData();
    }
    final response=await Http().post("",Urls.slotBooking,pref.getString('user_token'),ContentType.json);
    switch(response.statusCode)
    {
      case 200:
        return jsonDecode(response.body);
      case 403:
        await RefreshToken().getData();
        final response=await Http().post("",Urls.slotBooking,pref.getString('user_token'),ContentType.json);
        return jsonDecode(response.body);
      default:
        return jsonDecode(response.body);
    }
  }
  Future removePet(Booking removePet) async{
    final db=await LocalDB().getLocalDB();
    double price=removePet.price!;
    print("petscount remove:${removePet.additionalPets}");
    if (removePet.additionalPets! > 0) {
      int pets = removePet.additionalPets!- 1;
      if (pets >=0) {
        price = price - removePet.priceExtra!;
      }
      final booking = Booking(
          id: removePet.id,
          additionalPets: pets,
          index: removePet.index,
          additionalPetsLimits: removePet.additionalPetsLimits,
          booth: removePet.booth,
          slug: removePet.slug,
          event: removePet.event,
          price: price,
          name: removePet.name,
          wristBand: removePet.wristBand,
          wristBandCount: removePet.wristBand,
          available: removePet.available,
          priceExtra: removePet.priceExtra);
      await db.updateBooking(booking);
    }
  }
  Future addPet(Booking addPet) async{
    final db=await LocalDB().getLocalDB();
    double price=addPet.price!;
    if (addPet.additionalPets! <10) {
      int pets = addPet.additionalPets! + 1;
      print("petscount${pets}");
        price = price + addPet.priceExtra!;
      final booking = Booking(
          id: addPet.id,
          index: addPet.index,
          additionalPets: pets,
          additionalPetsLimits: addPet.additionalPetsLimits,
          booth: addPet.booth,
          event: addPet.event,
          slug: addPet.slug,
          price: price,
          name: addPet.name,
          available: addPet.available,
          wristBand: addPet.wristBand,
          wristBandCount: addPet.wristBand,
          priceExtra: addPet.priceExtra);
      await db.updateBooking(booking);
    }
  }
  Future deleteBooking(Booking booking) async{
    final db=await LocalDB().getLocalDB();
    db.deleteBooking(booking);
  }
  Future insertBooking(Booking booking) async{
    final db=await LocalDB().getLocalDB();
    db.insertBooking(booking);
  }
  Future clearDB() async{
    final db=await LocalDB().getLocalDB();
    await db.deleteAllBookings();
  }
}