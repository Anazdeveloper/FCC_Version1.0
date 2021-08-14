import 'package:first_class_canine_demo/UIComponents/CanineStyle.dart';
import 'package:flutter/material.dart';

import 'CanineStyle.dart';

class CanineButtonDailog extends StatelessWidget {
  final String? text;
  final double? borderRadius;
  final Color? color;
  final double? fontSize;
  final double? buttonWidth, buttonHeight;
  final void Function()? callback;
  final bool? textWidget;
  final Color? borderColor, textColor;

  CanineButtonDailog(
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
    return Container(
          width: buttonWidth,
          height: buttonHeight,
          child: OutlinedButton(
            style: ButtonStyle(
                visualDensity: VisualDensity.adaptivePlatformDensity,
                elevation: MaterialStateProperty.all(1.0),
                backgroundColor: MaterialStateProperty.all(color),

                shape: MaterialStateProperty.all<OutlinedBorder>(StadiumBorder()),
      side: MaterialStateProperty.resolveWith<BorderSide>(
              (Set<MaterialState> states) {
            final Color color = borderColor!;
            return BorderSide(color: color, width: 1);
          }
      ),


            ),
            child: Padding(
                padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                child:new Material(
                    child:InkWell(child:  textWidget!
                    ? Text(
                  text!,
                  style: TextStyle(fontSize: fontSize, color: textColor),
                )
                    : Icon(
                  Icons.done_all,
                  color: Colors.green,
                ) ,))),
            onPressed: callback,
          ),
        ) ;
  }
}
