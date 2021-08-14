import 'dart:convert';

import 'package:first_class_canine_demo/Modal/JsonModal.dart';
import 'package:first_class_canine_demo/Modal/ShowEventModal.dart';
import 'package:first_class_canine_demo/Modal/UserAddressModal.dart';
import 'package:first_class_canine_demo/Repo/Repo.dart';
import 'package:first_class_canine_demo/Service/Api.dart';
import 'package:first_class_canine_demo/Service/Urls.dart';
import 'package:first_class_canine_demo/Storage/Pref/Shared.dart';
import 'dart:core';

import '../Service/Api.dart';

abstract  class Repo{
  Future getData();
}
class LoginRepo extends Repo{
  final inputData;
  LoginRepo(this.inputData);
  @override
  Future getData() async{
    final pref=await Shared().getSharedStorage();
    if(pref.containsKey("app_token"))
    {
      if(pref.get("app_token")==null)
      {
        //print("No app token");
        await AppToken().getData();
      }
    }
    else{
      await AppToken().getData();
    }
    final response=await Http().post(inputData,Urls.login,pref.get('app_token'),ContentType.urlEncode);
    switch(response.statusCode)
    {
      case 200:
        final  responseBody=jsonDecode(response.body);
        if(responseBody['status']==true)
        {
          await pref.setString('user_token',responseBody['data']['token']);
          await pref.setString('refresh_token',responseBody['data']['refresh_token']);
          await pref.setString('username',responseBody['data']['username']);
          await pref.setString('user',responseBody['data']['name']);
        }
        return jsonDecode(response.body);
      case 403:
        await AppToken().getData();
        final response=await Http().post(inputData,Urls.login,pref.get('app_token'),ContentType.urlEncode);
        final  responseBody=jsonDecode(response.body);
        if(responseBody['status']==true)
        {
          await pref.setString('user_token',responseBody['data']['token']);
          await pref.setString('refresh_token',responseBody['data']['refresh_token']);
          await pref.setString('username',responseBody['data']['username']);
          await pref.setString('user',responseBody['data']['name']);
        }
        return jsonDecode(response.body);
        default:
          print(response.body);
        return jsonDecode(response.body);
    }
  }
  Future getAddress()async{
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
    final response=await Http().get(Urls.userAddress,pref.get('user_token'),"");
    switch(response.statusCode)
    {
      case 200:
        final responseBody=jsonDecode(response.body);
        //userAddressModalFromJson(response.body);
        print(response.body);
        if(responseBody['status']==true)
          {
            //await pref.setBool("isAddress",true);
            if(responseBody['data'].length>0)
              {
                await pref.setString("addr_id",responseBody['data'][0]['id'].toString());
              }
            print("Address:${pref.get("addr_id")}");
          }
        return true;
      case 403:
        final response=await Http().get(Urls.userAddress,pref.get('user_token'),"");
        print(response.body);
        return jsonDecode(response.body);
      default:
        print(response.body);
        return false;
    }
  }
}