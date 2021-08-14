import 'package:first_class_canine_demo/UIComponents/CanineText.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CanineSnackBar{
  static show(BuildContext context,String message){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: CanineText(text: message,maxLines: 5,)));
  }
}