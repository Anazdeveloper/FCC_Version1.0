import 'package:first_class_canine_demo/Modal/ShowEventModal.dart';
import 'package:first_class_canine_demo/Repo/Repo.dart';
import 'package:first_class_canine_demo/Screens/Confirmation/ConfirmationBloc.dart';
import 'package:first_class_canine_demo/Screens/EditProfilePage/EditProfileBloc.dart';
import 'package:first_class_canine_demo/Screens/EditProfilePage/EditProfilePage.dart';
import 'package:first_class_canine_demo/Service/ConnectivityCheck.dart';
import 'package:first_class_canine_demo/Service/StripePayment.dart';
import 'package:first_class_canine_demo/Service/Urls.dart';
import 'package:first_class_canine_demo/Storage/Database/Booking.dart';
import 'package:first_class_canine_demo/Storage/Database/BookingDAO.dart';
import 'package:first_class_canine_demo/Storage/Pref/Shared.dart';
import 'package:first_class_canine_demo/UIComponents/BottomNavigation.dart';
import 'package:first_class_canine_demo/UIComponents/BottomSheet/CanineBottomSheet.dart';
import 'package:first_class_canine_demo/UIComponents/CanineButton.dart';
import 'package:first_class_canine_demo/UIComponents/CanineStyle.dart';
import 'package:first_class_canine_demo/UIComponents/CanineText.dart';
import 'package:first_class_canine_demo/UIComponents/Progress.dart';
import 'package:first_class_canine_demo/UIComponents/UIComponents/CanineSnackBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ConfirmationPage extends StatefulWidget {
  final EventDetails eventDetails;
  final double total;
  final String event;
  final List<Map<String, dynamic>> booths;
  final dynamic kennelName;

  ConfirmationPage(
      this.eventDetails, this.total, this.booths, this.event, this.kennelName);

  @override
  State<StatefulWidget> createState() {
    return ConfirmationPageState();
  }
}

