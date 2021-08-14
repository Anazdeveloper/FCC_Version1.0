import 'dart:convert';
import 'dart:core';

import 'package:first_class_canine_demo/Modal/BookingListModal.dart';
import 'package:first_class_canine_demo/Modal/ProfileModal.dart';
import 'package:first_class_canine_demo/Modal/UserAddressModal.dart';
import 'package:first_class_canine_demo/Service/Api.dart';
import 'package:first_class_canine_demo/Service/Urls.dart';
import 'package:first_class_canine_demo/Storage/Pref/Shared.dart';

import 'Repo.dart';

abstract class Repo {
  Future getData();
}

class ProfileRepo extends Repo {
  @override
  Future getProfileData() async {
    final pref = await Shared().getSharedStorage();
    if (!pref.containsKey("app_token") && pref.get("app_token") == null) {
      print("no token");
      await AppToken().getData();
      await RefreshToken().getData();
    }

    final response = await Http().get(Urls.profile, pref.get('user_token'), ContentType.urlEncode);

    print("ProfileResponse:${response.statusCode}");
    switch (response.statusCode) {
      case 200:
        print(response.body);
        return Profile.fromJson(jsonDecode(response.body));
      case 400:
        return Profile.fromJson(response.body);
      case 403:
        await RefreshToken().getData();
        final response = await Http().get(Urls.profile, pref.get('user_token'), ContentType.urlEncode);
        return Profile.fromJson(jsonDecode(response.body));
      default:
        return Profile.fromJson(response.body);
    }
  }

  Future getAddressData() async {
    final pref = await Shared().getSharedStorage();
    if (!pref.containsKey("app_token") && pref.get("app_token") == null) {
      print("no token");
      await AppToken().getData();
      await RefreshToken().getData();
    }
    final response = await Http().get(Urls.useraddressCreate + pref.get('addr_id').toString(), pref.get('user_token'), ContentType.urlEncode);
    print("AddressResponse:${response.statusCode}");
    switch (response.statusCode) {
      case 200:
        return UserAddressModal.fromJson(jsonDecode(response.body));
      case 400:
        return userAddressModalFromJson(response.body);
      case 403:
        await RefreshToken().getData();
        final response = await Http().get(Urls.useraddressCreate + pref.get('addr_id').toString(), pref.get('user_token'), ContentType.urlEncode);
        return UserAddressModal.fromJson(jsonDecode(response.body));
      default:
        return UserAddressModal();
    }
  }

  Future getBookingList() async {
    final pref = await Shared().getSharedStorage();
    if (!pref.containsKey("app_token") && pref.get("app_token") == null) {
      print("no token");
      await AppToken().getData();
      await RefreshToken().getData();
    }
    final response = await Http().get(Urls.bookinglist, pref.get('user_token'), ContentType.urlEncode);
    print("BookingListResponse:${response.statusCode}");
    switch (response.statusCode) {
      case 200:
        print(response.body);
        return BookingListModal.fromJson(jsonDecode(response.body));
      case 400:
        return bookingListModalFromJson(response.body);
      case 403:
        return bookingListModalFromJson(response.body);
      default:
        return BookingListModal();
    }
  }

  @override
  Future getData() async{
  }
}
