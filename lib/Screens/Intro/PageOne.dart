import 'package:first_class_canine_demo/UIComponents/CanineStyle.dart';
import 'package:first_class_canine_demo/UIComponents/CanineText.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PageOne extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      child:Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            child: ClipRRect(
              borderRadius: BorderRadius.only(bottomLeft:Radius.circular(20),bottomRight: Radius.circular(20)),
                child: Image.asset("assets/images/OnBoardingImages/pic_1.webp",fit: BoxFit.fitWidth,width: MediaQuery.of(context).size.width,height: MediaQuery.of(context).size.height/2)),
          ),
          Expanded(
            flex: 1,
            child: Container(
              margin: EdgeInsets.only(top: 5),
              child: Image.asset("assets/images/logo.webp",height:80,),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 8.0),
            child: CanineText(
              color: CanineColors.textColor,
              text: "One Stop Solution",
              fontSize: 25.0,
              fontFamily: CanineFonts.Rye,
            ),
          ),
          Flexible(
            flex: 2,
            child: Container(
              padding: EdgeInsets.all(10.0),
              margin: EdgeInsets.symmetric(vertical: 5.0),
              child: CanineText(
                color: CanineColors.textColor,
                text: "Get the most popular products and \n Services from Progesteron testing to \n Registering your Dog for the Show",
                maxLines: 3,
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