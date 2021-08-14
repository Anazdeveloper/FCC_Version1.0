import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CaninePasswordField extends StatelessWidget{
  final TextEditingController ? controller;
  final bool ? eyeButton,isVerify ;
  final void Function() ? callback;
  final String ? message;
  final bool ? isBackendMessage;
  final bool? validatorMessage;
  CaninePasswordField({this.eyeButton,this.controller,this.callback,this.isVerify=true,this.message,this.isBackendMessage=false,this.validatorMessage=false});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textInputAction: TextInputAction.done,
      controller: controller,
      style: TextStyle(color: Colors.white),
      obscureText: eyeButton!,
      validator: (value) {
        if (value == null || value.isEmpty) {
          if (validatorMessage!) {
            return "Please enter password";
          } else {
            return null;
          }
          return null;
        } else {
          var pattern=r'^(?!.* )(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,16}$';
          if (!RegExp(pattern).hasMatch(value) && isVerify==true)
          {
            return "Password should have 8-16 characters, with atleast 1 uppercase, lowercase, number and symbol";
          }
          return null;
        }
      },
      decoration: InputDecoration(
        errorMaxLines: 2,
        contentPadding: EdgeInsets.all(0),
          prefixIconConstraints: BoxConstraints(
              maxWidth: 100, maxHeight: 20, minWidth: 100),
          suffixStyle: TextStyle(color: Colors.white),
          suffixIcon: GestureDetector(
              onTap: callback,
              child: Icon(
                  eyeButton!
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: Colors.white)),
          prefixIcon: Padding(
              padding: EdgeInsets.fromLTRB(15.0, 0, 0, 0),
              child: Text("Password -",
                  style: TextStyle(color: Colors.white))),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.white)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.white)),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.white,
              )
          ),
        errorText: isBackendMessage==true?message:null,
      ),
    );
  }

}