import 'dart:convert';

import 'package:first_class_canine_demo/Service/Api.dart';
import 'package:first_class_canine_demo/Service/Urls.dart';
import 'package:first_class_canine_demo/Storage/Pref/Shared.dart';

import 'Repo.dart';

abstract class Repo {
  Future getData();
}

class EditBillingRepo extends Repo {
  final inputData;

  EditBillingRepo(this.inputData);

  @override
  Future getData() async {
    final pref = await Shared().getSharedStorage();
    if (!pref.containsKey("app_token") && pref.get("app_token") == null) {
      print("no token");
      await AppToken().getData();
      await RefreshToken().getData();
    } else {
      await RefreshToken().getData();
    }
    final token = pref.get("user_token");
    final responseBody;
    if (!pref.containsKey("addr_id") && pref.get("addr_id") == null) {
      print('Address creation');
      final response = await Http().post(
          inputData, Urls.useraddressCreate, token, ContentType.urlEncode);
      print('Address Response: ${response}');
      print('ResponseBody: ');

      //final createBody = await CreateAddressSuccess.fromJson(response.body);
      final createBody = await jsonDecode(response.body);
      if (createBody['status'] == true) {
        print("Response True");
        final addrId = await createBody['data']['id'].toString();
        await pref.setString("addr_id", addrId);
      }
      responseBody = createBody;
      print("AddressId: ${pref.get('addr_id')}");
    } else {
      print('Address updation');
      final id = pref.get('addr_id');
      final response = await Http().put(Urls.useraddressCreate + id.toString(),
          pref.get('user_token'), inputData);
      final updateBody = jsonDecode(response.body);
      print('Updation response: ${updateBody}');
      print("Message: ${updateBody['status']}");
      responseBody = updateBody;
    }
    return responseBody;
  }
}
