import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CanineTextFieldOTP extends StatelessWidget{
  final String ? prefix,tag;
  final TextEditingController ? controller;
  final TextInputAction ? inputAction;
  final TextInputType ? textInputType;
  final bool ? readOnly;
  final Color ? textColor;
  final Color? borderColor;

  CanineTextFieldOTP({this.prefix,this.tag,this.controller,this.inputAction,this.textInputType,this.readOnly=false,this.textColor,this.borderColor});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly:readOnly!,
      keyboardType: textInputType,
      textInputAction: inputAction,
      controller: controller,
      style: TextStyle(
          color: textColor
      ),
      validator: (value){
          switch (tag)
          {
            case "other":
              return null;
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
            case "phone" :
              if(value!.isEmpty)
              {
                return "Please enter mobile no";
              }
              if (value.length >7 && value.length <14)
              {
                return null;
              }
              return "Please enter a valid mobile no";
              case "name":
                if(value!.isEmpty)
                {
                  return "Please enter full name";
                }
              if (value.length < 3 || value.length > 25)
              {
                return "Please enter  a valid full name";
              }
                var pattern=r'^[a-zA-Z\s]+$';
                if (!RegExp(pattern).hasMatch(value))
                {
                  return "Please enter  a valid full name";
                }
        return null;
          }
      },
      decoration:InputDecoration(
        contentPadding: EdgeInsets.all(0.0),
          errorMaxLines:2,
        prefixIconConstraints: BoxConstraints(
          maxWidth: 80,
          maxHeight: 20,
          minWidth: 80
        ),
          prefixIcon:Padding(
            padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
          child: Text(prefix!,style: TextStyle(
            fontFamily: 'Aleo',
            color: borderColor!))),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                  color: borderColor!
              )
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                  color: borderColor!
              )
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
              borderSide:BorderSide(
                color: Colors.red,
              )
          )
      ),
    );
  }
}
