import 'package:flutter/cupertino.dart';

class CanineText extends StatelessWidget{
  final String? text;
  final int ? maxLines;
  final Color? color;
  final double? fontSize;
  final String? fontFamily;
  final TextDecoration ? decoration;
  final TextAlign ? textAlign;

  CanineText({Key? key, this.text, this.color, this.fontSize, this.fontFamily,this.decoration,this.maxLines =1,this.textAlign});

  @override
  Widget build(BuildContext context) {
    return Text(text!,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontFamily: fontFamily,
          decoration: decoration,
        ),
        textAlign: textAlign,
        maxLines: maxLines,
      overflow:TextOverflow.ellipsis,
    );
  }
}
