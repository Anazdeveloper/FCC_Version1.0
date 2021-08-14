import 'dart:convert';

import 'package:first_class_canine_demo/Modal/FaqModal.dart';
import 'package:first_class_canine_demo/Modal/JsonModal.dart';
import 'package:first_class_canine_demo/Repo/ConfirmationRepo.dart';
import 'package:first_class_canine_demo/Service/Api.dart';
import 'package:first_class_canine_demo/Service/Urls.dart';

class FaqRepo extends Repo {
  @override
  Future getData() async{
    final response = await Http().get(Urls.faqs, '', '');
    switch(response.statusCode) {
      case 200:
        return FaqModal.fromJson(jsonDecode(response.body));
      case 400:
        return jsonModalFromJson(response.body);
      case 403:
        return jsonModalFromJson(response.body);
      default:
        return jsonModalFromJson(response.body);
    }
  }

}