import 'package:first_class_canine_demo/Screens/EventListingPage/EventListingBloc.dart';
import 'package:first_class_canine_demo/Screens/ShowEvent/ShowEvent.dart';
import 'package:first_class_canine_demo/Screens/ShowEvent/ShowEventBLOC.dart';
import 'package:first_class_canine_demo/Service/ConnectivityCheck.dart';
import 'package:first_class_canine_demo/UIComponents/CanineStyle.dart';
import 'package:first_class_canine_demo/UIComponents/EventCellWidget.dart';
import 'package:first_class_canine_demo/UIComponents/Progress.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventListingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return EventListingPageState();
  }
}

class EventListingPageState extends State<EventListingPage> {
  @override
  void initState() {
    super.initState();
    ConnectivityCheck().checkNetwork();
  }

  @override
  Widget build(BuildContext context) {
    final blocBuilder = BlocProvider.of<EventListingBloc>(context);
    blocBuilder.add(EventListingUiLoadedEvent());
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.black,
            centerTitle: true,
            title: Image.asset(
              "assets/images/logo.webp",
              height: 80.0,
            ),
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            )),
        body: BlocBuilder(
          bloc: blocBuilder,
          builder: (context, state) {
            if (state is DataLoaded) {
              return Container(
                color: Colors.black,
                child: ListView(
                  children: <Widget>[
                    Divider(color: Colors.white, thickness: 2.0),
                    DefaultTabController(
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
                                  text: 'Upcoming Events',
                                ),
                                Tab(
                                  text: 'Past Events',
                                )
                              ],
                            ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.80,
                            decoration: BoxDecoration(
                              border: Border(
                                top:
                                    BorderSide(color: Colors.white, width: 2.0),
                              ),
                            ),
                            child: TabBarView(
                              children: <Widget>[
                                //Contents of Upcoming Events Tab
                                Container(
                                  padding: EdgeInsets.only(
                                      top: 28.0, left: 10.0, right: 10.0),
                                  child: ListView.builder(
                                    itemCount: state.upcomingData.length,
                                    itemBuilder: (context, index) {
                                      return EventCellWidget(
                                        eventPoster: state
                                            .upcomingData[index].bannerPath,
                                        eventName:
                                            state.upcomingData[index].title,
                                        eventDate:
                                            state.upcomingData[index].startDate,
                                        eventSlug:
                                            state.upcomingData[index].slug,
                                        widgetRoute: BlocProvider(
                                          create: (context) => ShowEventBLOC(),
                                          child: ShowEvent(
                                            slug:
                                                state.upcomingData[index].slug,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),

                                //Contents of Past Events Tab
                                Container(
                                  padding: EdgeInsets.only(
                                      top: 28.0, left: 10.0, right: 10.0),
                                  child: ListView.builder(
                                    itemCount: state.pastData.length,
                                    itemBuilder: (context, index) {
                                      return EventCellWidget(
                                        eventPoster:
                                            state.pastData[index].bannerPath,
                                        eventName: state.pastData[index].title,
                                        eventDate:
                                            state.pastData[index].startDate,
                                        eventSlug: state.pastData[index].slug,
                                        widgetRoute: BlocProvider(
                                          create: (context) => ShowEventBLOC(),
                                          child: ShowEvent(
                                            slug: state.pastData[index].slug,
                                            pastEvent: true,
                                          ),
                                        ),
                                      );
                                    },
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
            }
            return Progress();
          },
        ),
      ),
    );
  }
}
