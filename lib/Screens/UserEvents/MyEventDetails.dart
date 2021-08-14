import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:first_class_canine_demo/Screens/ProfilePage/ProfilePage.dart';
import 'package:first_class_canine_demo/Screens/ProfilePage/ProfilePageBloc.dart';
import 'package:first_class_canine_demo/Screens/UserEvents/MyEventDetailsBLOC.dart';
import 'package:first_class_canine_demo/Service/ConnectivityCheck.dart';
import 'package:first_class_canine_demo/Service/Urls.dart';
import 'package:first_class_canine_demo/Storage/Pref/Shared.dart';
import 'package:first_class_canine_demo/UIComponents/BottomNavigation.dart';
import 'package:first_class_canine_demo/UIComponents/BottomSheet/CanineBottomSheet.dart';
import 'package:first_class_canine_demo/UIComponents/CanineButton.dart';
import 'package:first_class_canine_demo/UIComponents/CanineStyle.dart';
import 'package:first_class_canine_demo/UIComponents/CanineText.dart';
import 'package:first_class_canine_demo/UIComponents/Progress.dart';
import 'package:first_class_canine_demo/UIComponents/UIComponents/TopSnackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class MyEventDetailsPage extends StatefulWidget {
  final String? reference;

  MyEventDetailsPage({this.reference});

  @override
  State<StatefulWidget> createState() {
    return MyEventDetailsState();
  }
}

class MyEventDetailsState extends State<MyEventDetailsPage> {
  StreamSubscription? subscription;
  bool isOpen = false;
  dynamic bottomSheet;
  final bottomSheetKey = GlobalKey<ScaffoldState>();
  String? cancelPolicyText;
  @override
  void initState() {
    super.initState();
    getCancelPolicyDescription();
    subscription = Connectivity().onConnectivityChanged.listen((event) {
      event.index == 2 ? TopSnackBar.show() : Container();
    });
    ConnectivityCheck().checkNetwork();
  }

