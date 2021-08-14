import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:first_class_canine_demo/Service/ConnectivityCheck.dart';
import 'package:first_class_canine_demo/Service/Urls.dart';
import 'package:first_class_canine_demo/UIComponents/BottomNavigation.dart';
import 'package:first_class_canine_demo/UIComponents/BottomSheet/CanineBottomSheet.dart';
import 'package:first_class_canine_demo/UIComponents/CanineStyle.dart';
import 'package:first_class_canine_demo/UIComponents/CanineText.dart';
import 'package:first_class_canine_demo/UIComponents/Progress.dart';
import 'package:first_class_canine_demo/UIComponents/UIComponents/TopSnackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'MyEventDetailsBLOC.dart';

class MyEventCancelledPage extends StatefulWidget {
  final String? reference;

  MyEventCancelledPage({this.reference});

  @override
  State<StatefulWidget> createState() {
    return MyEventCancelledState();
  }
}

class MyEventCancelledState extends State<MyEventCancelledPage> {
  StreamSubscription? subscription;
  bool isOpen = false;
  dynamic bottomSheet;
  final bottomSheetKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
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
          text: "My Event Cancellation",
          color: CanineColors.textColor,
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              if (isOpen == false) Navigator.pop(context);
            }),
      ),
      body: BlocListener(
        bloc: blocProvider,
        listener: (context, state) {},
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
                        margin: EdgeInsets.symmetric(vertical: 10.0),
                        child: CanineText(
                          text: state.eventModal.data!.statusLabel,
                          color: CanineColors.Primary,
                          fontFamily: CanineFonts.Aleo,
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
                                      maxLines: 10,
                                      color: CanineColors.textColor,
                                      fontFamily: CanineFonts.Aleo,
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
                                        text: DateFormat.yMMMd().format(
                                            state.eventModal.data!.startDate!),
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
                                        text: state.eventModal.data!.timingInfo,
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
                                itemCount: state.eventModal.data!.slots!.length,
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
                                    fontFamily: CanineFonts.Aleo)),
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
                                    child: CanineText(
                                        text: DateFormat.yMMMd().format(
                                            state.eventModal.data!.bookedDate!),
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
                                        maxLines: 5,
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
                                        text: "${state.eventModal.data!.name}",
                                        color: CanineColors.textColor,
                                        maxLines: 5,
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
                                      maxLines: 5,
                                      fontFamily: CanineFonts.Aleo,
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
                                      maxLines: 5,
                                      fontFamily: CanineFonts.Aleo,
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
                                    child: CanineText(
                                      text:
                                          "\$${state.eventModal.data!.totalAmount}",
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
                      state.eventModal.data!.paymentLogs!.length>0?Container(
                        margin: EdgeInsets.symmetric(vertical: 10.0),
                        alignment: Alignment.center,
                        child: CanineText(
                          textAlign: TextAlign.center,
                          text: "Payment History",
                          color: CanineColors.Primary,
                          maxLines: 2,
                        ),
                      ):Container(),
                      Flexible(
                        fit: FlexFit.loose,
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 20.0),
                          child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            itemCount:
                                state.eventModal.data!.paymentLogs!.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) => Container(
                              child: Column(children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10.0),
                                      child: CanineText(
                                          text: "Date of Cancellation -",
                                          color: CanineColors.textColor,
                                          fontFamily: CanineFonts.Aleo),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10.0),
                                      child: CanineText(
                                        text: DateFormat.yMMMd().format(state
                                            .eventModal.data!.paymentLogs!
                                            .elementAt(index)
                                            .date!),
                                        color: CanineColors.textColor,
                                        fontFamily: CanineFonts.Aleo,
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10.0),
                                      child: CanineText(
                                          text: "Transaction id -",
                                          color: CanineColors.textColor,
                                          fontFamily: CanineFonts.Aleo),
                                    ),
                                    Flexible(
                                      child: Container(
                                        child: CanineText(
                                          text:
                                              "${state.eventModal.data!.paymentLogs!.elementAt(index).txnId}",
                                          color: CanineColors.textColor,
                                          maxLines: 10,
                                          fontFamily: CanineFonts.Aleo,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10.0),
                                      child: CanineText(
                                          text: "Amount Refunded",
                                          color: CanineColors.textColor,
                                          fontFamily: CanineFonts.Aleo),
                                    ),
                                    Container(
                                      child: CanineText(
                                        text:
                                            "USD \$${state.eventModal.data!.paymentLogs!.elementAt(index).amount}",
                                        color: CanineColors.textColor,
                                        fontFamily: CanineFonts.Aleo,
                                      ),
                                    )
                                  ],
                                )
                              ]),
                            ),
                          ),
                        ),
                      ),
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
    ));
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
