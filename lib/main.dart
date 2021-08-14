import 'package:first_class_canine_demo/Screens/ProfilePage/ProfilePage.dart';
import 'package:first_class_canine_demo/Screens/ProfilePage/ProfilePageBloc.dart';
import 'package:first_class_canine_demo/UIComponents/CanineStyle.dart';
import 'package:first_class_canine_demo/Screens/Register/RegisterBLOC.dart';
import 'package:first_class_canine_demo/UIComponents/CanineStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overlay_support/overlay_support.dart';

import 'SplashScreen.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]);
    return OverlaySupport.global(
      child: MaterialApp(
        routes:{
          "/profile":(context)=>BlocProvider(create: (context) => ProfileBloc(),child: ProfilePage(),),
        },
        theme:ThemeData(fontFamily:CanineFonts.Aleo,visualDensity:VisualDensity.adaptivePlatformDensity,checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateProperty.all(CanineColors.Primary)
        )),
        home: BlocProvider(
          create: (context) => RegisterBLOC(),
        child:SplashScreen()),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}