  @override
  Widget build(BuildContext context) {
    final blocProvider = BlocProvider.of<MyEventDetailsBLOC>(context);
    blocProvider.add(MyEventFetch(widget.reference!));
    return SafeArea(
      child: Scaffold(
        key: bottomSheetKey,
        backgroundColor: Colors.black,
        appBar: AppBar(
          centerTitle: true,
          title: CanineText(
            text: "My Event",
            color: CanineColors.textColor,
          ),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
              onPressed: () {
                if (isOpen == false) Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios)),
        ),
        body: BlocListener(
          bloc: blocProvider,
          listener: (context, state) {
            if (state is MyEventCancelSuccessful) {
              cancelSuccess(context);
            }
          },
          child: BlocBuilder(
            bloc: blocProvider,
            builder: (context, state) {
              if (state is MyEventErrorState) {
                return Center(
                  child: CanineText(
                    text: state.errorModal.data!.nonFieldError![0],
                    color: CanineColors.Primary,
                  ),
                );
              }
              if (state is MyEventLoadedSuccessful) {
                return SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(
                              10.0,
                            ),
                            bottomLeft: Radius.circular(10.0)),
                        border: Border.all(color: Colors.white, width: 1.0)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        state.eventModal.data!.eventBanner != ""
                            ? Container(
                                child: Image.network(
                                Urls.imageurl +
                                    state.eventModal.data!.eventBanner!,
                                height: 300.0,
                                fit: BoxFit.fill,
                                  loadingBuilder: (context, child, loadingProgress) {
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
                                  },
                              )
                        )
                            : Container(
                                child: CanineText(
                                  text: "No Image",
                                  color: CanineColors.Primary,
                                ),
                              ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 5.0),
                                child: Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(right: 10.0),
                                      child: Image.asset(
                                        "assets/images/EventIcons/checkList.png",
                                        width: 24.0,
                                        height: 24.0,
                                      ),
                                    ),
                                    Flexible(
                                      child: CanineText(
                                        text: state.eventModal.data!.event,
                                        color: CanineColors.textColor,
                                        fontFamily: CanineFonts.Aleo,
                                        maxLines: 10,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 5.0),
                                child: Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(right: 10.0),
                                      child: Image.asset(
                                          "assets/images/EventIcons/date.png",
                                          width: 24.0,
                                          height: 24.0),
                                    ),
                                    Container(
                                      child: CanineText(
                                          text: DateFormat.yMMMd().format(state
                                              .eventModal.data!.startDate!),
                                          color: CanineColors.textColor,
                                          fontFamily: CanineFonts.Aleo),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 5.0),
                                child: Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(right: 10.0),
                                      child: Image.asset(
                                          "assets/images/EventIcons/time.png",
                                          width: 24.0,
                                          height: 24.0),
                                    ),
                                    Flexible(
                                      child: CanineText(
                                          text:
                                              state.eventModal.data!.timingInfo,
                                          maxLines: 5,
                                          color: CanineColors.textColor,
                                          fontFamily: CanineFonts.Aleo),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 5.0),
                                child: Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(right: 10.0),
                                      child: Image.asset(
                                          "assets/images/EventIcons/location.png",
                                          width: 24.0,
                                          height: 24.0),
                                    ),
                                    Flexible(
                                      child: CanineText(
                                          text:
                                              "${state.eventModal.data!.address},${state.eventModal.data!.city},${state.eventModal.data!.state} ",
                                          color: CanineColors.textColor,
                                          maxLines: 10,
                                          fontFamily: CanineFonts.Aleo),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 5.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: CanineText(
                                          text: "Booth Booked ",
                                          color: Colors.grey,
                                          fontFamily: CanineFonts.Aleo),
                                    ),
                                    Flexible(
                                      child: CanineText(
                                          text: "Additional Pets",
                                          color: Colors.grey,
                                          fontFamily: CanineFonts.Aleo),
                                    )
                                  ],
                                ),
                              ),
                              Flexible(
                                fit: FlexFit.loose,
                                child: ListView.builder(
                                  itemCount:
                                      state.eventModal.data!.slots!.length,
                                  itemBuilder: (context, index) => Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          child: CanineText(
                                              text:
                                                  "${state.eventModal.data!.slots!.elementAt(index).slotNumber} (${state.eventModal.data!.slots!.elementAt(index).name})",
                                              color: CanineColors.textColor,
                                              fontFamily: CanineFonts.Aleo),
                                        ),
                                        Container(
                                          child: CanineText(
                                            text:
                                                "${state.eventModal.data!.slots!.elementAt(index).additionalPets}",
                                            color: CanineColors.textColor,
                                            fontFamily: CanineFonts.Aleo,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                ),
                              ),
                              Container(
                                  alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.symmetric(vertical: 5.0),
                                  child: CanineText(
                                    text:
                                        "Each booth comes with 2 wristbands and 4 dogs",
                                    color: Colors.grey,
                                    fontFamily: CanineFonts.Aleo,
                                    fontSize: 12.0,
                                  )),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 5.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CanineText(
                                        text: "Date of Booking -",
                                        color: CanineColors.textColor,
                                        fontFamily: CanineFonts.Aleo),
                                    Flexible(
                                      flex: 2,
                                      child: CanineText(
                                          text: DateFormat.yMMMd().format(state
                                              .eventModal.data!.bookedDate!),
                                          color: CanineColors.textColor,
                                          fontFamily: CanineFonts.Aleo),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 5.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CanineText(
                                        text: "Kennel Name - ",
                                        color: CanineColors.textColor,
                                        fontFamily: CanineFonts.Aleo),
                                    Flexible(
                                      flex: 2,
                                      child: CanineText(
                                          text:
                                              "${state.eventModal.data!.kennelName}",
                                          color: CanineColors.textColor,
                                          maxLines: 10,
                                          fontFamily: CanineFonts.Aleo),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 5.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CanineText(
                                        text: "Booked by - ",
                                        color: CanineColors.textColor,
                                        fontFamily: CanineFonts.Aleo),
                                    Flexible(
                                      flex: 2,
                                      child: CanineText(
                                          text:
                                              "${state.eventModal.data!.name}",
                                          color: CanineColors.textColor,
                                          maxLines: 10,
                                          fontFamily: CanineFonts.Aleo),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 5.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CanineText(
                                        text: "Email id - ",
                                        color: CanineColors.textColor,
                                        fontFamily: CanineFonts.Aleo),
                                    Flexible(
                                      flex: 4,
                                      child: CanineText(
                                        text: "${state.eventModal.data!.email}",
                                        color: CanineColors.textColor,
                                        fontFamily: CanineFonts.Aleo,
                                        maxLines: 5,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 5.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CanineText(
                                        text: "Booking id -",
                                        color: CanineColors.textColor,
                                        fontFamily: CanineFonts.Aleo),
                                    Flexible(
                                      flex: 2,
                                      child: CanineText(
                                        text: state.eventModal.data!.reference,
                                        color: CanineColors.textColor,
                                        fontFamily: CanineFonts.Aleo,
                                        maxLines: 5,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 5.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CanineText(
                                        text: "TXN id -",
                                        color: CanineColors.textColor,
                                        fontFamily: CanineFonts.Aleo),
                                    Flexible(
                                      flex: 4,
                                      child: CanineText(
                                        text: state.eventModal.data!.txnId,
                                        color: CanineColors.textColor,
                                        fontFamily: CanineFonts.Aleo,
                                        maxLines: 5,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 5.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: CanineText(
                                        text: "Total Amount Paid -",
                                        color: CanineColors.textColor,
                                        fontFamily: CanineFonts.Aleo,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                    Flexible(
                                      flex: 2,
                                      child: CanineText(
                                        text:
                                            "\$${state.eventModal.data!.totalAmount.toString()}",
                                        color: CanineColors.textColor,
                                        fontFamily: CanineFonts.Aleo,
                                        fontSize: 16.0,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10.0),
                          child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                  text: "Please reach out to us at\n",
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                  children: [
                                    TextSpan(
                                        text:
                                            "firstclasscanineservices@gmail.com\n",
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () async {
                                            try {
                                              await launch(
                                                  'mailto:firstclasscanineservices@gmail.com');
                                            } catch (e) {
                                              print(e);
                                            }
                                          },
                                        style: TextStyle(
                                          color: CanineColors.Primary,
                                          decoration: TextDecoration.underline,
                                        )),
                                    TextSpan(
                                      text: "for any booking inquiries",
                                    )
                                  ])),
                        ),
                        DateTime.now()
                                    .difference(
                                        state.eventModal.data!.startDate!)
                                    .inDays
                                    .abs() >
                                30
                            ? Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 20.0),
                                child: CanineButton(
                                  text: "Cancel Event",
                                  color: CanineColors.transparentcolor,
                                  fontSize: 14.0,
                                  buttonWidth: double.maxFinite,
                                  callback: () {
                                    cancelDialog(context, blocProvider);
                                    print(
                                        "Date:${DateTime.now().difference(state.eventModal.data!.startDate!).inDays.abs()}");
                                  },
                                ),
                              )
                            : Container(),
                        DateTime.now()
                                    .difference(
                                        state.eventModal.data!.startDate!)
                                    .inDays
                                    .abs() >
                                30
                            ? Container(
                                margin: EdgeInsets.symmetric(vertical: 10.0,horizontal: 4),
                                alignment: Alignment.center,
                                child: CanineText(
                                  textAlign: TextAlign.center,
                                  decoration: TextDecoration.underline,
                                  text:
                                      "Note: $cancelPolicyText",
                                  color: Colors.grey,
                                  maxLines: 2,
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                );
              }
              return Progress();
            },
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
      bottomSheet.close();
    }
    setState(() {
      isOpen == false ? isOpen = true : isOpen = false;
    });
  }

  void cancelDialog(BuildContext context, MyEventDetailsBLOC blocProvider) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          padding: EdgeInsets.only(bottom: 20.0),
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                alignment: Alignment.centerRight,
                child: IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
              ),
              Container(
                  child: Icon(
                Icons.warning_amber_rounded,
                color: Colors.red,
                size: 80.0,
              )),
              Container(
                alignment: Alignment.center,
                child: CanineText(
                  text: "Are you sure you want\nto cancel this booking?",
                  maxLines: 2,
                  fontSize: 20.0,
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(vertical: 10.0),
                child: CanineText(
                  text:
                      "Your request will be sent to our team and refund\nwill be initiated within 5-6 business days",
                  maxLines: 2,
                  fontSize: 12.0,
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                color: Colors.white,
                margin: EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CanineButton(
                      color: Colors.white,
                      borderColor: CanineColors.dialogButton,
                      textColor: CanineColors.dialogButton,
                      text: "YES",
                      fontSize: 14.0,
                      buttonWidth: 120.0,
                      callback: () {
                        blocProvider.add(MyEventCancel(widget.reference!));
                        Navigator.pop(context);
                      },
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10.0),
                      child: CanineButton(
                        borderColor: CanineColors.dialogButton,
                        textColor: CanineColors.dialogButton,
                        text: "NO",
                        color: Colors.white,
                        fontSize: 14.0,
                        buttonWidth: 120.0,
                        callback: () {
                          Navigator.pop(context);
                          blocProvider.add(MyEventFetch(widget.reference!));
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void cancelSuccess(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Dialog(
          child: Container(
            padding: EdgeInsets.only(bottom: 15.0),
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlocProvider(
                              create: (context) => ProfileBloc(),
                              child: ProfilePage(
                                tabIndexSwitch: true,
                                toHome: true,
                              ),
                            ),
                          ),
                        );
                      }),
                ),
                Container(
                    child: Icon(
                  Icons.done_all,
                  color: Colors.green,
                  size: 50.0,
                )),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20.0),
                  alignment: Alignment.center,
                  child: CanineText(
                    text: "This event has been \nsuccessfully cancelled",
                    maxLines: 2,
                    fontSize: 20.0,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> getCancelPolicyDescription() async {
    final pref = await Shared().getSharedStorage();
    final canceltext =
    await pref.getString("cancellation_note_title")!;
    setState(() {
      this.cancelPolicyText=canceltext;
    });
  }
}
