import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:first_class_canine_demo/Modal/ShowEventModal.dart';
import 'package:first_class_canine_demo/Repo/Repo.dart';
import 'package:first_class_canine_demo/Screens/BookingPage/BookingPageBLOC.dart';
import 'package:first_class_canine_demo/Screens/Confirmation/ConfirmationBloc.dart';
import 'package:first_class_canine_demo/Screens/Confirmation/ConfirmationPage.dart';
import 'package:first_class_canine_demo/Service/ConnectivityCheck.dart';
import 'package:first_class_canine_demo/Service/Urls.dart';
import 'package:first_class_canine_demo/Storage/Database/Booking.dart';
import 'package:first_class_canine_demo/Storage/Database/BookingDAO.dart';
import 'package:first_class_canine_demo/UIComponents/BottomNavigation.dart';
import 'package:first_class_canine_demo/UIComponents/BottomSheet/CanineBottomSheet.dart';
import 'package:first_class_canine_demo/UIComponents/CanineButton.dart';
import 'package:first_class_canine_demo/UIComponents/CanineStyle.dart';
import 'package:first_class_canine_demo/UIComponents/CanineText.dart';
import 'package:first_class_canine_demo/UIComponents/CanineTextField.dart';
import 'package:first_class_canine_demo/UIComponents/Progress.dart';
import 'package:first_class_canine_demo/UIComponents/UIComponents/CanineSnackBar.dart';
import 'package:first_class_canine_demo/UIComponents/UIComponents/TopSnackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:visibility_detector/visibility_detector.dart';

class BookingPage extends StatefulWidget {
  final EventDetails? eventData;

  BookingPage({this.eventData});

  @override
  State<StatefulWidget> createState() {
    return BookingPageState();
  }
}

