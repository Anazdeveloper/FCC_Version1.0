import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:first_class_canine_demo/Screens/HomePage/HomeBloc.dart';
import 'package:first_class_canine_demo/Screens/HomePage/HomePage.dart';
import 'package:first_class_canine_demo/Service/ConnectivityCheck.dart';
import 'package:first_class_canine_demo/UIComponents/UIComponents/TopSnackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'Repo/StaticDataRepo.dart';
import 'Screens/Intro/small_onboarding.dart';
import 'Storage/Pref/Shared.dart';

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  StreamSubscription? subscription;
  final Connectivity _connectivity = Connectivity();

  @override
  void initState() {
    super.initState();


   Timer(Duration(seconds: 3), () async {
      bool state = await ConnectivityCheck().getConnectionState();

      if (state == true) {
        await StaticDataRepo().getData();
        final pref = await Shared().getSharedStorage();
        print("dsdds .$context");
        if(mounted){
        if (pref.containsKey("isNew")) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  settings: RouteSettings(name: "/home"),
                  builder: (context) => BlocProvider(
                        create: (context) => HomeBloc(),
                        child: HomePage(),
                      )));
        } else {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => sOnBoardingPage()));
        }
      }}
    });

    subscription=  Connectivity().onConnectivityChanged.listen((event) async {
      if (event.index == 1 || event.index == 0) {
        await StaticDataRepo().getData();
        final pref = await Shared().getSharedStorage();

        if (pref.containsKey("isNew")) {

          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  settings: RouteSettings(name: "/home"),
                  builder: (context) => BlocProvider(
                    create: (context) => HomeBloc(),
                    child: HomePage(),
                  )));
        } else {

          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => sOnBoardingPage()));
        }
      } else {
        TopSnackBar.show();
      }
    });
  }


  @override
  Widget build(BuildContext context) {

    return Container(
      color: Colors.black,
      child: Image.asset('assets/images/logo.webp'),
    );
  }


  @override
  void dispose() {
    subscription!.cancel();
    super.dispose();
  }
}
