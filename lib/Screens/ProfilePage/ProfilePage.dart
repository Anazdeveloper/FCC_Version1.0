import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:first_class_canine_demo/Repo/Repo.dart';
import 'package:first_class_canine_demo/Repo/StaticDataRepo.dart';
import 'package:first_class_canine_demo/Screens/ChangePassword/ChangePasswordBLOC.dart';
import 'package:first_class_canine_demo/Screens/ChangePassword/ChangePasswordPage.dart';
import 'package:first_class_canine_demo/Screens/EditProfilePage/EditProfileBloc.dart';
import 'package:first_class_canine_demo/Screens/EditProfilePage/EditProfilePage.dart';
import 'package:first_class_canine_demo/Screens/HomePage/HomeBloc.dart';
import 'package:first_class_canine_demo/Screens/HomePage/HomePage.dart';
import 'package:first_class_canine_demo/Screens/Login/LoginBLOC.dart';
import 'package:first_class_canine_demo/Screens/Login/LoginPage.dart';
import 'package:first_class_canine_demo/Screens/ProfilePage/ProfilePageBloc.dart';
import 'package:first_class_canine_demo/Screens/UserEvents/MyEventDetails.dart';
import 'package:first_class_canine_demo/Screens/UserEvents/MyEventDetailsBLOC.dart';
import 'package:first_class_canine_demo/Screens/UserEvents/MyEventsCancelledPage.dart';
import 'package:first_class_canine_demo/Service/Api.dart';
import 'package:first_class_canine_demo/Service/ConnectivityCheck.dart';
import 'package:first_class_canine_demo/Service/Urls.dart';
import 'package:first_class_canine_demo/Storage/Pref/Shared.dart';
import 'package:first_class_canine_demo/UIComponents/BottomNavigation.dart';
import 'package:first_class_canine_demo/UIComponents/BottomSheet/CanineBottomSheet.dart';
import 'package:first_class_canine_demo/UIComponents/CanineButton.dart';
import 'package:first_class_canine_demo/UIComponents/CanineButtonDialog.dart';
import 'package:first_class_canine_demo/UIComponents/CanineStyle.dart';
import 'package:first_class_canine_demo/UIComponents/CanineText.dart';
import 'package:first_class_canine_demo/UIComponents/EventCellWidget.dart';
import 'package:first_class_canine_demo/UIComponents/Progress.dart';
import 'package:first_class_canine_demo/UIComponents/UIComponents/TopSnackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Service/Api.dart';

class ProfilePage extends StatefulWidget {
  final bool? tabIndexSwitch, toHome;

  ProfilePage({this.tabIndexSwitch = false, this.toHome = false});

  @override
  State<StatefulWidget> createState() {
    return ProfilePageState();
  }
}

class ProfilePageState extends State<ProfilePage> {
  StreamSubscription? subscription;
  bool isOpen = false;
  bool isBill = false;
  bool isEnabled = false;
  final formKeyLogin = GlobalKey<FormState>();
  TextEditingController password = TextEditingController();
  int count = 0;
  dynamic bottomSheet;
  final bottomSheetKey = GlobalKey<ScaffoldState>();
  bool isLogoutEnabled = false;

  @override
  void initState() {
    super.initState();
    password.text = '......';
    subscription = Connectivity().onConnectivityChanged.listen((event) {
      if (event.index == 1 || event.index == 0) {
        BlocProvider.of<ProfileBloc>(context).add(ProfileUiLoadedEvent());
      } else {
        TopSnackBar.show();
      }
    });
    ConnectivityCheck().checkNetwork();
  }

