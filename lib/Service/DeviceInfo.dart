import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';

class DeviceInfo{

  Future deviceID() async
  {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    try {
      if(Platform.isAndroid)
      {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        return androidInfo.androidId;
      }
      else if (Platform.isIOS) {
        IosDeviceInfo IosInfo = await deviceInfo.iosInfo;
        return IosInfo.identifierForVendor;
      } else if (Platform.isWindows) {
        WebBrowserInfo WebInfo = await deviceInfo.webBrowserInfo;
        return WebInfo.userAgent;
      }
    } on PlatformException {
      print('Failed to get platform version');
    }
  }
}