import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:first_class_canine_demo/Screens/BookingPage/BookingPage.dart';
import 'package:first_class_canine_demo/Screens/BookingPage/BookingPageBLOC.dart';
import 'package:first_class_canine_demo/Screens/Login/LoginBLOC.dart';
import 'package:first_class_canine_demo/Screens/Login/LoginPage.dart';
import 'package:first_class_canine_demo/Screens/ShowEvent/ShowEventBLOC.dart';
import 'package:first_class_canine_demo/Service/ConnectivityCheck.dart';
import 'package:first_class_canine_demo/Service/Urls.dart';
import 'package:first_class_canine_demo/Storage/Pref/Shared.dart';
import 'package:first_class_canine_demo/UIComponents/BottomNavigation.dart';
import 'package:first_class_canine_demo/UIComponents/BottomSheet/CanineBottomSheet.dart';
import 'package:first_class_canine_demo/UIComponents/CanineButton.dart';
import 'package:first_class_canine_demo/UIComponents/CanineButtonDialog.dart';
import 'package:first_class_canine_demo/UIComponents/CanineStyle.dart';
import 'package:first_class_canine_demo/UIComponents/CanineText.dart';
import 'package:first_class_canine_demo/UIComponents/Progress.dart';
import 'package:first_class_canine_demo/UIComponents/UIComponents/TopSnackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ShowEvent extends StatefulWidget {
  String? slug;
  bool? pastEvent;

  ShowEvent({this.slug, this.pastEvent = false});

  @override
  State<StatefulWidget> createState() {
    return ShowEventState();
  }
}