  @override
  Widget build(BuildContext context) {
    print("Route name:${ModalRoute
        .of(context)!
        .settings
        .name}");
    final blocBuilder = BlocProvider.of<ProfileBloc>(context);
    if (!isEnabled) blocBuilder.add(ProfileUiLoadedEvent());
    var address;
    var street;
    var city;
    var stateName;
    var zip;
    var country;
    var billingAddress;

    var userAddress;
    TextEditingController name = TextEditingController();

    return SafeArea(
      child: Scaffold(
        key: bottomSheetKey,
        backgroundColor: Colors.black,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.black,
          title: Container(
            child: BlocBuilder(
              bloc: blocBuilder,
              builder: (context, state) {
                if (state is ProfileDataLoaded) {
                  int idx = state.profileData.name.indexOf(" ");
                  final nameParts;
                  if (idx == -1) {
                    nameParts = state.profileData.name;
                  } else {
                    nameParts = state.profileData.name.substring(0, idx).trim();
                  }
                  return Row(
                    children: <Widget>[
                      Flexible(
                          fit: FlexFit.tight,
                          child: Container(
                              padding: EdgeInsets.only(top: 20.0),
                              child: Text('Hi ${nameParts},',
                                  softWrap: true,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 26.0,
                                      fontStyle: FontStyle.normal,
                                      fontFamily: 'Rye')))),
                      Container(
                          padding: EdgeInsets.only(top: 20.0),
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () async {
                              final pref = await Shared().getSharedStorage();
                              Http().logout(
                                  "",
                                  Urls.logout,
                                  pref.get("refresh_token"),
                                  ContentType.urlEncode);
                              logoutDialog(context, blocBuilder);
                            },
                            child: Text(
                              'Logout',
                              style: TextStyle(color: Colors.white),
                            ),
                          ))
                    ],
                  );
                }
                return Container();
              },
            ),
          ),
        ),
        body: WillPopScope(
          onWillPop: () async {
            if (Navigator.of(context).canPop()) {
              if (widget.toHome == true) {
                print("Back from payment/cancel page");
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        settings: RouteSettings(name: "/home"),
                        builder: (context) =>
                            BlocProvider(
                              create: (context) => HomeBloc(),
                              child: HomePage(),
                            )));
              }
              return true;
            } else {
              return false;
            }
          },
          child: BlocBuilder(
            bloc: blocBuilder,
            builder: (context, state) {
              if (state is ProfileDataLoaded) {
                print('Data Loading.....');
                address = state.addressData?.address ?? '';
                street = state.addressData?.street ?? '';
                city = state.addressData?.city ?? '';
                stateName = state.addressData?.state ?? '';
                zip = state.addressData?.zip ?? '';
                name.text = '......';
                //country = state.addressData?.country ?? '';
                userAddress = '$address ,';
                if (address == '') {
                  userAddress = '';
                }
                billingAddress =
                '${street},\n$userAddress ${city}, ${stateName}, ${zip}';
                if (street == '') {
                  billingAddress = '';
                }
                return Container(
                  color: Colors.black,
                  child: ListView(
                    children: <Widget>[
                      Divider(color: Colors.white, thickness: 2.0),
                      DefaultTabController(
                        initialIndex: widget.tabIndexSwitch == false ? 0 : 1,
                        length: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Container(
                              child: TabBar(
                                indicatorColor: Colors.red,
                                indicatorWeight: 4.0,
                                indicatorSize: TabBarIndicatorSize.label,
                                labelStyle:
                                TextStyle(fontWeight: FontWeight.bold),
                                unselectedLabelColor:
                                CanineColors.buttonColorPrimary,
                                tabs: [
                                  Tab(
                                    text: 'Profile',
                                  ),
                                  Tab(
                                    text: 'My Events',
                                  )
                                ],
                              ),
                            ),
                            Container(
                              height: MediaQuery
                                  .of(context)
                                  .size
                                  .height * 0.80,
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                      color: Colors.white, width: 2.0),
                                ),
                              ),
                              child: TabBarView(
                                children: <Widget>[
                                  //Contents of profile tab
                                  Container(
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.only(right: 20.0),
                                          alignment: Alignment.topRight,
                                          child: ElevatedButton(
                                            style: ButtonStyle(
                                                backgroundColor:
                                                MaterialStateColor
                                                    .resolveWith((states) =>
                                                Colors.black)),
                                            onPressed: () {
                                              isBill = false;
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          BlocProvider(
                                                            create: (context) =>
                                                                EditProfileBloc(),
                                                            child:
                                                            EditProfilePage(
                                                              name: state
                                                                  .profileData
                                                                  .name,
                                                              username: state
                                                                  .profileData
                                                                  .username,
                                                              email: state
                                                                  .profileData
                                                                  .email,
                                                              phone: state
                                                                  .profileData
                                                                  .phone,
                                                              street: street,
                                                              city: city,
                                                              zip: zip,
                                                              statename:
                                                              stateName,
                                                              address: address,
                                                              isBilling: isBill,
                                                              widgetRoute:
                                                              BlocProvider(
                                                                create: (
                                                                    context) =>
                                                                    ProfileBloc(),
                                                                child:
                                                                ProfilePage(),
                                                              ),
                                                            ),
                                                          )));
                                            },
                                            child: Image.asset(
                                              'assets/images/pencil.png',
                                              height: 20.0,
                                              width: 20.0,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(
                                              top: 0.0,
                                              left: 30.0,
                                              right: 30.0),
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 20.0),
                                                child: Stack(
                                                  children: [
                                                    Text(
                                                      'Name',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                          FontWeight.bold),
                                                    ),
                                                    Container(
                                                        padding:
                                                        EdgeInsets.only(
                                                            top: 10.0,
                                                            left: 80.0,
                                                            right: 10.0),
                                                        child: Divider(
                                                          color: Colors.grey,
                                                          thickness: 1.5,
                                                        )),
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          left: 95.0,
                                                          right: 12.0),
                                                      child:
                                                      SingleChildScrollView(
                                                        scrollDirection:
                                                        Axis.horizontal,
                                                        child: Text(
                                                          '${state.profileData
                                                              .name}',
                                                          style: TextStyle(
                                                              color:
                                                              Colors.white,
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 20.0),
                                                child: Stack(
                                                  children: [
                                                    Text(
                                                      'Email Id',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                          FontWeight.bold),
                                                    ),
                                                    Container(
                                                        padding:
                                                        EdgeInsets.only(
                                                            top: 10.0,
                                                            left: 80.0,
                                                            right: 10.0),
                                                        child: Divider(
                                                          color: Colors.grey,
                                                          thickness: 1.5,
                                                        )),
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          left: 95.0,
                                                          right: 12.0),
                                                      child:
                                                      SingleChildScrollView(
                                                        scrollDirection:
                                                        Axis.horizontal,
                                                        child: Text(
                                                          '${state.profileData
                                                              .email}',
                                                          style: TextStyle(
                                                              color:
                                                              Colors.white,
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 0.0),
                                                child: Stack(
                                                  children: [
                                                    Text(
                                                      'Mobile No',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                          FontWeight.bold),
                                                    ),
                                                    Container(
                                                        padding:
                                                        EdgeInsets.only(
                                                            top: 10.0,
                                                            left: 80.0,
                                                            right: 10.0),
                                                        child: Divider(
                                                          color: Colors.grey,
                                                          thickness: 1.5,
                                                        )),
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          left: 95.0),
                                                      child: Text(
                                                        '${state.profileData
                                                            .phone}',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                            FontWeight
                                                                .bold),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 0.0),
                                                child: Stack(
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          top: 20.0),
                                                      child: Text(
                                                        'Password',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                            FontWeight
                                                                .bold),
                                                      ),
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          left: 90.0),
                                                      child: TextFormField(
                                                        showCursor: false,
                                                        obscureText: true,
                                                        readOnly: true,
                                                        controller: name,
                                                        decoration:
                                                        InputDecoration(
                                                            border:
                                                            InputBorder
                                                                .none),
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 25.0,
                                                            fontWeight:
                                                            FontWeight.bold,
                                                            letterSpacing: 8.0),
                                                      ),
                                                    ),
                                                    Container(
                                                        padding:
                                                        EdgeInsets.only(
                                                            top: 30.0,
                                                            left: 80.0,
                                                            right: 10.0),
                                                        child: Divider(
                                                          color: Colors.grey,
                                                          thickness: 1.5,
                                                        )),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                  alignment:
                                                  Alignment.centerRight,
                                                  child: TextButton(
                                                      onPressed: () {
                                                        ConnectivityCheck()
                                                            .getConnectionState()
                                                            .then((value) {
                                                          if (value) {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder:
                                                                      (
                                                                      context) =>
                                                                      BlocProvider(
                                                                        create: (
                                                                            context) =>
                                                                            ChangePasswordBLOC(),
                                                                        child:
                                                                        ChangePasswordPage(),
                                                                      ),
                                                                ));
                                                          } else {
                                                            TopSnackBar.show();
                                                          }
                                                        });
                                                      },
                                                      child: Text(
                                                        'Change Password',
                                                        style: TextStyle(
                                                            color:
                                                            Colors.white),
                                                      )))
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                          const EdgeInsets.only(top: 50.0),
                                          child: Stack(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.only(
                                                    right: 20.0),
                                                alignment: Alignment.topRight,
                                                child: ElevatedButton(
                                                  style: ButtonStyle(
                                                      backgroundColor:
                                                      MaterialStateColor
                                                          .resolveWith(
                                                              (states) =>
                                                          Colors
                                                              .black)),
                                                  onPressed: () {
                                                    isBill = true;
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (
                                                                context) =>
                                                                BlocProvider(
                                                                  create: (
                                                                      context) =>
                                                                      EditProfileBloc(),
                                                                  child:
                                                                  EditProfilePage(
                                                                    name: state
                                                                        .profileData
                                                                        .name,
                                                                    username: state
                                                                        .profileData
                                                                        .username,
                                                                    email: state
                                                                        .profileData
                                                                        .email,
                                                                    phone: state
                                                                        .profileData
                                                                        .phone,
                                                                    street:
                                                                    street,
                                                                    city: city,
                                                                    zip: zip,
                                                                    statename:
                                                                    stateName,
                                                                    address:
                                                                    address,
                                                                    isBilling:
                                                                    isBill,
                                                                    widgetRoute:
                                                                    BlocProvider(
                                                                      create: (
                                                                          context) =>
                                                                          ProfileBloc(),
                                                                      child:
                                                                      ProfilePage(),
                                                                    ),
                                                                  ),
                                                                )));
                                                  },
                                                  child: Image.asset(
                                                    'assets/images/pencil.png',
                                                    height: 20.0,
                                                    width: 20.0,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(
                                                    top: 0.0, left: 30.0),
                                                child: Text(
                                                  'Billing Address',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                      FontWeight.bold),
                                                ),
                                              ),
                                              /*     Container(
                                                  width: 350,
                                                  padding: EdgeInsets.only(
                                                      top: 20.0, left: 30.0, right: 70.0),
                                                  child:Text(
                                                    userAddress,
                                                    maxLines:2,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                ),*/
                                              Container(
                                                width: 350,
                                                padding: EdgeInsets.only(
                                                    top: 30.0,
                                                    left: 30.0,
                                                    right: 30.0),
                                                child: Text(
                                                  billingAddress,
                                                  maxLines: 4,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                      FontWeight.bold),
                                                ),
                                              ),
                                              Container(
                                                  padding: EdgeInsets.only(
                                                      top: 100.0,
                                                      left: 30.0,
                                                      right: 30.0),
                                                  child: Divider(
                                                      color: Colors.grey,
                                                      thickness: 1.5)),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          alignment: Alignment.bottomCenter,
                                          padding: EdgeInsets.only(
                                            top: 100.0,
                                          ),
                                          child: Column(
                                            children: <Widget>[
                                              Text(
                                                'Please reach out to us at',
                                                style: TextStyle(
                                                    color: Colors.grey),
                                              ),
                                              GestureDetector(
                                                onTap: () async {
                                                  try {
                                                    await launch(
                                                        'mailto:firstclasscanineservices@gmail.com');
                                                  } catch (e) {}
                                                },
                                                child: Text(
                                                  'firstclasscanineservices@gmail.com',
                                                  style: TextStyle(
                                                      color: CanineColors
                                                          .buttonColorPrimary,
                                                      decoration: TextDecoration
                                                          .underline),
                                                ),
                                              ),
                                              Text(
                                                'for any account related issues.',
                                                style: TextStyle(
                                                    color: Colors.grey),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  //*********************************Contents of events tab**************************************
                                  Container(
                                    alignment: Alignment.topCenter,
                                    padding: EdgeInsets.only(top: 10.0),
                                    child: ListView(
                                      children: <Widget>[
                                        Container(
                                          alignment: Alignment.topCenter,
                                          child: Text(
                                            'Upcoming Events',
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                        ),
                                        state.bookingData!.upcoming!.length > 0
                                            ? Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.40,
                                                child: ListView.builder(
                                                    padding: EdgeInsets.only(
                                                        top: 20.0,
                                                        left: 10.0,
                                                        right: 10),
                                                    itemCount: state
                                                        .bookingData!
                                                        .upcoming!
                                                        .length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      final Page;
                                                      if (state
                                                              .bookingData!
                                                              .upcoming![index]
                                                              .bookingStatus ==
                                                          'confirmed') {
                                                        Page =
                                                            MyEventDetailsPage(
                                                          reference: state
                                                              .bookingData!
                                                              .upcoming!
                                                              .elementAt(index)
                                                              .reference,
                                                        );
                                                      } else {
                                                        Page =
                                                            MyEventCancelledPage(
                                                          reference: state
                                                              .bookingData!
                                                              .upcoming!
                                                              .elementAt(index)
                                                              .reference,
                                                        );
                                                      }
                                                      return EventCellWidget(
                                                        eventPoster: state
                                                            .bookingData!
                                                            .upcoming![index]
                                                            .eventBanner,
                                                        eventName: state
                                                            .bookingData!
                                                            .upcoming![index]
                                                            .event,
                                                        eventDate: state
                                                            .bookingData!
                                                            .upcoming![index]
                                                            .startDate,
                                                        eventStatus: state
                                                            .bookingData!
                                                            .upcoming![index]
                                                            .statusLabel,
                                                        widgetRoute: BlocProvider(
                                                            create: (context) =>
                                                                MyEventDetailsBLOC(),
                                                            child: Page),
                                                      );
                                                    }),
                                              )
                                            : Container(),
                                        Container(
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.only(top: 30.0),
                                          child: Text(
                                            'Other Events',
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                        ),
                                        state.bookingData!.other!.length > 0
                                            ? Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.50,
                                                child: ListView.builder(
                                                  padding: EdgeInsets.only(
                                                      top: 20.0,
                                                      left: 10.0,
                                                      right: 10),
                                                  itemCount: state.bookingData!
                                                      .other!.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    final Page;
                                                    if (state
                                                            .bookingData!
                                                            .other![index]
                                                            .bookingStatus ==
                                                        'confirmed') {
                                                      Page = MyEventDetailsPage(
                                                        reference: state
                                                            .bookingData!.other!
                                                            .elementAt(index)
                                                            .reference,
                                                      );
                                                    } else {
                                                      Page =
                                                          MyEventCancelledPage(
                                                        reference: state
                                                            .bookingData!.other!
                                                            .elementAt(index)
                                                            .reference,
                                                      );
                                                    }
                                                    return EventCellWidget(
                                                      eventPoster: state
                                                          .bookingData!
                                                          .other![index]
                                                          .eventBanner,
                                                      eventName: state
                                                          .bookingData!
                                                          .other![index]
                                                          .event,
                                                      eventDate: state
                                                          .bookingData!
                                                          .other![index]
                                                          .startDate,
                                                      eventStatus: state
                                                          .bookingData!
                                                          .other![index]
                                                          .statusLabel,
                                                      widgetRoute: BlocProvider(
                                                          create: (context) =>
                                                              MyEventDetailsBLOC(),
                                                          child: Page),
                                                    );
                                                  },
                                                ),
                                              )
                                            : Container(),
                                        Container(
                                          height: 40,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              } else if (state is ProfileNetworkEvent) {
                return Center(
                  child: CanineText(
                    text: "Something went wrong.Please try again!",
                    color: CanineColors.Primary,
                  ),
                );
              } else
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
                  builder: (context) =>
                      StatefulBuilder(
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
                isEnabled = true;
              });
            } else {
              try {
                bottomSheet!.close();
                setState(() {
                  isOpen == false ? isOpen = true : isOpen = false;
                  isEnabled = true;
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
                  isEnabled = true;
                });
              } finally {
                setState(() {
                  isOpen == false ? isOpen = true : isOpen = false;
                  isEnabled = true;
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
      isEnabled = true;
    });
  }

  void logoutDialog(BuildContext context, ProfileBloc blocBuilder) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) =>
          AlertDialog(
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
                    text: "Are you sure you want to logout?",
                    fontSize: 18.0,
                    maxLines: 2,
                  ),
                ),
                BlocBuilder(
                  bloc: blocBuilder,
                  builder: (context, state) {
                    /*if(state is ProfileLogout)
                  {
                    return Progress();
                  }*/
                    return Container(
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
                              logOut(context);
                              setState(() {
                                this.isLogoutEnabled = true;
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
                              if (!isLogoutEnabled) {
                                Navigator.pop(context);
                              }
                            },
                          ),

                        ],
                      ),
                    );
                  },
                )
              ],
            ),
          ),
    );
  }

  Future logOut(BuildContext context) async {
    final pref = await Shared().getSharedStorage();
    final db = await LocalDB().getLocalDB();
    db.deleteAllBookings();
    pref.clear();
    await pref.setBool("isNew", false);
    await StaticDataRepo().getData();
    /* final response = await Http().post(
        "", Urls.logout, pref.get("refresh_token"), ContentType.urlEncode);
    final responseBody = jsonDecode(response.body);*/
    Navigator.pop(context);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                BlocProvider(
                    create: (context) => LoginBLOC(),
                    child: LoginPage(
                      widgetRoute: BlocProvider(
                          create: (context) => ProfileBloc(),
                          child: ProfilePage()),
                    ))));

    /*if (responseBody['status'] == true) {
      final db = await LocalDB().getLocalDB();
      db.deleteAllBookings();
      pref.clear();
      await pref.setBool("isNew", false);
      await StaticDataRepo().getData();
      Navigator.pop(context);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => BlocProvider(
                  create: (context) => LoginBLOC(),
                  child: LoginPage(
                    widgetRoute: BlocProvider(
                        create: (context) => ProfileBloc(),
                        child: ProfilePage()),
                  ))));
      print(responseBody);
    } else {
      Navigator.pop(context);
      CanineSnackBar.show(context,"Logout failed");
    }*/
    return true;
  }
}
