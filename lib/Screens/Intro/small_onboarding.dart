import 'package:first_class_canine_demo/Screens/HomePage/HomeBloc.dart';
import 'package:first_class_canine_demo/Screens/HomePage/HomePage.dart';
import 'package:first_class_canine_demo/Screens/Intro/small_pageone.dart';
import 'package:first_class_canine_demo/Screens/Intro/small_pagethree.dart';
import 'package:first_class_canine_demo/Screens/Intro/small_pagetwo.dart';
import 'package:first_class_canine_demo/Storage/Pref/Shared.dart';
import 'package:first_class_canine_demo/UIComponents/CanineButton.dart';
import 'package:first_class_canine_demo/UIComponents/CanineStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class sOnBoardingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return sOnBoardingState();
  }
}

class sOnBoardingState extends State<sOnBoardingPage> {
  final int pages = 3;
  int currentPage = 0;
  final PageController pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return LayoutBuilder(
      builder: (context, constraints) => Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage("assets/images/background.png"))),
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  physics: ClampingScrollPhysics(),
                  controller: pageController,
                  onPageChanged: (page) {
                    setState(() {
                      currentPage = page;
                    });
                  },
                  children: [sPageTwo(), sPageOne(), sPageThree()],
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: dotsArray(),
                ),
              ),
              currentPage == 2
                  ? Container(
                      margin: EdgeInsets.only(
                          bottom: constraints.maxHeight <= 600 ? 8.0 : 50.0,
                          top: constraints.maxHeight <= 600 ? 2.0 : 10.0),
                      child: CanineButton(
                        buttonHeight:
                            constraints.maxHeight <= 600 ? 45.0 : 50.0,
                        buttonWidth:
                            constraints.maxHeight <= 600 ? 150.0 : 200.0,
                        fontSize: 14,
                        text: "Explore",
                        color: CanineColors.transparentcolor,
                        callback: () async {
                          final pref = await Shared().getSharedStorage();
                          pref.setBool("isNew", false);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  settings: RouteSettings(name: "/home"),
                                  builder: (context) => BlocProvider(
                                      create: (context) => HomeBloc(),
                                      child: HomePage())));
                        },
                      ),
                    )
                  : Container(
                      height: constraints.maxHeight <= 600 ? 50.0 : 100.0,
                    )
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> dotsArray() {
    List<Widget> dots = [];
    for (int i = 0; i < pages; i++) {
      dots.add(i == currentPage ? indicatorDots(true) : indicatorDots(false));
    }
    return dots;
  }

  Widget indicatorDots(isActive) {
    return AnimatedContainer(
      margin: EdgeInsets.all(8),
      height: isActive ? 12 : 8,
      width: isActive ? 12 : 8,
      duration: Duration(microseconds: 100),
      decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: CanineColors.textColor)],
          color:
              isActive ? CanineColors.dotColorBottom : CanineColors.dotColorTop,
          borderRadius: BorderRadius.circular(50)),
    );
  }
}
