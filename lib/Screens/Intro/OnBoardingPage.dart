import 'package:first_class_canine_demo/Screens/HomePage/HomeBloc.dart';
import 'package:first_class_canine_demo/Screens/HomePage/HomePage.dart';
import 'package:first_class_canine_demo/Screens/Intro/PageOne.dart';
import 'package:first_class_canine_demo/Screens/Intro/PageThree.dart';
import 'package:first_class_canine_demo/Storage/Pref/Shared.dart';
import 'package:first_class_canine_demo/UIComponents/CanineButton.dart';
import 'package:first_class_canine_demo/UIComponents/CanineStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'PageTwo.dart';

class OnBoardingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return OnBoardingState();
  }
}

class OnBoardingState  extends State<OnBoardingPage>{
  final int pages=3;
  int currentPage=0;
  final PageController pageController=PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;
    print(width/height);
    print(20*(width/height));
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage("assets/images/background.png")
          )
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Flexible(
              flex: 15,
              fit: FlexFit.loose,
              child: PageView(
                physics: ClampingScrollPhysics(),
              controller: pageController,
              onPageChanged: (page){
                  setState(() {
                    currentPage=page;
                  });
              },
              children: [
                PageTwo(),
                PageOne(),
                PageThree(),
              ],
          ),
            ),
           Flexible(
             flex: 2,
             child: Container(
               margin: EdgeInsets.only(bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: dotsArray(),
                ),
              ),
           ),
            currentPage==2?Flexible(
              fit: FlexFit.loose,
              flex: 2,
              child: Container(
                margin: EdgeInsets.only(bottom: 5),
                child: CanineButton(
                  fontSize:14,
                  text: "Explore",
                  color: CanineColors.transparentcolor,
                  callback: () async{
                    final pref=await Shared().getSharedStorage();
                    pref.setBool("isNew",false);
                    Navigator.pushReplacement(context,MaterialPageRoute(
                      builder: (context) => BlocProvider(create: (context) => HomeBloc(), child: HomePage(),))
                    );
                  },
                ),
              ),
            ):Flexible(flex: 1,child: Container(height: 80.0,))
          ],
        ),
      ),
    );
  }
  List<Widget> dotsArray()
  {
    List<Widget> dots=[];
    for(int i=0;i<pages;i++)
      {
        dots.add(i==currentPage?indicatorDots(true):indicatorDots(false));
      }
    return dots;
  }
  Widget indicatorDots(isActive)
  {
    return  AnimatedContainer(
      margin: EdgeInsets.all(8),
      height: isActive?12:8,
        width: isActive?12:8,
        duration: Duration(microseconds:100),
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(
            color: CanineColors.textColor
        )
      ],
      color:isActive?CanineColors.dotColorBottom:CanineColors.dotColorTop,
      borderRadius: BorderRadius.circular(50)
    ),);
  }
}
