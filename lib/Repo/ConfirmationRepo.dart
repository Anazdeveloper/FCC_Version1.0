import 'dart:convert';

import 'package:first_class_canine_demo/Modal/JsonModal.dart';
import 'package:first_class_canine_demo/Modal/ShowEventModal.dart';
import 'package:first_class_canine_demo/Repo/Repo.dart';
import 'package:first_class_canine_demo/Service/Api.dart';
import 'package:first_class_canine_demo/Service/Urls.dart';
import 'package:first_class_canine_demo/Storage/Pref/Shared.dart';
import 'dart:core';

import '../Service/Api.dart';

abstract  class Repo{
  Future getData();
}
class ConfirmRepo extends Repo{
  final inputData;
  ConfirmRepo(this.inputData);
  @override
  Future getData() async{
    final pref=await Shared().getSharedStorage();
    if(pref.containsKey("user_token"))
    {
      if(pref.get("user_token")==null)
      {
        //print("No app token");
        await RefreshToken().getData();
      }
    }
    else{
      await RefreshToken().getData();
    }
    final response=await Http().post(inputData,Urls.login,pref.get('user_token'),ContentType.urlEncode);
    switch(response.statusCode)
    {
      case 200:
        final  responseBody=jsonDecode(response.body);
        if(responseBody['status']==true)
        {
        }
        return jsonDecode(response.body);
      case 400:
        return jsonDecode(response.body);
      case 403:
        return jsonDecode(response.body);
      default:
        return jsonDecode(response.body);
    }
    throw "error";
  }
}