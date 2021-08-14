import 'dart:convert';
import 'dart:core';

import 'package:first_class_canine_demo/Modal/JsonModal.dart';
import 'package:first_class_canine_demo/Modal/ShowEventModal.dart';
import 'package:first_class_canine_demo/Modal/StaticDataModal.dart';
import 'package:first_class_canine_demo/Repo/StaticDataRepo.dart';
import 'package:first_class_canine_demo/Service/Api.dart';
import 'package:first_class_canine_demo/Service/DeviceInfo.dart';
import 'package:first_class_canine_demo/Service/Urls.dart';
import 'package:first_class_canine_demo/Storage/Database/BookingDAO.dart';
import 'package:first_class_canine_demo/Storage/Database/Database.dart';
import 'package:first_class_canine_demo/Storage/Pref/Shared.dart';

import '../Service/Api.dart';

abstract class Repo {
  Future getData();
}

abstract class PostRepo {
  Future postData();
}

class EventsRepo extends Repo {
  final slug;
  EventsRepo(this.slug);
  @override
  Future getData() async {
    final pref = await Shared().getSharedStorage();
    if (pref.containsKey("app_token")) {
      if (pref.get("app_token") == null) {
        // print("No app token");
        final jsonBody = await AppToken().getData();
      }
    } else {
      final jsonBody = await AppToken().getData();
    }
    final response =
    await Http().get(Urls.eventDetails + "/" + slug, pref.get('app_token'),ContentType.urlEncode);
    switch (response.statusCode) {
      case 200:
        print(response.body);
        return eventDetailsFromJson(response.body);
      case 403:
        return jsonModalFromJson(response.body);
      default:
        return jsonModalFromJson(response.body);
    }
  }

  Future getCart() async {
    final pref = await Shared().getSharedStorage();
    if (pref.containsKey("user_token")) {
      if (pref.get("user_token") == null) {
        // print("No app token");
        await RefreshToken().getData();
      }
    } else {
      await RefreshToken().getData();
    }
    final response = await Http().get(Urls.getCart, pref.get('user_token'),ContentType.json);
    switch (response.statusCode) {
      case 200:
        return jsonDecode(response.body);
      case 403:
        await RefreshToken().getData();
        final response = await Http().get(Urls.getCart, pref.get('user_token'),ContentType.json);
        return jsonDecode(response.body);
      default:
        return jsonDecode(response.body);
    }
  }
  Future clearCart() async {
    final pref = await Shared().getSharedStorage();
    if (pref.containsKey("user_token")) {
      if (pref.get("user_token") == null) {
        await RefreshToken().getData();
      }
    } else {
      await RefreshToken().getData();
    }
    final response = await Http().delete("",Urls.getCart, pref.get('user_token'),ContentType.json);
    switch (response.statusCode) {
      case 200:
      // await clearDB();
        return jsonDecode(response.body);
      case 403:
        await RefreshToken().getData();
        final response = await Http().delete("",Urls.getCart, pref.get('user_token'),ContentType.json);
        return jsonDecode(response.body);
      default:
        return jsonDecode(response.body);
    }
  }
  Future clearDB() async{
    final db=await LocalDB().getLocalDB();;
    await db.deleteAllBookings();
  }
}

class RefreshToken extends Repo {
  @override
  Future getData() async {
    final pref = await Shared().getSharedStorage();
    final response = await Http()
        .post({"token": pref.get("refresh_token")}, Urls.refreshToken,"",ContentType.urlEncode);
    final responseBody = jsonDecode(response.body);
    if (responseBody['status'] == true)
      await pref.setString("user_token", responseBody['token']);
    print('UserToken:${pref.get('user_token')}');
    return responseBody['token'];
  }
}

class AppToken extends Repo {
  @override
  Future getData() async {
    final appID = await DeviceInfo().deviceID();
    final pref = await Shared().getSharedStorage();
    final response = await Http().post({"app_id": appID}, Urls.appToken, "",ContentType.urlEncode);
    final responseBody = jsonModalFromJson(response.body);
    if (responseBody.status == true)
      await pref.setString("app_token", responseBody.data!.appToken!);
    return responseBody.data!.appToken!;
  }
}

// class AddressId extends Repo {
//   final inputData;
//   AddressId(this.inputData);
//
//   @override
//   Future getData() async {
//     final pref = await Shared().getSharedStorage();
//     final token = pref.get("user_token");
//     final response = await Http().post(inputData, Urls.useraddressCreate, token, ContentType.urlEncode);
//     final responseBody = jsonDecode(response.body);
//     if(responseBody.status == true)
//       await pref.setString("addr_id", responseBody['data']['id']);
//     print('Address Id:${responseBody['data']['id']}');
//     return response;
//   }
// }

class LocalDB {
  Future<BookingDAO> getLocalDB() async {
    final db =
    await $FloorAppDatabase.databaseBuilder('app_Database.db').build();
    final bookingDB = db.bookingDao;
    return bookingDB;
  }
}
