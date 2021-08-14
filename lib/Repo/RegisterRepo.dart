import 'dart:convert';
import 'dart:core';

import 'package:first_class_canine_demo/Modal/RegisterModal.dart';
import 'package:first_class_canine_demo/Repo/Repo.dart';
import 'package:first_class_canine_demo/Service/Api.dart';
import 'package:first_class_canine_demo/Service/Urls.dart';
import 'package:first_class_canine_demo/Storage/Pref/Shared.dart';

import '../Service/Api.dart';
class RegisterRepo extends Repo{
  final inputData;
  RegisterRepo(this.inputData);
  @override
  Future getData() async{
    final pref=await Shared().getSharedStorage();
    if(pref.containsKey("app_token"))
    {
      if(pref.get("app_token")==null)
      {
        final jsonBody=await AppToken().getData();
      }
    }
    else{
      final jsonBody=await AppToken().getData();
    }
    final response=await Http().post(RegisterModal().toJson(inputData),Urls.register,pref.getString('app_token'),ContentType.urlEncode);
    switch(response.statusCode)
    {
      case 200:
        return jsonDecode(response.body);
      case 400:
        return jsonDecode(response.body);
      case 422:
        return jsonDecode(response.body);
      default:
        return jsonDecode(response.body);
    }
  }
  Future verifyUser(String otp, String email)async{
    final pref=await Shared().getSharedStorage();
    if(pref.containsKey("app_token"))
    {
      if(pref.get("app_token")==null)
      {
        await AppToken().getData();
      }
    }
    else{
      await AppToken().getData();
    }
    final response=await Http().update({"otp":otp,"email":email},Urls.userActivate,pref.getString('app_token'),ContentType.urlEncode);
    switch(response.statusCode)
    {
      case 200:
        return jsonDecode(response.body);
      case 403:
        await AppToken().getData();
        final response=await Http().update({"otp":otp,"email":email},Urls.userActivate,pref.getString('app_token'),ContentType.urlEncode);
        print(response.body);
        return jsonDecode(response.body);
      default:
        print(response.body);
        return jsonDecode(response.body);
    }
  }
}