class BookingPageState extends State<BookingPage> {
  StreamSubscription? subscription;
  ScrollController scrollController = ScrollController();
  TextEditingController kennelName = TextEditingController();
  bool isOpen = false;
  int count = 0;
  double total = 0;
  List<Map<String, dynamic>> booths = [];
  Map<String, dynamic> priceDetails = {};
  List<double> price = [];
  List<double> priceExtra = [];
  List<String> name = [];
  late BookingDAO bookingDB;
  FocusNode focusNode = FocusNode();
  final formKeyKennel = GlobalKey<FormState>();
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
    final data = widget.eventData!.data;
    final blocProvider = BlocProvider.of<BookingBLOC>(context);
    return SafeArea(
      child: VisibilityDetector(
        onVisibilityChanged: (visibilityInfo) {
          if (mounted) setState(() {});
        },
        key: Key("booking_page"),
        child: Scaffold(
          key: bottomSheetKey,
          backgroundColor: Colors.black,
          appBar: AppBar(
              centerTitle: true,
              title: Text("Booking Page"),
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
            child: Container(
              child: Form(
                key: formKeyKennel,
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        fit: FlexFit.loose,
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 20.0),
                          color: Colors.grey[400],
                          child: GridView.count(
                            physics: NeverScrollableScrollPhysics(),
                            crossAxisCount: 7,
                            shrinkWrap: true,
                            children: List.generate(
                                data!.booths!.length,
                                (index) => GestureDetector(
                                      onTap: data.booths!
                                                  .elementAt(index)
                                                  .availabile ==
                                              true
                                          ? () async {
                                              final booking = Booking(
                                                  booth: data.booths!
                                                      .elementAt(index)
                                                      .number!,
                                                  name: data.booths!
                                                      .elementAt(index)
                                                      .name,
                                                  price: data.booths!
                                                      .elementAt(index)
                                                      .price!,
                                                  priceExtra: data.booths!
                                                      .elementAt(index)
                                                      .priceExtra!,
                                                  additionalPets: 0,
                                                  slug: data.booths!
                                                      .elementAt(index)
                                                      .slug,
                                                  event: data.slug,
                                                  additionalPetsLimits: data
                                                      .booths!
                                                      .elementAt(index)
                                                      .limitDog!,
                                                  index: index,
                                                  wristBand: data.booths!
                                                      .elementAt(index)
                                                      .limitWristBand,
                                                  available: data.booths!
                                                      .elementAt(index)
                                                      .availabile);
                                              ConnectivityCheck().getConnectionState().then((value){
                                                if(value){
                                                  blocProvider.add(
                                                      BookingPageBoothSelection(
                                                          booking, index));
                                                }});

                                            }
                                          : () {},
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: data.booths!
                                                        .elementAt(index)
                                                        .availabile ==
                                                    true
                                                ? data.booths!
                                                            .elementAt(index)
                                                            .selected ==
                                                        true
                                                    ? Colors.green
                                                    : Colors.white
                                                : Colors.grey,
                                            border: Border.all(
                                                color: Color(int.parse(data
                                                    .booths!
                                                    .elementAt(index)
                                                    .colorHex!)),
                                                width: 2.0)),
                                        child: Center(
                                            child: Text(data.booths!
                                                .elementAt(index)
                                                .number
                                                .toString())),
                                      ),
                                    )),
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 10.0,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.grey,
                                  radius: 10,
                                ),
                                Container(
                                    margin:
                                        EdgeInsets.only(left: 5.0, right: 5.0),
                                    child: CanineText(
                                      text: "Unavailable",
                                      color: Colors.white,
                                    ))
                              ],
                            ),
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 10,
                                ),
                                Container(
                                    margin:
                                        EdgeInsets.only(left: 5.0, right: 5.0),
                                    child: CanineText(
                                      text: "Available",
                                      color: Colors.white,
                                    ))
                              ],
                            ),
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.green,
                                  radius: 10,
                                ),
                                Container(
                                    margin:
                                        EdgeInsets.only(left: 5.0, right: 5.0),
                                    child: CanineText(
                                      text: "Selected",
                                      color: Colors.white,
                                    ))
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 100.0,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: data.boothTypes!.length,
                          itemBuilder: (context, index) => Column(
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 20.0,
                                          height: 20.0,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                              width: 2.0,
                                              color: Color(int.parse(data
                                                  .boothTypes!
                                                  .elementAt(index)
                                                  .colorHex!)),
                                            ),
                                          ),
                                        ),
                                        Container(
                                            margin: EdgeInsets.only(left: 10.0),
                                            child: CanineText(
                                              text:
                                                  "${data.boothTypes!.elementAt(index).name} \$${data.boothTypes!.elementAt(index).price}",
                                              color: Colors.white,
                                            )),
                                      ],
                                    ),
                                    Flexible(
                                      child: Container(
                                          margin: EdgeInsets.only(left: 10.0),
                                          child: CanineText(
                                            text:
                                                "Extra \$${data.boothTypes!.elementAt(index).priceExtra} per pet",
                                            color: Colors.white,
                                          )),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {

                          showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              child: Container(
                                child: InteractiveViewer(
                                    panEnabled: true,
                                    scaleEnabled: true,
                                    maxScale: 5,
                                    child: data.mapPath != ""
                                        ? Image.network(
                                            Urls.imageurl + data.mapPath,
                                            fit: BoxFit.contain,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            loadingBuilder:
                                                (BuildContext context,
                                                    Widget child,
                                                    ImageChunkEvent?
                                                        loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            }
                                            return Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  2,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Center(
                                                child:
                                                    CircularProgressIndicator(
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
                                            color: Colors.white,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                2,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Center(
                                              child: CanineText(
                                                text: "No Image",
                                                color: CanineColors
                                                    .buttonColorPrimary,
                                              ),
                                            ),
                                          )),
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          alignment: Alignment.center,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.all(Radius.circular(40)),
                            border: Border.all(),
                          ),
                          child: CanineText(
                            text: "Check the map here",
                            color: CanineColors.Primary,
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        child: CanineTextField(
                          controller: kennelName,
                          prefix: "Kennel name -",
                          tag: "kennel",
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        child: CanineText(
                          textAlign: TextAlign.center,
                          text: "Your Selection",
                          color: Colors.white,
                        ),
                      ),
                      BlocListener(
                        bloc: blocProvider,
                        listener: (context, state) async {
                          print(state);
                          if (state is BookingCartCheckState) {

                            ConnectivityCheck().getConnectionState().then((value){
                              if(value){
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BlocProvider(
                                          create: (context) => ConfirmationBLOC(),
                                          child: ConfirmationPage(
                                              widget.eventData!,
                                              total,
                                              booths,
                                              widget.eventData!.data!.slug!,
                                              kennelName.text)),
                                    ));
                              }});

                          }
                          if (state is BookingPageErrorState) {
                            blocProvider.add(LoadingEvent());
                            Navigator.pop(context);
                            CanineSnackBar.show(context, state.message);
                            setState(() {});
                          }
                          if (state is BookingPageCartClearState) {
                            await clearDB();
                            await clearSelection(widget.eventData!);
                            blocProvider.add(LoadingEvent());
                            setState(() {});
                          }
                          if (state is BookingPageCartErrorState) {
                            await clearDB();
                            await clearSelection(widget.eventData!);
                            blocProvider.add(LoadingEvent());
                            CanineSnackBar.show(context, state.message);
                            setState(() {});
                          }
                          if (state is BookingPageExpired) {
                            blocProvider.add(LoadingEvent());
                            Navigator.pop(context);
                            CanineSnackBar.show(context, "Booth selection expired!!");
                            setState(() {});
                          }
                          if (state is BookingPetsUiReload) {
                            blocProvider.add(LoadingEvent());
                            setState(() {});
                          }
                          if (state is BookingUiReload) {
                            blocProvider.add(LoadingEvent());
                            data.booths!.elementAt(state.index).selected = true;
                            CanineSnackBar.show(context, "Slot reserved");
                            Navigator.pop(context);
                            setState(() {});
                          }
                          if (state is BookingDeleteUiReload) {
                            blocProvider.add(LoadingEvent());
                            data.booths!.elementAt(state.index).selected =
                                false;
                            CanineSnackBar.show(context, "Slot deleted");
                            Navigator.pop(context);
                            setState(() {});
                          }
                          if (state is ShowDialog) {
                            showLoader(context, "Searching slot availability");
                          }
                          if (state is BookingDeleteDialog) {
                            showLoader(context, "Removing slot");
                          }
                        },
                        child: Flexible(
                          fit: FlexFit.loose,
                          child: FutureBuilder<List<Booking>>(
                              future: getBooking(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Column(
                                    children: [
                                      ListView.builder(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: snapshot.data?.length,
                                          itemBuilder: (context, index) {
                                            updateKennel(snapshot.data!);
                                            total = updateUI(snapshot.data!, 0);
                                            return Slidable(
                                              actionPane:
                                                  SlidableDrawerActionPane(),
                                              actionExtentRatio: 0.25,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.white,
                                                        width: 1.0)),
                                                child: ListTile(
                                                  contentPadding:
                                                      EdgeInsets.all(10.0),
                                                  title: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    left: 20.0),
                                                            child: Column(
                                                              children: [
                                                                CanineText(
                                                                  text: "Booth",
                                                                  color: CanineColors
                                                                      .Primary,
                                                                ),
                                                                CanineText(
                                                                  text:
                                                                      "${snapshot.data!.elementAt(index).booth}",
                                                                  color: CanineColors
                                                                      .textColor,
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          Column(
                                                            children: [
                                                              CanineText(
                                                                text:
                                                                    "Additional Pets",
                                                                color:
                                                                    CanineColors
                                                                        .Primary,
                                                              ),
                                                              Container(
                                                                width: 100.0,
                                                                decoration: BoxDecoration(
                                                                    color: Colors
                                                                        .grey,
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(40.0))),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    IconButton(
                                                                      icon: SvgPicture.asset("assets/images/circle-minus.svg"),
                                                                      onPressed: ()async{
                                                                        blocProvider.add(BookingPageRemovePet(snapshot
                                                                            .data!
                                                                            .elementAt(index)));
                                                                      },
                                                                      padding: EdgeInsets.zero,
                                                                      constraints: BoxConstraints(),
                                                                      splashColor: Colors.blue,
                                                                      autofocus: true,
                                                                      visualDensity: VisualDensity.adaptivePlatformDensity,
                                                                    ),
                                                                    CanineText(
                                                                      text:
                                                                          "${snapshot.data!.elementAt(index).additionalPets}",
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                    IconButton(
                                                                      icon: SvgPicture.asset("assets/images/circle-plus.svg"),
                                                                      onPressed: ()async{
                                                                        if(snapshot.data!.elementAt(index).additionalPets==10)
                                                                        {
                                                                          CanineSnackBar.show(context,"Maximum no.of pets allowed is 10");
                                                                        }
                                                                        blocProvider.add(BookingPageAddPet(snapshot
                                                                            .data!
                                                                            .elementAt(index)));
                                                                      },
                                                                      padding: EdgeInsets.zero,
                                                                      constraints: BoxConstraints(),
                                                                      splashColor: Colors.blue,
                                                                      autofocus: true,
                                                                    )
                                                                  ],
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                          Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Column(
                                                                  children: [
                                                                    CanineText(
                                                                      text:
                                                                          "Price",
                                                                      color: CanineColors
                                                                          .Primary,
                                                                    ),
                                                                    CanineText(
                                                                      text:
                                                                          "\$${snapshot.data!.elementAt(index).price}",
                                                                      color: CanineColors
                                                                          .textColor,
                                                                    )
                                                                  ],
                                                                ),
                                                                Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(10.0)),
                                                                    color: Colors
                                                                        .grey,
                                                                  ),
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              15.0),
                                                                  height: 40.0,
                                                                  width: 5.0,
                                                                )
                                                              ]),
                                                        ],
                                                      )),
                                                ),
                                              ),
                                              secondaryActions: [
                                                IconSlideAction(
                                                  onTap: () {
                                                    blocProvider.add(
                                                        BookingPageBoothDeletion(
                                                            snapshot.data!
                                                                .elementAt(
                                                                    index),
                                                            snapshot.data!
                                                                .elementAt(
                                                                    index)
                                                                .index!));
                                                  },
                                                  color: Colors.red,
                                                  icon: Icons.delete,
                                                )
                                              ],
                                            );
                                          }),
                                      Container(
                                        alignment: Alignment.centerRight,
                                        margin: EdgeInsets.symmetric(
                                            vertical: 20.0, horizontal: 20.0),
                                        child: CanineText(
                                          textAlign: TextAlign.center,
                                          text: "Total Amount -\$$total",
                                          color: Colors.white,
                                          fontSize: 20.0,
                                          fontFamily: CanineFonts.Aleo,
                                        ),
                                      )
                                    ],
                                  );
                                } else {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Progress(),
                                    ],
                                  );
                                }
                              }),
                        ),
                      ),
                      BlocBuilder(
                        bloc: blocProvider,
                        builder: (context, state) {
                          if (state is BookingProcessing) {
                            return Progress();
                          }
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 10.0),
                            child: CanineButton(
                              buttonWidth: 150.0,
                              text: "Confirm",
                              color: CanineColors.transparentcolor,
                              callback: () {
                                FocusScope.of(context).unfocus();
                                if (formKeyKennel.currentState!.validate()) {
                                  if (booths.length > 0) {
                                      ConnectivityCheck().getConnectionState().then((value){
                                        if(value){
                                          blocProvider.add(CheckCartEvent());
                                        }});
                                    /* Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => BlocProvider(
                                            create: (context) => ConfirmationBLOC(),
                                            child: ConfirmationPage(
                                                widget.eventData!,
                                                total,
                                                booths,
                                                widget.eventData!.data!.slug!,
                                                kennelName.text)),
                                      )).then((value) => setState((){}));*/
                                  } else {
                                    CanineSnackBar.show(
                                        context, "No booth selected");
                                  }
                                }
                              },
                            ),
                          );
                        },
                      )
                    ]),
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

  Future<List<Booking>> getBooking() async {
    double totalPrice = 0;
    bookingDB = await LocalDB().getLocalDB();
    final bookings = await bookingDB.findBookings();
    totalPrice = updateUI(bookings, totalPrice);
    updateKennel(bookings);
    //print("kennel updating");
    total = totalPrice;
    // print(booths);
    return bookings;
  }

  Future<BookingDAO> loadDB() async {
    return bookingDB = await LocalDB().getLocalDB();
  }

  double updateUI(List<Booking> bookings, double totalPrice) {
    booths.clear();
    for (Booking b in bookings) {
      totalPrice = totalPrice + b.price!;
      booths.add({
        "number": b.booth,
        "name": b.name,
        "slug": b.slug,
        "price": b.price,
        "price_extra": b.priceExtra,
        "limit_wrist_band": b.wristBand,
        "limit_dog": b.additionalPetsLimits,
        "wrist_band_count": b.wristBand,
        "dog_count": b.additionalPets! + b.additionalPetsLimits!,
      });
    }
    return totalPrice;
  }

  void updateKennel(List<Booking> bookings) {
    //print("kennelname");
    String booths = "";
    for (Booking b in bookings) {
      booths = booths + "${b.booth},";
    }
    // kennelName.text = booths;
  }

  showLoader(BuildContext context, String message) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => Dialog(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CanineText(
                      text: message,
                    ),
                    Progress(),
                  ],
                ),
              ),
            ));
  }

  Future<Map<String, dynamic>> getPrice(EventDetails? eventData) async {
    eventData!.data!.booths!.forEach((element) {
      if (!name.contains(element.name)) {
        name.add(element.name!);
        price.add(element.price!);
        priceExtra.add(element.priceExtra!);
        priceDetails
            .addAll({"name": name, "price": price, "priceExtra": priceExtra});
      }
    });
    return await Future.value(priceDetails);
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
