import 'dart:async';
import 'dart:io';

import 'package:first_class_canine_demo/Screens/Bottomsheet/AboutUs.dart';
import 'package:first_class_canine_demo/Screens/Bottomsheet/ContactUs/ContactUs.dart';
import 'package:first_class_canine_demo/Screens/Bottomsheet/ContactUs/ContactUsBloc.dart';
import 'package:first_class_canine_demo/Screens/Bottomsheet/Faqs/FAQ.dart';
import 'package:first_class_canine_demo/Screens/Bottomsheet/Faqs/FaqBloc.dart';
import 'package:first_class_canine_demo/Screens/Bottomsheet/PrivacyPolicy.dart';
import 'package:first_class_canine_demo/Screens/Bottomsheet/TermsAndCoditions.dart';
import 'package:first_class_canine_demo/Service/ConnectivityCheck.dart';
import 'package:first_class_canine_demo/UIComponents/CanineText.dart';
import 'package:first_class_canine_demo/UIComponents/UIComponents/TopSnackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

class CanineBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.transparent, backgroundBlendMode: BlendMode.colorDodge),
      height: MediaQuery.of(context).size.height,
      alignment: Alignment.bottomCenter,
      child: Container(
        alignment: Alignment.bottomCenter,
        height: MediaQuery.of(context).size.height / 2,
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          children: [
            Material(
              color: Colors.white,
              child: InkWell(
                onTap:() {
                  if(ModalRoute.of(context)!.settings.name !="/about")
                  Navigator.push(context,
                      MaterialPageRoute(settings: RouteSettings(name: "/about"),builder: (context) => AboutUs()));
                } ,
                splashColor: Colors.blue,
                child: ListTile(
                  title: CanineText(
                    text: "About Us",
                  ),
                ),
              ),
            ),
            Divider(
              color: Colors.black,
              thickness: 1.0,
            ),
            Material(
              color: Colors.white,
              child: InkWell(
                splashColor: Colors.blue,
                onTap: (){
                  if(ModalRoute.of(context)!.settings.name !="/contact")
                    Navigator.push(
                    context,
                    MaterialPageRoute(settings: RouteSettings(name: "/contact"),
                        builder: (context) => BlocProvider(
                          create: (context) => ContactUsBloc(),
                          child: ContactUs(),
                        )));
              },
                child: ListTile(
                  title: CanineText(
                    text: "Contact Us",
                  ),
                ),
              ),
            ),
            Divider(
              color: Colors.black,
              thickness: 1.0,
            ),
            Material(
              color: Colors.white,
              child: InkWell(
                splashColor: Colors.blue,
                onTap: (){
                  if(ModalRoute.of(context)!.settings.name !="/faq")
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          settings: RouteSettings(name: "/faq"),
                          builder: (context) => BlocProvider(
                            create: (context) => FaqBloc(),
                            child: FAQ(),
                          )));
                },
                child: ListTile(
                  title: CanineText(
                    text: "FAQ",
                  ),
                ),
              ),
            ),
            Divider(color: Colors.black, thickness: 1.0),
            Material(
              color: Colors.white,
              child: InkWell(
                splashColor: Colors.blue,
                onTap: (){
                  if(ModalRoute.of(context)!.settings.name !="/policy")
                    Navigator.push(context,
                      MaterialPageRoute(settings: RouteSettings(name: "/policy"),builder: (context) => PrivacyPolicy()));
                },
                child: ListTile(
                  title: CanineText(
                    text: "Privacy Policy",
                  ),
                ),
              ),
            ),
            Divider(color: Colors.black, thickness: 1.0),
            Material(
              color: Colors.white,
              child: InkWell(
                splashColor: Colors.blue,
                onTap: (){
                  if(ModalRoute.of(context)!.settings.name !="/terms")
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          settings: RouteSettings(name: "/terms"),
                          builder: (context) => TermsAndConditions()));
                },
                child: ListTile(
                  title: CanineText(
                    text: "Terms & Conditions",
                  ),
                ),
              ),
            ),
            Divider(color: Colors.black, thickness: 1.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Material(
                  color: Colors.white,
                  child: IconButton(
                    splashColor: Colors.blue,
                    splashRadius: 25.0,
                    onPressed: () async {

                      String fbUrl;
                      String webUrl =
                          'https://www.facebook.com/firstclasscanineservices/';
                      try {
                        if (Platform.isAndroid) {
                          fbUrl = 'fb://page/102614704912816';
                        } else {
                          fbUrl = 'fb://profile/page_id';
                        }
                        ConnectivityCheck().getConnectionState().then((value)async{
                          if(value){
                            bool launched = await launch(fbUrl);
                            if (!launched) {
                              await launch(webUrl);
                            }
                          }else{
                            TopSnackBar.show();
                          }
                        });


                      } catch (e) {
                        await launch(webUrl);
                      }
                    },
                    icon: SvgPicture.asset("assets/images/facebook.svg"),
                  ),
                ),
                Material(
                  color: Colors.white,
                  child: IconButton(
                    splashColor: Colors.blue,
                    splashRadius: 25.0,
                    onPressed: () async {
                      final url =
                          'https://www.instagram.com/firstclasscanineservices/';
                      try {
                        ConnectivityCheck().getConnectionState().then((value)async{
                          if(value){
                            await launch(url);
                          }else{
                            TopSnackBar.show();
                          }
                        });

                      } catch (e) {}
                    },
                    icon: SvgPicture.asset("assets/images/instagram.svg"),
                  ),
                ),
                Material(
                  color: Colors.white,
                  child: IconButton(
                    splashColor: Colors.blue,
                    splashRadius: 25.0,
                    onPressed: () async{
                      final url = 'https://www.twitter.com/fccanineservice';
                      try {
                        ConnectivityCheck().getConnectionState().then((value)async{
                          if(value){
                            await launch(url);
                          }else{
                            TopSnackBar.show();
                          }
                        });

                      } catch (e) {}
                    },
                    icon: SvgPicture.asset("assets/images/twitter.svg"),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
