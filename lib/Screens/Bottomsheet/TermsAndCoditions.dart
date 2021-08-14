import 'package:first_class_canine_demo/Service/ConnectivityCheck.dart';
import 'package:first_class_canine_demo/Storage/Pref/Shared.dart';
import 'package:first_class_canine_demo/UIComponents/BottomNavigation.dart';
import 'package:first_class_canine_demo/UIComponents/BottomSheet/CanineBottomSheet.dart';
import 'package:first_class_canine_demo/UIComponents/CanineStyle.dart';
import 'package:first_class_canine_demo/UIComponents/Progress.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:url_launcher/url_launcher.dart';

class TermsAndConditions extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TermsAndConditionsState();
  }
}

class TermsAndConditionsState extends State<TermsAndConditions> {
  bool isOpen = false;
  dynamic bottomSheet;
  final bottomSheetKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    ConnectivityCheck().checkNetwork();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getTermsDescription(),
      builder: (context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasData) {
          final descriptionString = snapshot.data;
          return Scaffold(
            key: bottomSheetKey,
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              elevation: 0.0,
              backgroundColor: Colors.black,
              centerTitle: true,
              title: Text(
                'Terms & Conditions',
                style: TextStyle(color: Colors.white),
              ),
              leading: IconButton(
                onPressed: () {
                  if (isOpen == false) Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios),
              ),
            ),
            body: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage("assets/images/background.png"))),
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Container(
                    padding:
                        EdgeInsets.only(top: 100.0, left: 30.0, right: 30.0),
                    margin: EdgeInsets.symmetric(vertical: 5.0),
                    child: HtmlWidget(
                      descriptionString!,
                      //webView: true,
                      // onTapUrl: (email) async{
                      //   try {
                      //     await launch(
                      //         email);
                      //   } catch (e) {}
                      // },
                      textStyle: TextStyle(
                        color: CanineColors.textColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //bottomSheet: isOpen == true ? CanineBottomSheet() : null,
            bottomNavigationBar: BottomNavigation(
              isOpen: isOpen,
              open: (context) {
                if (isOpen == false) {
                  bottomSheet = showBottomSheet(
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (context) => StatefulBuilder(
                            builder: (context, setStateBottomSheet) =>
                                WillPopScope(
                                    onWillPop: () async {
                                      setStateBottomSheet(() {
                                        setState(() {
                                          isOpen == false
                                              ? isOpen = true
                                              : isOpen = false;
                                        });
                                      });
                                      return true;
                                    },
                                    child: GestureDetector(
                                        onVerticalDragStart: (_) {},
                                        onTap: () {
                                          Navigator.pop(context);
                                          setState(() {
                                            isOpen == false
                                                ? isOpen = true
                                                : isOpen = false;
                                          });
                                        },
                                        child: CanineBottomSheet())),
                          ));
                  setState(() {
                    isOpen == false ? isOpen = true : isOpen = false;
                  });
                } else {
                  try {
                    bottomSheet!.close();
                    setState(() {
                      isOpen == false ? isOpen = true : isOpen = false;
                    });
                  } catch (e) {
                    print(e);
                    bottomSheet = showBottomSheet(
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (context) => CanineBottomSheet(),
                    );
                    setState(() {
                      isOpen == false ? isOpen = true : isOpen = false;
                    });
                  } finally {
                    setState(() {
                      isOpen == false ? isOpen = true : isOpen = false;
                    });
                    isOpen == false ? isOpen = true : isOpen = false;
                  }
                }
                //openBottomSheet(context)
              },
            ),
          );
        }
        return Progress();
      },
    );
  }

  void openBottomSheet(BuildContext context) {
    if (isOpen == false) {
      bottomSheet = bottomSheetKey.currentState!
          .showBottomSheet<void>((BuildContext context) {
        return CanineBottomSheet();
      });
    } else {
      bottomSheet.close();
    }
    setState(() {
      isOpen == false ? isOpen = true : isOpen = false;
    });
  }
}

Future<String> getTermsDescription() async {
  final pref = await Shared().getSharedStorage();
  final termsdescription = await pref.getString("terms_description")!;
  return termsdescription;
}
