import 'package:first_class_canine_demo/UIComponents/BottomNavigation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // A dummy page for showing the register success
    return Scaffold(
        body: Container(
          alignment: Alignment.center,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

              ]),
        ),
        bottomNavigationBar: BottomNavigation());
  }
}
