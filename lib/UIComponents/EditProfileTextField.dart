import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'CanineStyle.dart';

class EditProfileTextField extends StatelessWidget {
  final String ? hint,tag;
  final TextEditingController ? controller;
  final bool ? isBackendMessage;
  final String ? message;

  EditProfileTextField({this.tag,this.hint,this.controller,this.isBackendMessage,this.message});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: true,
      cursorColor: Colors.white,
      controller: controller,
      obscureText: false,
      style: TextStyle(color: CanineColors.textColorSecondary),
      validator: (value) {
        switch(tag) {
          case 'street':
            if (value == null ||
                value.isEmpty ||
                value.trim().isEmpty) {
              return 'Street address is required';
            }
            // else if (value.length < 2 || value.length > 50 ) {
            //   return 'Street name can have 2-50 characters';
            // }
            return null;
          case 'address':
            if (value == null ||
                value.isEmpty ||
                value.trim().isEmpty) {
              return 'Address is required';
            }
            // else if (value.length <2 || value.length > 50 ) {
            //   return 'Address can have 2-50 characters';
            // }
            return null;
          case 'city':
            var pattern = r'^[a-zA-Z\s]+$';
            if (value == null ||
                value.isEmpty ||
                value.trim().isEmpty) {
              return 'City is required';
            }
            // else if (value.length < 2 || value.length > 50 ) {
            //   return 'City name can have 2-50 characters';
            // }
            else if (!RegExp(pattern).hasMatch(value)) {
              return 'City name accepts only alphabets';
            }
            return null;
          case 'state':
            var pattern = r'^[a-zA-Z\s]+$';
            if (value == null ||
                value.isEmpty ||
                value.trim().isEmpty) {
              return 'State is required';
            }
            // else if (value.length < 2 || value.length >50 ) {
            //   return 'State name can have 2-50 characters';
            // }
            else if (!RegExp(pattern).hasMatch(value)) {
              return 'State name accepts only alphabets';
            }
            return null;
          case 'zip':
            if (value!.isEmpty || value.trim().isEmpty) {
              return 'Zipcode is required';
            }
            // else if (value.length > 5 || value.length < 5) {
            //   return 'Zip code must be 5 digits';
            // }
            return null;
        }
      },
      decoration: InputDecoration(
        hintText: hint!,
          errorMaxLines:2,
        hintStyle:
        TextStyle(color: CanineColors.textColorSecondary),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey)),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey)),
        errorText: isBackendMessage == true ? message : null
      ),
      // validator: (value) {
      //   if (value == null ||
      //       value.isEmpty ||
      //       street.text.trim().isEmpty) {
      //     return 'Street address is required';
      //   }
      //   // else if (value.length < 2 || value.length > 50 ) {
      //   //   return 'Street name can have 2-50 characters';
      //   // }
      //   return null;
      // },
    );
  }
}
