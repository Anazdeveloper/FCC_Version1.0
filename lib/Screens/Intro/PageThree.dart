import 'package:first_class_canine_demo/UIComponents/CanineStyle.dart';
import 'package:first_class_canine_demo/UIComponents/CanineText.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PageThree extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      child:Column(
        children: [
          Container(
            child: ClipRRect(
              borderRadius: BorderRadius.only(bottomLeft:Radius.circular(20),bottomRight: Radius.circular(180.0)),
                child: Image.asset("assets/images/OnBoardingImages/pic_3.webp",fit: BoxFit.fitWidth,width: MediaQuery.of(context).size.width,height:MediaQuery.of(context).size.height/2,)),
          ),
          Flexible(
            flex: 2,
            child: Container(
              margin: EdgeInsets.only(top: 5),
              child: Image.asset("assets/images/logo.webp",height:80,),
            ),
          ),
          Flexible(
            flex:3,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 1.0),
              child: CanineText(
                color: CanineColors.textColor,
                text: "We’re Just Getting \n Started ",
                maxLines: 2,
                textAlign: TextAlign.center,
                fontSize: 25.0,
                fontFamily: CanineFonts.Rye,
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 5.0),
              child: CanineText(
                color: CanineColors.textColor,
                text: "Follow us and Stay Tuned for \n lot more to come",
                maxLines: 2,
                textAlign: TextAlign.center,
                fontSize: 14.0,
                fontFamily: CanineFonts.Aleo,
              ),
            ),
          ),
        ],
      )
    );
  }

}