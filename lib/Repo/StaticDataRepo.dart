import 'dart:convert';

import 'package:first_class_canine_demo/Modal/StaticDataModal.dart';
import 'package:first_class_canine_demo/Service/Api.dart';
import 'package:first_class_canine_demo/Service/Urls.dart';
import 'package:first_class_canine_demo/Storage/Pref/Shared.dart';

import 'ConfirmationRepo.dart';

class StaticDataRepo extends Repo {
  @override
  Future getData() async{
    final response = await Http().get(Urls.staticContents, '', '');
    final body = StaticDataModal.fromJson(jsonDecode(response.body));
    final pref = await Shared().getSharedStorage();
    pref.setString('about_description', body.data!.aboutUs!.description!);
    pref.setString('contactus_description', body.data!.contactUs!.description!);
    pref.setString('privacypolicy_description', body.data!.privacyPolicy!.description!);
    pref.setString('terms_description', body.data!.terms!.description!);
    pref.setString('cancellation_note_title', body.data!.cancelationNote!.title!);
    pref.setString('cancellation_note_description', body.data!.cancelationNote!.description!);
    print('Static Response: ${response.statusCode}');
    // switch(response.statusCode) {
    //   case 200:
    //     return StaticDataModal.fromJson(jsonDecode(response.body));
    //   case 400:
    //     return jsonModalFromJson(response.body);
    //   case 403:
    //     return jsonModalFromJson(response.body);
    //   default:
    //     return jsonModalFromJson(response.body);
    // }
  }
}