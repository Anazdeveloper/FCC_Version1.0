import 'package:first_class_canine_demo/Service/ConnectivityCheck.dart';
import 'package:first_class_canine_demo/Storage/Pref/Shared.dart';
import 'package:first_class_canine_demo/UIComponents/BottomNavigation.dart';
import 'package:first_class_canine_demo/UIComponents/BottomSheet/CanineBottomSheet.dart';
import 'package:first_class_canine_demo/UIComponents/CanineStyle.dart';
import 'package:first_class_canine_demo/UIComponents/CanineText.dart';
import 'package:first_class_canine_demo/UIComponents/Progress.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AboutUs extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AboutUsState();
  }
}

class AboutUsState extends State<AboutUs> {
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
        future: getDescription(),
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            final descriptionString = snapshot.data;
            return Scaffold(
              key: bottomSheetKey,
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                elevation: 0.0,
                backgroundColor: Colors.transparent,
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
                          image: AssetImage("assets/images/background.png"),
                          fit: BoxFit.fill)),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      Container(
                        child: ClipRRect(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(180.0),
                                bottomRight: Radius.circular(20)),
                            child: Image.asset("assets/images/about_us.webp",
                                fit: BoxFit.fill,
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height / 2)),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5),
                        child: Image.asset(
                          "assets/images/logo.webp",
                          height: 150,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 5.0),
                        alignment: Alignment.center,
                        child: CanineText(
                          color: CanineColors.textColor,
                          text: "About Us",
                          fontSize: 28.0,
                          fontFamily: CanineFonts.Rye,
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.only(top: 5.0, left: 45.0, right: 45.0),
                        margin: EdgeInsets.symmetric(vertical: 5.0),
                        child: CanineText(
                          color: CanineColors.textColor,
                          text: descriptionString,
                          maxLines: descriptionString!.length,
                          textAlign: TextAlign.center,
                          fontSize: 19.0,
                          fontFamily: CanineFonts.Aleo,
                        ),
                      ),
                    ],
                  )),
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
        });
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

Future<String> getDescription() async {
  final pref = await Shared().getSharedStorage();
  final aboutdescription = await pref.getString("about_description")!;
  return aboutdescription;
}
