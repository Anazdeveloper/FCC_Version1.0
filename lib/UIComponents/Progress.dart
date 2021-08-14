import 'package:first_class_canine_demo/UIComponents/CanineStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Progress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        accentColor: CanineColors.Primary,
      ),
      child: Center(
        child: Container(
            margin: EdgeInsets.symmetric(vertical: 10.0),
            child: CircularProgressIndicator(
            )),
      ),
    );
  }
}
