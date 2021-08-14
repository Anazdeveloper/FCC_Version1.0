import 'package:shared_preferences/shared_preferences.dart';

class Shared{
  Future<SharedPreferences> getSharedStorage() async
  {
    SharedPreferences shared=await SharedPreferences.getInstance();
    return shared;
  }
}