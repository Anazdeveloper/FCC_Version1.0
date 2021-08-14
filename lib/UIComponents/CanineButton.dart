import 'package:first_class_canine_demo/UIComponents/CanineStyle.dart';
import 'package:flutter/material.dart';

import 'CanineStyle.dart';

class CanineButton extends StatelessWidget {
  final String? text;
  final double? borderRadius;
  final Color? color;
  final double? fontSize;
  final double? buttonWidth, buttonHeight;
  final void Function()? callback;
  final bool? textWidget;
  final Color? borderColor, textColor;

  CanineButton(
      {this.text,
      this.borderRadius,
      this.callback,
      this.color,
      this.fontSize = 14,
      this.buttonHeight,
      this.buttonWidth,
      this.textWidget = true,
      this.borderColor = CanineColors.Primary,
      this.textColor = CanineColors.Primary});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
          width: buttonWidth,
          height: buttonHeight,
          child: ElevatedButton(
            style: ButtonStyle(
                visualDensity: VisualDensity.adaptivePlatformDensity,
                elevation: MaterialStateProperty.all(0.0),
                backgroundColor: MaterialStateProperty.all(color),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                    side: BorderSide(color: borderColor!, width: 1)))),
            child: Padding(
                padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                child: textWidget!
                    ? Text(
                        text!,
                        style: TextStyle(fontSize: fontSize, color: textColor),
                      )
                    : Icon(
                        Icons.done_all,
                        color: Colors.green,
                      )),
            onPressed: callback,
          ),
        ) ;
  }
}
