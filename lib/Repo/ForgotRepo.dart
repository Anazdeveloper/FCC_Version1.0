import 'dart:convert';

import 'package:first_class_canine_demo/Service/Api.dart';
import 'package:first_class_canine_demo/Service/Urls.dart';
import 'package:first_class_canine_demo/Storage/Pref/Shared.dart';

import 'Repo.dart';

class ForgotRepo{
  Future getOtp(String ? inputEmail,) async
  {
    final pref = await Shared().getSharedStorage();
    final response = await Http().post(
    {"email":inputEmail},
        Urls.forgetPassword,
        pref.get('app_token'),
        ContentType.urlEncode);
    switch (response.statusCode) {
      case 200:
        final responseBody = jsonDecode(response.body);
        print(responseBody);
        return responseBody;

      case 401:
        final responseBody = jsonDecode(response.body);
        print(responseBody);
        return responseBody;
      case 403:
        await AppToken().getData();
        final response = await Http().post(
            {"email":inputEmail},
            Urls.forgetPassword,
            pref.get('app_token'),
            ContentType.urlEncode);
        final responseBody = jsonDecode(response.body);
        return responseBody;
      default:
        final responseBody = jsonDecode(response.body);
        print(responseBody);
        return responseBody;
    }
  }
  Future verifyOtp(String inputEmail,String otp,String npassword,String cpassword) async{
    final pref = await Shared().getSharedStorage();
    final response = await Http().update({
      "email":inputEmail,
      "otp": otp,
      "password": npassword,
      "confirm_password":cpassword
    },Urls.resetPassword,pref.getString("app_token"),ContentType.urlEncode);
    switch (response.statusCode) {
      case 200:
        final responseBody = jsonDecode(response.body);
        print(responseBody);
        return responseBody;
      case 403:
        await AppToken().getData();
        final response = await Http().update({
          "email":inputEmail,
          "otp":otp,
          "password":npassword,
          "confirm_password":cpassword
        },Urls.resetPassword,pref.getString("app_token"),ContentType.urlEncode);
        final responseBody = jsonDecode(response.body);
        print(responseBody);
        break;
      default:
        final responseBody = jsonDecode(response.body);
        print(responseBody);
        return responseBody;
    }
  }

}