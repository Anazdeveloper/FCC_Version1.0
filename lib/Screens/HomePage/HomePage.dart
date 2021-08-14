import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';

// ignore: import_of_legacy_library_into_null_safe
import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:first_class_canine_demo/Modal/EventListModal.dart';
import 'package:first_class_canine_demo/Repo/Repo.dart';
import 'package:first_class_canine_demo/Screens/EventListingPage/EventListingBloc.dart';
import 'package:first_class_canine_demo/Screens/EventListingPage/EventListingPage.dart';
import 'package:first_class_canine_demo/Screens/HomePage/HomeBloc.dart';
import 'package:first_class_canine_demo/Screens/ShowEvent/ShowEvent.dart';
import 'package:first_class_canine_demo/Screens/ShowEvent/ShowEventBLOC.dart';
import 'package:first_class_canine_demo/Service/Api.dart';
import 'package:first_class_canine_demo/Service/ConnectivityCheck.dart';
import 'package:first_class_canine_demo/Service/Urls.dart';
import 'package:first_class_canine_demo/Storage/Pref/Shared.dart';
import 'package:first_class_canine_demo/UIComponents/BottomNavigation.dart';
import 'package:first_class_canine_demo/UIComponents/BottomSheet/CanineBottomSheet.dart';
import 'package:first_class_canine_demo/UIComponents/CanineStyle.dart';
import 'package:first_class_canine_demo/UIComponents/Progress.dart';
import 'package:first_class_canine_demo/UIComponents/UIComponents/TopSnackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  StreamSubscription? subscription;
  bool isOpen = false;
  int listCount = 0;
  bool isEnabled = false;
  final formKey = GlobalKey<FormState>();
  DateTime? duration;
  PersistentBottomSheetController? bottomSheet;
  final bottomSheetKey = GlobalKey<ScaffoldState>();

  @override
  List<Widget> getImageCards(List<EventData> eventData) {
    print("Eventdata:${eventData}");
    for (final event in eventData) {
      posterList.add(event.bannerPath);
      slug.add(event.slug);
    }

    listCount = posterList.length;

    if (posterList.isNotEmpty) {
      for (var i = 0; i < listCount; i++) {
        posterImageCardList.add(
          Container(
            width: MediaQuery.of(context).size.width * 0.85,
            child: GestureDetector(
              onTap: () {
                try {

                  ConnectivityCheck().getConnectionState().then((value) {
                    if (value) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BlocProvider(
                                  create: (context) => ShowEventBLOC(),
                                  child: ShowEvent(
                                    slug: slug[i],
                                  ))));
                    }
                  });

                } catch (e) {
                  print(e);
                } finally {
                  setState(() {});
                }
              },
              child: Card(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network('${Urls.imageurl + posterList[i].toString()}',
                        alignment: Alignment.center,
                        fit: BoxFit.fill, loadingBuilder: (BuildContext context,
                            Widget child, ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    } else {
      print('Empty List');
    }
    return posterImageCardList;
  }

  @override
  void initState() {
    super.initState();
    subscription = Connectivity().onConnectivityChanged.listen((event) {
      event.index == 2 ? TopSnackBar.show() : Container();
    });
    ConnectivityCheck().checkNetwork();
  }

  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    int _currentIndex = 0;
    //posterList.clear();
    print("postrlist1${posterList.length}");
    final blocBuilder = BlocProvider.of<HomeBloc>(context);
    if (!isEnabled) blocBuilder.add(HomeUiLoadedEvent());
    return SafeArea(
      child: Scaffold(
        key: bottomSheetKey,
        body: WillPopScope(
          onWillPop: doubleBack,
          child: Padding(
            padding: EdgeInsets.all(0.0),
            child: Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage("assets/images/background.png")),
              ),
              child: ListView(
                children: [
                  Container(
                      padding: EdgeInsets.only(top: 10.0),
                      alignment: Alignment.topCenter,
                      child: Image.asset(
                        "assets/images/logo.webp",
                        height: 150,
                      )),
                  Container(
                    margin: EdgeInsets.only(
                        top: 10.0, bottom: 5.0, left: 15.0, right: 15.0),
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      "Welcome to First Class Canine Services the innovated way to purchase a booth for one of our upcoming Dog Shows.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 20.0),
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        ConnectivityCheck().getConnectionState().then((value) {
                          if (value) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BlocProvider(
                                      create: (context) => EventListingBloc(),
                                      child: EventListingPage(),
                                    )));
                          }
                        });

                      },
                      child: Text(
                        'View All Events',
                        style: TextStyle(
                            color: CanineColors.buttonColorPrimary,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  ),
                  SafeArea(
                    child: BlocBuilder(
                      bloc: blocBuilder,
                      builder: (context, state) {
                        if (state is HomeDataLoaded) {
                          return Container(
                            padding: EdgeInsets.only(left: 10.0, right: 10.0),
                            alignment: Alignment.topCenter,
                            child: CarouselSlider(
                              options: CarouselOptions(
                                height:
                                    MediaQuery.of(context).size.height * 0.55,
                                autoPlay: false,
                                aspectRatio: 2.0,
                                enlargeCenterPage: true,
                                enlargeStrategy:
                                    CenterPageEnlargeStrategy.height,
                                // onPageChanged: (index, reason) {
                                //   setState(() {
                                //     _currentIndex = index;
                                //   });
                                // }
                              ),
                              items: getImageCards(state.data),
                            ),
                          );
                        }
                        return Progress();
                      },
                    ),
                  ),
                ],
              ),
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
      if (bottomSheet == null) {
        isOpen = false;
      } else {
        try {
          bottomSheet!.close();
        } catch (e) {
          print(e);
        } finally {
          setState(() {});
        }
      }
    }
    setState(() {
      isOpen == false ? isOpen = true : isOpen = false;
      isEnabled = true;
    });
  }

  Future<bool> doubleBack() {
    DateTime now = DateTime.now();
    if (isOpen == false) {
      if (duration == null ||
          now.difference(duration!) > Duration(seconds: 2)) {
        duration = now;
        Fluttertoast.showToast(msg: "Press again to exit");
        return Future.value(false);
      } else {
        //Navigator.popUntil(context, ModalRoute.withName('/home'));
        exit(0);
        return Future.value(true);
      }
    } else {
      Navigator.pop(context);
      setState(() {
        isOpen == false ? isOpen = true : isOpen = false;
      });
      return Future.value(false);
    }
  }
}

void fetchToken() async {
  final pref = await Shared().getSharedStorage();
  String token;
}

List<String> posterList = [];

List<String> slug = [];
List<Widget> posterImageCardList = [];

Future<List<EventData>> getEventList() async {
  final pref = await Shared().getSharedStorage();
  if (!pref.containsKey("app_token") && pref.get("app_token") == null) {
    print("no token");
    await AppToken().getData();
  }

  print("usertoken:${pref.get('app_token')}");
  final http.Response response = await Http()
      .get(Urls.eventlist, pref.get('app_token'), ContentType.urlEncode);
  print("Response:${response}");
  print("Status:${response.statusCode}");
  final events = EventList.fromJson(jsonDecode(response.body));
  print("response:${events.data.length}");
  return events.data;
}