class ShowEventState extends State<ShowEvent> {
  StreamSubscription? subscription;
  bool isOpen = false;
  bool isEnabled = false;
  dynamic? bloc;
  dynamic bottomSheet;
  final bottomSheetKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    subscription = Connectivity().onConnectivityChanged.listen((event) {
      if (event.index == 1 || event.index == 0) {
        BlocProvider.of<ShowEventBLOC>(context)
            .add(ShowEventDetails(widget.slug));
      } else {
         TopSnackBar.show();
      }
    });
    ConnectivityCheck().checkNetwork();
  }

  @override
  Widget build(BuildContext context) {
    final blocProvider = BlocProvider.of<ShowEventBLOC>(context);
    print("EventSlug:${widget.slug}");
    if (!isEnabled) {}
    return SafeArea(
      child: Scaffold(
        key: bottomSheetKey,
        backgroundColor: Colors.black,
        appBar: AppBar(
            centerTitle: true,
            title: Text("Event"),
            backgroundColor: Colors.black,
            leading: GestureDetector(
              onTap: () {
                if (isOpen == false) Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            )),
        body: SingleChildScrollView(
          child: BlocListener(
            bloc: blocProvider,
            listener: (context, state) async {
              print(state);
              if (state is RemoveExistingCartState) {
                final pref = await Shared().getSharedStorage();
                if (pref.containsKey("username")) {
                  print("cart cleared");
                  print(pref.get("username"));

                  ConnectivityCheck().getConnectionState().then((value) {
                    if (value) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BlocProvider(
                                  create: (context) => BookingBLOC(),
                                  child: BookingPage(
                                      eventData: state.eventDetails))));
                    }
                  });
                }
              }
              if (state is CartExistingState) {
                print("WidgetSlug:${widget.slug}");
                print("Slug:${state.eventSlug}");
                if (state.eventSlug == widget.slug) {
                  final pref = await Shared().getSharedStorage();
                  if (pref.containsKey("username")) {
                    print(pref.get("username"));

                    ConnectivityCheck().getConnectionState().then((value) {
                      if (value) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                    create: (context) => BookingBLOC(),
                                    child:
                                        BookingPage(eventData: state.event))));
                      }
                    });
                  }
                } else {
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) => AlertDialog(
                        contentPadding: EdgeInsets.all(20.0),
                        content: Column(
                             mainAxisSize: MainAxisSize.min,
                              children: [

                                Container(
                                  child: Icon(
                                    Icons.error,
                                    color: Colors.red,
                                    size: 80.0,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 10.0),
                                  child: CanineText(
                                    textAlign: TextAlign.center,
                                    text: "There is already an existing event do you want to clear it?",
                                    fontSize: 18.0,
                                    maxLines: 2,
                                  ),
                                ),
                                Container(
                                  color: Colors.white,
                                  margin: EdgeInsets.all(10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [

                                      CanineButtonDailog(
                                        color: Colors.white,
                                        borderColor: CanineColors.dialogButton,
                                        textColor: CanineColors.dialogButton,
                                        text: "YES",
                                        fontSize: 14.0,
                                        buttonWidth: 100.0,
                                        callback: () {
                                          //blocBuilder.add(ProfileLogoutEvent());
                                          ConnectivityCheck()
                                              .getConnectionState()
                                              .then((value) {
                                            if (value) {
                                              blocProvider.add(
                                                  RemoveExistingCart(
                                                      state.event));
                                              Navigator.pop(context);
                                            }
                                          });
                                        },
                                      ),


                                      CanineButtonDailog(
                                        borderColor: CanineColors.dialogButton,
                                        textColor: CanineColors.dialogButton,
                                        text: "NO",
                                        color: Colors.white,
                                        fontSize: 14.0,
                                        buttonWidth: 100.0,
                                        callback: () {

                                            Navigator.pop(context);

                                        },
                                      ),

                                    ],
                                  ),
                                )
                           /*     AlertDialog(
                                  content: Center(
                                    child: CanineText(
                                      text:
                                          "There is already an existing event do you want to clear it ?",
                                      maxLines: 2,
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          ConnectivityCheck()
                                              .getConnectionState()
                                              .then((value) {
                                            if (value) {
                                              blocProvider.add(
                                                  RemoveExistingCart(
                                                      state.event));
                                              Navigator.pop(context);
                                            }
                                          });
                                        },
                                        child: Text("Yes")),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("No"))
                                  ],
                                ),*/
                              ],
                            ),
                          ));
                }
              }
              if (state is CartCheckState) {
                final pref = await Shared().getSharedStorage();
                if (pref.containsKey("username")) {
                  print(pref.get("username"));
                  ConnectivityCheck().getConnectionState().then((value) {
                    if (value) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              settings: RouteSettings(name: "/booking"),
                              builder: (context) => BlocProvider(
                                  create: (context) => BookingBLOC(),
                                  child: BookingPage(
                                      eventData: state.eventDetails))));
                    }
                  });
                }
              }
            },
            child: BlocBuilder(
              bloc: blocProvider,
              builder: (context, state) {
                print("current--$state");
                if (state is ShowEventInputProcessing) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 2,
                          child: Progress(),
                        ),
                      ],
                    ),
                  );
                } else if (state is ShowEventErrorState) {
                  return Center(
                      child: CanineText(
                    text: "Something went wrong.Please try again",
                    color: CanineColors.Primary,
                  ));
                }else if (state is ShowNetworkErrorState ) {
                  return Center(
                      child: CanineText(
                        text: "No network, please check your internet connection!",
                        color: CanineColors.Primary,
                      ));
                } else if (state is EventLoadingSuccessful) {
                  return Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          child: InteractiveViewer(
                            panEnabled: true,
                            scaleEnabled: true,
                            maxScale: 5,
                            child: state.evenData.data!.mapPath != ""
                                ? Image.network(
                                    Urls.imageurl +
                                        state.evenData.data!.mapPath!,
                                    fit: BoxFit.contain,
                                    height:
                                        MediaQuery.of(context).size.height / 2,
                                    width: MediaQuery.of(context).size.width,
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    }
                                    return Container(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              2,
                                      width: MediaQuery.of(context).size.width,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                        ),
                                      ),
                                    );
                                  })
                                : Container(
                                    child: Center(
                                      child: CanineText(
                                        text: "No Image",
                                        color: CanineColors.Primary,
                                      ),
                                    ),
                                    height:
                                        MediaQuery.of(context).size.height / 2,
                                  ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 20.0),
                          alignment: Alignment.center,
                          child: CanineText(
                            text: state.evenData.data!.title,
                            textAlign: TextAlign.center,
                            color: CanineColors.textColor,
                            fontFamily: CanineFonts.Rye,
                            maxLines: 10,
                            fontSize: 25.0,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          alignment: Alignment.center,
                          child: CanineText(
                            textAlign: TextAlign.center,
                            text: state.evenData.data!.address,
                            color: CanineColors.textColor,
                            fontFamily: CanineFonts.Rye,
                            fontSize: 14.0,
                            maxLines: 10,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: 20.0),
                          alignment: Alignment.center,
                          child: CanineText(
                            text: DateFormat.yMMMd()
                                .format(state.evenData.data!.startDate!),
                            textAlign: TextAlign.center,
                            color: CanineColors.textColor,
                            fontFamily: CanineFonts.Rye,
                            fontSize: 14.0,
                          ),
                        ),
                        Divider(
                          thickness: 1,
                          color: Colors.white,
                          indent: 100.0,
                          endIndent: 100.0,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10.0),
                          padding: EdgeInsets.only(left: 20),
                          alignment: Alignment.centerLeft,
                          child: CanineText(
                            text: state.evenData.data!.details!.length > 0
                                ? "Event Details"
                                : "",
                            color: CanineColors.textColor,
                            fontFamily: CanineFonts.Aleo,
                            fontSize: 18.0,
                          ),
                        ),
                        Flexible(
                          fit: FlexFit.loose,
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.only(left: 20),
                            itemCount: state.evenData.data!.details!.length,
                            itemBuilder: (context, index) {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 2.0),
                                    child: CanineText(
                                      text: String.fromCharCode(0x2022),
                                      color: CanineColors.textColor,
                                    ),
                                  ),
                                  Flexible(
                                    child: CanineText(
                                      text: state.evenData.data!.details!
                                          .elementAt(index),
                                      color: CanineColors.textColor,
                                      maxLines: 50,
                                    ),
                                  )
                                ],
                              );
                            },
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10.0),
                          padding: EdgeInsets.only(left: 20),
                          alignment: Alignment.centerLeft,
                          child: CanineText(
                            text: state.evenData.data!.features!.length > 0
                                ? "Events Features"
                                : "",
                            color: CanineColors.textColor,
                            fontFamily: CanineFonts.Aleo,
                            fontSize: 18.0,
                          ),
                        ),
                        Flexible(
                          fit: FlexFit.loose,
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.only(left: 20),
                            itemCount: state.evenData.data!.features!.length,
                            itemBuilder: (context, index) {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 2.0),
                                    child: CanineText(
                                      text: String.fromCharCode(0x2022),
                                      color: CanineColors.textColor,
                                    ),
                                  ),
                                  Flexible(
                                    child: CanineText(
                                      text: state.evenData.data!.features!
                                          .elementAt(index),
                                      color: CanineColors.textColor,
                                      maxLines: 50,
                                    ),
                                  )
                                ],
                              );
                            },
                          ),
                        ),
                        widget.pastEvent == false
                            ? Container(
                                margin: EdgeInsets.symmetric(vertical: 15.0),
                                child: CanineButton(
                                  buttonWidth: 150.0,
                                  color: CanineColors.transparentcolor,
                                  text: "Book Now",
                                  callback: () async {
                                    final pref =
                                        await Shared().getSharedStorage();
                                    if (pref.containsKey("username")) {
                                      ConnectivityCheck().getConnectionState().then((value) {
                                        if (value) {
                                          blocProvider
                                              .add(CartCheck(state.evenData));
                                          print(pref.get("username"));
                                        } else {
                                          return Center(
                                              child: CanineText(
                                                text:
                                                "No network, please check your internet connection!",
                                                color: CanineColors.Primary,
                                              ));
                                        }
                                      });

                                      /*  Navigator.push(context, MaterialPageRoute(
                                        builder: (context) =>
                                        BlocProvider(create: (context) => BookingBLOC(),
                                        child: BookingPage(eventData:state.evenData)
                                        )
                                    )
                                    );*/
                                    } else {

                                      ConnectivityCheck().getConnectionState().then((value) {
                                        if (value) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  settings:
                                                  RouteSettings(name: "/login"),
                                                  builder: (context) => BlocProvider(
                                                      create: (context) =>
                                                          LoginBLOC(),
                                                      child: LoginPage(
                                                          widgetRoute: BlocProvider(
                                                              create: (context) =>
                                                                  BookingBLOC(),
                                                              child: BookingPage(
                                                                  eventData: state
                                                                      .evenData))))));
                                        } else {
                                          return Center(
                                              child: CanineText(
                                                text:
                                                "No network, please check your internet connection!",
                                                color: CanineColors.Primary,
                                              ));
                                        }
                                      });

                                    }
                                  },
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  );
                }
                ConnectivityCheck().getConnectionState().then((value) {
                  if (value) {
                    blocProvider.add(ShowEventDetails(widget.slug));
                  } else {
                    return Center(
                        child: CanineText(
                      text:
                          "No network, please check your internet connection!",
                      color: CanineColors.Primary,
                    ));
                  }
                });

                return Container();
              },
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigation(
          isOpen: isOpen,
          open: (context) {
            if (isOpen == false) {
              bottomSheet = showBottomSheet(
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (context) => StatefulBuilder(
                        builder: (context, setStateBottomSheet) => WillPopScope(
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
        //bottomSheet:isOpen==true ? CanineBottomSheet() :null,
      ),
    );
  }

  void openBottomSheet(BuildContext context) {
    if (isOpen == false) {
      bottomSheet = bottomSheetKey.currentState!
          .showBottomSheet<void>((BuildContext context) {
        return CanineBottomSheet();
      });
    } else {
      if (bottomSheet != null) {
        print("no error");
        bottomSheet.close();
      } else {
        print("error");
        isOpen = true;
      }
    }
    setState(() {
      isOpen == false ? isOpen = true : isOpen = false;
      isEnabled = true;
    });
  }
}