class ConfirmationPageState extends State<ConfirmationPage> {
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
    final blocProvider = BlocProvider.of<ConfirmationBLOC>(context);
    return SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: VisibilityDetector(
            onVisibilityChanged: (visibilityInfo) {
              //if (mounted) setState(() {});
            },
            key: Key("confirm_page"),
            child: Scaffold(
              key: bottomSheetKey,
              backgroundColor: Colors.black,
              appBar: AppBar(
                centerTitle: true,
                title: CanineText(
                  text: "Confirmation",
                  color: CanineColors.textColor,
                ),
                elevation: 0.0,
                backgroundColor: Colors.black,
                leading: IconButton(
                    onPressed: () {
                      if (isOpen == false) Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back_ios)),
              ),
              body: SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.black,
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
                      Container(
                          child: widget.eventDetails.data!.bannerPath != ""
                              ? Image.network(
                            Urls.imageurl +
                                widget.eventDetails.data!.bannerPath,
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
                              : CanineText(
                            text: "No image",
                            color: CanineColors.Primary,
                          )),
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
                                      text: widget.eventDetails.data!.title,
                                      maxLines: 4,
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
                                            widget.eventDetails.data!.startDate!),
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
                                        text: widget.eventDetails.data!.timing_info,
                                        color: CanineColors.textColor,
                                        maxLines: 4,
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
                                        text: widget.eventDetails.data!.address,
                                        color: CanineColors.textColor,
                                        maxLines: 4,
                                        fontFamily: CanineFonts.Aleo),
                                  )
                                ],
                              ),
                            ),
                            Container(
                                margin: EdgeInsets.symmetric(vertical: 5.0),
                                child: CanineText(
                                    text:
                                    "Each booth comes with 2 wristbands and 4 dogs",
                                    color: Colors.grey,
                                    fontFamily: CanineFonts.Aleo)),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 5.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: CanineText(
                                        text: "Kennel Name - ",
                                        color: CanineColors.textColor,
                                        fontFamily: CanineFonts.Aleo),
                                  ),
                                  Flexible(
                                    child: CanineText(
                                        text: widget.kennelName,
                                        color: CanineColors.textColor,
                                        maxLines: 4,
                                        fontFamily: CanineFonts.Aleo),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 5.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: CanineText(
                                        text: "Booking Name - ",
                                        color: CanineColors.textColor,
                                        fontFamily: CanineFonts.Aleo),
                                  ),
                                  Flexible(
                                    child: FutureBuilder<String>(
                                      future: getName(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return CanineText(
                                              text: snapshot.data,
                                              color: CanineColors.textColor,
                                              maxLines: 4,
                                              fontFamily: CanineFonts.Aleo);
                                        }
                                        return CanineText(
                                            text: "",
                                            color: CanineColors.textColor,
                                            fontFamily: CanineFonts.Aleo);
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 5.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  CanineText(
                                      text: "Email id - ",
                                      color: CanineColors.textColor,
                                      fontFamily: CanineFonts.Aleo),
                                  Flexible(
                                    child: FutureBuilder<String>(
                                      future: getEmail(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return CanineText(
                                              text: snapshot.data,
                                              color: CanineColors.textColor,
                                              maxLines: 4,
                                              fontFamily: CanineFonts.Aleo);
                                        }
                                        return CanineText(
                                            text: "",
                                            color: CanineColors.textColor,
                                            fontFamily: CanineFonts.Aleo);
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 5.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: CanineText(
                                        text: "Booth Booked ",
                                        color: Colors.grey,
                                        fontFamily: CanineFonts.Aleo),
                                  ),
                                  Flexible(
                                    child: CanineText(
                                        text: "Price",
                                        color: Colors.grey,
                                        fontFamily: CanineFonts.Aleo),
                                  )
                                ],
                              ),
                            ),
                            Divider(
                              thickness: 1.0,
                              color: Colors.white,
                            ),
                            //Replace with listbuilder

                            Flexible(
                              fit: FlexFit.loose,
                              child: FutureBuilder<List<Booking>>(
                                future: getBooking(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Container();
                                  }
                                  return ListView.builder(
                                    itemCount: snapshot.data!.length,
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) => Container(
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                child: CanineText(
                                                    text:
                                                    "Booth no. ${snapshot.data!.elementAt(index).booth} (${(snapshot.data!.elementAt(index).name)})",
                                                    color: CanineColors.textColor,
                                                    fontFamily: CanineFonts.Aleo),
                                              ),
                                              Container(
                                                child: CanineText(
                                                    text:
                                                    "\$${snapshot.data!.elementAt(index).price! - (snapshot.data!.elementAt(index).priceExtra! * snapshot.data!.elementAt(index).additionalPets!)}",
                                                    color: CanineColors.textColor,
                                                    fontFamily: CanineFonts.Aleo),
                                              )
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                child: CanineText(
                                                    text:
                                                    "Additional Pets  - ${snapshot.data!.elementAt(index).additionalPets!}",
                                                    color: CanineColors.textColor,
                                                    fontFamily: CanineFonts.Aleo),
                                              ),
                                              Container(
                                                child: CanineText(
                                                    text:
                                                    "\$${snapshot.data!.elementAt(index).priceExtra! * (snapshot.data!.elementAt(index).additionalPets!)}",
                                                    color: CanineColors.textColor,
                                                    fontFamily: CanineFonts.Aleo),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: CanineText(
                                        text: "Total Amount  -",
                                        color: CanineColors.textColor,
                                        fontSize: 18.0,
                                        fontFamily: CanineFonts.Aleo),
                                  ),
                                  Flexible(
                                    child: CanineText(
                                        text: "\$${widget.total}",
                                        color: CanineColors.textColor,
                                        fontSize: 18.0,
                                        fontFamily: CanineFonts.Aleo),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      BlocListener(
                          bloc: blocProvider,
                          listener: (context, state) async {
                            if (state is ConfirmationErrorState) {
                              await clearDB();
                              await clearSelection(widget.eventDetails);
                              CanineSnackBar.show(context, "Booth selection expired!");
                            }
                            if (state is ConfirmationState) {
                              final pref = await Shared().getSharedStorage();
                              if (pref.containsKey('addr_id')) {
                                if (pref.get('addr_id') != null) {
                                  //paymentDialog(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        settings: RouteSettings(name: "/payment"),
                                        builder: (context) => PaymentScreen(
                                            widget.total,
                                            widget.booths,
                                            widget.event,
                                            widget.eventDetails,
                                            widget.kennelName),
                                      ));
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => BlocProvider(
                                          create: (context) => EditProfileBloc(),
                                          child: EditProfilePage(
                                            isBilling: true,
                                            name: "",
                                            phone: "",
                                            city: "",
                                            email: "",
                                            statename: "",
                                            street: "",
                                            username: "",
                                            zip: "",
                                            address: "",
                                          ),
                                        ),
                                      ));
                                }
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BlocProvider(
                                        create: (context) => EditProfileBloc(),
                                        child: EditProfilePage(
                                          isBilling: true,
                                          name: "",
                                          widgetRoute: BlocProvider(
                                            create: (context) => ConfirmationBLOC(),
                                            child: ConfirmationPage(
                                                widget.eventDetails,
                                                widget.total,
                                                widget.booths,
                                                widget.event,
                                                widget.kennelName),
                                          ),
                                          phone: "",
                                          city: "",
                                          email: "",
                                          statename: "",
                                          street: "",
                                          username: "",
                                          zip: "",
                                          address: "",
                                        ),
                                      ),
                                    ));
                              }
                            }
                          },
                          child: Container()),
                      BlocBuilder(
                        bloc: blocProvider,
                        builder: (context, state) {
                          if (state is ConfirmationProcessing) {
                            return Progress();
                          }
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 10.0),
                            child: CanineButton(
                              text: "Proceed to Pay",
                              color: CanineColors.transparentcolor,
                              fontSize: 14.0,
                              callback: () {
                                //paymentDialog(context);
                                FocusScope.of(context).unfocus();
                                blocProvider.add(ConfirmEvent());
                              },
                            ),
                          );
                        },
                      ),
                    ],
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
            ),
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

  Future<List<Booking>> getBooking() async {
    BookingDAO bookingDB = await LocalDB().getLocalDB();
    final bookings = await bookingDB.findBookings();
    return bookings;
  }

  paymentDialog(BuildContext context) {
    //Navigator.push(context, MaterialPageRoute(builder: (context) =>PaymentScreen(widget.total,widget.booths,widget.event) ,));
    showDialog(
      context: context,
      builder: (context) => PaymentScreen(widget.total, widget.booths,
          widget.event, widget.eventDetails, widget.kennelName),
    );
  }

  successDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
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
                      Navigator.of(context).pop();
                    }),
              ),
              Container(
                  child: Icon(
                    Icons.done_all,
                    color: Colors.green,
                    size: 50.0,
                  )),
              Container(
                alignment: Alignment.center,
                child: CanineText(
                  text: "This event has been \nsuccessfully booked",
                  maxLines: 2,
                  fontSize: 20.0,
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(vertical: 10.0),
                child: CanineText(
                  text: "Your booking id - WG4MBND",
                  maxLines: 2,
                  fontSize: 12.0,
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(vertical: 10.0),
                child: CanineText(
                  text: "You will receive an confirmation email shortly",
                  maxLines: 2,
                  fontSize: 12.0,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> getName() async {
    final pref = await Shared().getSharedStorage();
    return pref.getString("user").toString();
  }

  Future<String> getEmail() async {
    final pref = await Shared().getSharedStorage();
    return pref.getString("username").toString();
  }

  Future clearSelection(EventDetails event) async {
    event.data!.booths!.forEach((element) {
      element.selected = null;
    });
  }

  Future clearDB() async {
    final db = await LocalDB().getLocalDB();
    await db.deleteAllBookings();
  }
}
