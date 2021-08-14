import 'package:first_class_canine_demo/Modal/EventListModal.dart';
import 'package:first_class_canine_demo/Modal/ShowEventModal.dart';
import 'package:first_class_canine_demo/Service/Urls.dart';
import 'package:first_class_canine_demo/UIComponents/CanineButton.dart';
import 'package:first_class_canine_demo/UIComponents/CanineStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BookingConfirmationPage extends StatefulWidget {
  final EventDetails ? eventDetails;

  BookingConfirmationPage({this.eventDetails});

  State<StatefulWidget> createState() {
    return BookingConfirmationPageState();
  }
}

class BookingConfirmationPageState extends State<BookingConfirmationPage> {
  late int idx = widget.eventDetails!.data!.startDate.toString().indexOf(" ");
  late var date = widget.eventDetails!.data!.startDate.toString().substring(0, idx).trim();
  late var time = widget.eventDetails!.data!.startDate.toString().substring(idx).trim();

  @override
  void initState() {
    super.initState();
    idx = widget.eventDetails!.data!.startDate.toString().indexOf(" ");
    date = widget.eventDetails!.data!.startDate.toString().substring(0, idx).trim();
    time = widget.eventDetails!.data!.startDate.toString().substring(idx).trim();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
            backgroundColor: Colors.black,
            title: Container(
              alignment: Alignment.center,
              child: Text(
                'Confirmation',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
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
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                  width: 2.0, color: CanineColors.buttonColorPrimary),
            ),
            child: Column(
              children: <Widget>[
                Container(
                  child: Image.network(
                    Urls.imageurl + widget.eventDetails!.data!.bannerPath.toString(),
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.fill,
                  ),
                  height: MediaQuery.of(context).size.height * 0.30,
                  width: MediaQuery.of(context).size.width,
                ),
                Container(
                  padding: EdgeInsets.only(top: 20.0, left: 20.0),
                  child: Row(
                    children: <Widget>[
                      Image.asset('assets/images/TicIcon.png',
                          height: 20.0, width: 20.0, fit: BoxFit.fill),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          widget.eventDetails!.data!.title!,
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 20.0, left: 20.0),
                  child: Row(
                    children: <Widget>[
                      Image.asset('assets/images/calenderIcon.png',
                          height: 20.0, width: 20.0, fit: BoxFit.fill),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          date,
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 20.0, left: 20.0),
                  child: Row(
                    children: <Widget>[
                      Image.asset('assets/images/ClockIcon.png',
                          height: 20.0, width: 20.0, fit: BoxFit.fill),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          time,
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 20.0, left: 20.0),
                  child: Row(
                    children: <Widget>[
                      Image.asset('assets/images/locationIcon.png',
                          height: 20.0, width: 20.0, fit: BoxFit.fill),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0,),
                          child: Text(
                            widget.eventDetails!.data!.address!,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      'Each booth comes with 2 wristbands and 4 dogs',
                      style: TextStyle(color: Colors.grey),
                    )),
                Container(
                  padding: EdgeInsets.only(top: 20.0, left: 20.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        'Kennel Name-',
                        style: TextStyle(color: Colors.white),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 40.0),
                        child: Text(
                          'Dogventure',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 20.0, left: 20.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        'Booking Name-',
                        style: TextStyle(color: Colors.white),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 40.0),
                        child: Text(
                          '',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 20.0, left: 20.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        'Email Id-',
                        style: TextStyle(color: Colors.white),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 40.0),
                        child: Text(
                          '',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, left: 20.0),
                  child: Stack(
                    children: <Widget>[
                      Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Booth Booked',
                            style: TextStyle(color: Colors.grey),
                          )),
                      Container(
                          alignment: Alignment.topRight,
                          padding: EdgeInsets.only(right: 10.0),
                          child: Text(
                            'Price',
                            style: TextStyle(color: Colors.grey),
                          )),
                      Container(
                          padding: EdgeInsets.only(top: 10.0, right: 10.0),
                          child: Divider(
                            color: Colors.white,
                            thickness: 1.5,
                          ))
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, left: 20.0),
                  child: Stack(
                    children: <Widget>[
                      Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Booth no. 54 (Regular Booth)',
                            style: TextStyle(color: Colors.white),
                          )),
                      Container(
                          alignment: Alignment.topRight,
                          padding: EdgeInsets.only(right: 10.0),
                          child: Text(
                            '100',
                            style: TextStyle(color: Colors.white),
                          )),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, left: 20.0),
                  child: Stack(
                    children: <Widget>[
                      Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Additional Pets  - 0',
                            style: TextStyle(color: Colors.white),
                          )),
                      Container(
                          alignment: Alignment.topRight,
                          padding: EdgeInsets.only(right: 10.0),
                          child: Text(
                            '0',
                            style: TextStyle(color: Colors.white),
                          )),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, left: 20.0),
                  child: Stack(
                    children: <Widget>[
                      Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Booth no. 48 (Ringside Booth)',
                            style: TextStyle(color: Colors.white),
                          )),
                      Container(
                          alignment: Alignment.topRight,
                          padding: EdgeInsets.only(right: 10.0),
                          child: Text(
                            '150',
                            style: TextStyle(color: Colors.white),
                          )),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, left: 20.0),
                  child: Stack(
                    children: <Widget>[
                      Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Additional Pets  - 1',
                            style: TextStyle(color: Colors.white),
                          )),
                      Container(
                          alignment: Alignment.topRight,
                          padding: EdgeInsets.only(right: 10.0),
                          child: Text(
                            '10',
                            style: TextStyle(color: Colors.white),
                          )),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, left: 20.0),
                  child: Stack(
                    children: <Widget>[
                      Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Total Amount',
                            style: TextStyle(color: Colors.white),
                          )),
                      Container(
                          alignment: Alignment.topRight,
                          padding: EdgeInsets.only(right: 10.0),
                          child: Text(
                            '260',
                            style: TextStyle(color: Colors.white),
                          )),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                  child: CanineButton(
                    text: 'Proceed to pay',
                    color: CanineColors.transparentcolor,
                    borderRadius: 2.0,
                    buttonWidth: 220.0,
                    buttonHeight: 60.0,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}