import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'CanineStyle.dart';

class CanineTextUnderLined extends StatelessWidget{
  final String ? label,message;
  final TextInputAction ? inputAction;
  final TextInputType ? inputType;
  final String ? tag;
  final CaninePasswordType ? type;
  final TextEditingController ? controller,new_password_controller;
  final bool ? showCursor,isReadOnly,eyeButton,canEdit,showEyeButton,isBackendMessage;
  final Function() ? callback;

  CanineTextUnderLined({this.label,this.inputAction,this.inputType,this.tag,this.controller,this.isReadOnly=false,this.showCursor,this.eyeButton=false,this.type,this.callback,this.canEdit=true,this.new_password_controller,this.showEyeButton=true,this.isBackendMessage=false,this.message});
  @override
  Widget build(BuildContext context) {
    return  TextFormField(
      enableInteractiveSelection:canEdit!,
      obscureText: eyeButton!,
      showCursor: showCursor,
      readOnly: isReadOnly!,
      controller: controller,
      textInputAction: inputAction,
      cursorColor: Colors.white,
      maxLines: 1,
      textAlignVertical: TextAlignVertical.bottom,
      decoration:InputDecoration(
        errorMaxLines:2,
          contentPadding: EdgeInsets.symmetric(vertical: 2.0),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          enabledBorder:UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
                width: 1.0,
              )
          ) ,
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.grey,
                  width: 1.0
              )
          ),
          border:UnderlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.white,
                  width: 1.0
              )
          ),
          labelStyle: TextStyle(
              fontFamily: CanineFonts.Aleo,
              color: Colors.white,
              fontSize: 20.0
          ),
          labelText:label!,
        suffixIcon: showEyeButton==true?GestureDetector(
            onTap: callback,
            child: Icon(
                eyeButton!
                    ? Icons.visibility_off
                    : Icons.visibility,
                color: Colors.white)):null,
        errorText: isBackendMessage==true?message:null,
      ),
      style: TextStyle(
        fontFamily: CanineFonts.Aleo,
        color: Colors.white,
        fontSize: 20.0
      ),
      validator: (value){
        var pattern=r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,16}$';
        switch(tag)
          {
            case "otp":
              if(value!.isEmpty)
                {
                  return "Please enter an otp";
                }
              return null;
            case "password":
              if(value!.isEmpty)
                {
                  switch(type!)
                  {
                    case CaninePasswordType.OldPassword:
                      return "Please enter current password";
                    case CaninePasswordType.NewPassword:
                      return "Please enter new password";
                    case CaninePasswordType.ConfirmPassword:
                      if(RegExp(pattern).hasMatch(new_password_controller!.text))
                      {
                        return "Password mismatch";
                      }
                      else{
                        return "Please confirm new password";
                      }
                  }
                }
             /* if (!RegExp(pattern).hasMatch(value))
              {
                switch(type!)
                {
                  case CaninePasswordType.OldPassword:
                    return "Please enter a valid password";
                  case CaninePasswordType.NewPassword:
                    return "Password should have 8-16 characters, with atleast 1 uppercase, lowercase, number and symbol";
                  case CaninePasswordType.ConfirmPassword:
                    if(RegExp(pattern).hasMatch(new_password_controller!.text))
                    {
                      return "Password mismatch";
                    }
                    else{
                      return "Please confirm new password";
                    }                }}
              else{
                if(type!.index==CaninePasswordType.ConfirmPassword.index)
                  {
                    print("New${new_password_controller!.text}");
                    print(value);
                    if(new_password_controller!.text!=value)
                      {
                        if(RegExp(pattern).hasMatch(new_password_controller!.text))
                          {
                            return "Password mismatch";
                          }
                        else{
                          return "Please confirm new password";
                        }
                      }
                  }
              }*/
                break;
            case "email":
              if(value!.isEmpty)
              {
                return "Please enter email address";
              }
              var pattern=r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
              if (!RegExp(pattern).hasMatch(value))
              {
                return "Please enter a valid email address";
              }
              return null;
          }
          return null;
      },
    );
  }
}
enum CaninePasswordType{
  OldPassword,
  NewPassword,
  ConfirmPassword
}