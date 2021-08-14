import 'package:first_class_canine_demo/Modal/MyEventCancelModal.dart';
import 'package:first_class_canine_demo/Modal/MyEventErrorModel.dart';
import 'package:first_class_canine_demo/Modal/MyEventModal.dart';
import 'package:first_class_canine_demo/Service/Api.dart';
import 'package:first_class_canine_demo/Service/Urls.dart';
import 'package:first_class_canine_demo/Storage/Pref/Shared.dart';

import 'ConfirmationRepo.dart';
import 'Repo.dart';

abstract  class Repo{
  Future getData();
}
class UserEventRepo{
  Future getEvent(String reference)async{
    final pref = await Shared().getSharedStorage();
    if (pref.containsKey("user_token")) {
      if (pref.get("user_token") == null) {
        await RefreshToken().getData();
      }
    } else {
      await RefreshToken().getData();
    }
    final response = await Http().get(Urls.bookingDetail+reference, pref.get('user_token'),ContentType.urlEncode);
    switch (response.statusCode) {
      case 200:
        print(response.body);
        return myEventModalFromJson(response.body);
      case 403:
        await RefreshToken().getData();
        await Http().get(Urls.bookingDetail+reference, pref.get('user_token'),ContentType.urlEncode);
        return myEventModalFromJson(response.body);
      default:
        return myEventErrorModalFromJson(response.body);
    }
  }
  Future cancelEvent(String reference)async{
    final pref = await Shared().getSharedStorage();
    if (pref.containsKey("user_token")) {
      if (pref.get("user_token") == null) {
        await RefreshToken().getData();
      }
    } else {
      await RefreshToken().getData();
    }
    final response = await Http().delete("",Urls.bookingDetail+reference,pref.get('user_token'),ContentType.urlEncode);
    switch (response.statusCode) {
      case 200:
        print("Cancel:${response.body}");
        return myEventCancelModalFromJson(response.body);
      case 403:
        await RefreshToken().getData();
        await Http().get(Urls.bookingDetail+reference, pref.get('user_token'),ContentType.urlEncode);
        return myEventCancelModalFromJson(response.body);
      default:
        print("Cancel:${response.body}");
        return myEventErrorModalFromJson(response.body);
    }
  }
}