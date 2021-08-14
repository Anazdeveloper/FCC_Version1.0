import 'dart:convert';

import 'package:first_class_canine_demo/Service/Api.dart';
import 'package:first_class_canine_demo/Service/Urls.dart';
import 'package:first_class_canine_demo/Storage/Pref/Shared.dart';

import 'Repo.dart';

abstract class Repo {
  Future getData();
}

class EditProfileRepo extends Repo {
  final inputData;

  EditProfileRepo(this.inputData);

  @override
  Future getData() async {
    final pref = await Shared().getSharedStorage();
    if (!pref.containsKey("app_token") && pref.get("app_token") == null) {
      print("no token");
      await AppToken().getData();
      await RefreshToken().getData();
    }
    final token = pref.get("user_token");
    final response = await Http().put(Urls.editprofile, token, inputData);
    print('Edit profile response:${response.body}');
    switch (response.statusCode) {
      case 200:
        final responseBody = jsonDecode(response.body);
        print('username: ${responseBody['data']['user']}');
        return responseBody;
      case 400:
        return jsonDecode(response.body);
      case 403:
        return jsonDecode(response.body);
      default:
        return jsonDecode(response.body);
    }
  }
}
