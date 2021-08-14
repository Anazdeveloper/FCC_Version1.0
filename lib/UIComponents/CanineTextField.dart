import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CanineTextField extends StatelessWidget{
  final String ? prefix,tag;
  final TextEditingController ? controller;
  final TextInputAction ? inputAction;
  final TextInputType ? textInputType;
  final bool ? readOnly,isVerify,isBackendMessage;
  final String ? message;
  List<TextInputFormatter>? inputFormatter;



  CanineTextField({this.prefix,this.tag,this.controller,this.inputAction,this.textInputType,this.readOnly=false,this.isVerify=true,this.message="",this.isBackendMessage=false,this.inputFormatter});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly:readOnly!,
      keyboardType: textInputType,
      textInputAction: inputAction,
      inputFormatters: inputFormatter,
      controller: controller,
      style: TextStyle(
          color: Colors.white
      ),
      validator: (value){
          switch (tag)
          {
            case "kennel":
              var pattern=r'^[a-zA-Z0-9\s]+$';
              if(value!.trim().isEmpty)
              {
                return "Please enter kennel name";
              }
              else if(value.length>20){
                return "Maximum 20 characters allowed";
              }
              else if (!RegExp(pattern).hasMatch(value))
              {
                return "This field should contain alphabets and numbers only";
              }
              return null;
            case "other":
              return null;
            case "email":
              if(value!.isEmpty)
                {
                  return "Please enter email address";
                }
              var pattern=r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
              if (!RegExp(pattern).hasMatch(value) && isVerify==true)
              {
                return "Please enter a valid email address";
              }
              return null;
            case "phone" :
              if(value!.isEmpty)
              {
                return "Please enter mobile no";
              }
              else if (value.length >=7 && value.length <=14)
              {
                return null;
              }
              return "Please enter a valid mobile no";
              case "name":
                if(value!.isEmpty)
                {
                  return "Please enter fullname";
                }
              /*else if (value.length < 3 || value.length > 25)
              {
                return "Please enter a valid fullname";
              }
                var pattern=r'^[a-zA-Z\s]+$';
                if (!RegExp(pattern).hasMatch(value))
                {
                  return "Please enter a valid fullname";
                }*/
                return null;
            case "message":
              if(value!.isEmpty)
              {
                return "Please enter a message";
              }
              return null;
          }
      },
      decoration:InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(0.0,0.0,4.0,0.0),
        errorMaxLines:2,
        prefixIconConstraints: BoxConstraints(
          maxWidth: 120,
          maxHeight: 20,
          minWidth: 100
        ),
          prefixIcon:Padding(
            padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
          child: Text(prefix!,style: TextStyle(
            fontFamily: 'Aleo',
            color: Colors.white))),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                  color: Colors.white
              )
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                  color: Colors.white
              )
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
              borderSide:BorderSide(
                color: Colors.white,
              )
          ),
        errorText: isBackendMessage==true?message:null,
      ),
    );
  }
}
