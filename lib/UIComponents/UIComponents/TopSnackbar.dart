import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

import '../CanineText.dart';

class TopSnackBar {
  static show()
  {
    showSimpleNotification(CanineText(
      text: "No network, please check your internet connection!",
      maxLines: 2,
    ),background: Colors.red);
  }
}