import 'dart:convert';

import 'package:first_class_canine_demo/Repo/Repo.dart';
import 'package:first_class_canine_demo/Service/Api.dart';
import 'package:first_class_canine_demo/Service/Urls.dart';
import 'package:first_class_canine_demo/Storage/Pref/Shared.dart';

class ContactUsRepo extends Repo {
  final inputData;

  ContactUsRepo(this.inputData);

  @override
  Future postData() async {
    final pref = await Shared().getSharedStorage();
    if (!pref.containsKey("app_token") && pref.get("app_token") == null) {
      print("no token");
      await AppToken().getData();
    }
    print('User Token contact:${pref.get('app_token')}');
    final response = await Http().post(inputData, Urls.contactusSubmit,
        pref.get('app_token'), ContentType.urlEncode);
    print('ContactUsResponse: ${response.statusCode}');
    switch (response.statusCode) {
      case 200:
        return jsonDecode(response.body);
      case 400:
        return jsonDecode(response.body);
      case 403:
        return jsonDecode(response.body);
      case 422:
        return jsonDecode(response.body);
      default:
        return jsonDecode(response.body);
    }
  }

  @override
  Future getData() {
    // TODO: implement getData
    throw UnimplementedError();
  }
}
