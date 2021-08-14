import 'dart:convert';
import 'dart:core';

import 'package:first_class_canine_demo/Modal/EventListModal.dart';
import 'package:first_class_canine_demo/Modal/JsonModal.dart';
import 'package:first_class_canine_demo/Service/Api.dart';
import 'package:first_class_canine_demo/Service/Urls.dart';
import 'package:first_class_canine_demo/Storage/Pref/Shared.dart';

import '../Service/Api.dart';
import 'Repo.dart';

abstract  class Repo{
  Future getData();
}

class HomeRepo extends Repo {
  @override
  Future getData() async{
    final pref=await Shared().getSharedStorage();
    if(!pref.containsKey("app_token") && pref.get("app_token")==null)
    {
      print("no token");
      await AppToken().getData();
    }
    await RefreshToken().getData;
    print('App Token: ${pref.get('app_token')}');
    print("UserToken: ${pref.get('user_token')}");
    final response=await Http().get(Urls.eventDetails + '?type=upcoming', pref.get('app_token'), ContentType.urlEncode);

    switch(response.statusCode)
    {
      case 200:
        return EventList.fromJson(jsonDecode(response.body));
      case 400:
        return jsonModalFromJson(response.body);
      case 403:
        return jsonModalFromJson(response.body);
      default:
        return jsonModalFromJson(response.body);
    }
    throw "error";
  }

}