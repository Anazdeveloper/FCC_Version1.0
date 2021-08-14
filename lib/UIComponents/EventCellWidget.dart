import 'package:first_class_canine_demo/Service/ConnectivityCheck.dart';
import 'package:first_class_canine_demo/Service/Urls.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventCellWidget extends StatelessWidget {
  final String? eventPoster;
  final String? eventName;
  final DateTime? eventDate;
  final String? eventStatus;
  final bool? attended;
  final bool? eventData;
  final String? eventSlug;
  final dynamic? widgetRoute;

  EventCellWidget(
      {this.eventPoster,
      this.eventName,
      this.eventDate,
      this.eventStatus,
      this.attended,
      this.eventData = false,
      this.eventSlug,
      this.widgetRoute});

  @override
  Widget build(BuildContext context) {
    final date = DateFormat.yMMMd().format(eventDate!);
    return GestureDetector(
      onTap: () {
        ConnectivityCheck().getConnectionState().then((value) {
          if (value) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => widgetRoute,
                ));
          }
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 15.0),
        child: Container(
          height: 80.0,
          width: MediaQuery.of(context).size.width * 0.95,
          decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(width: 2.0, color: Colors.white),
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(12.0),
                  bottomRight: Radius.circular(12.0))),
          child: Stack(
            children: <Widget>[
              eventPoster != null && eventPoster!.isNotEmpty
                  ? Image.network(
                      Urls.imageurl + eventPoster!,
                      alignment: Alignment.topLeft,
                      height: 80.0,
                      width: 80.0,
                      fit: BoxFit.fill,
                    )
                  : Container(),
              Container(
                  padding: EdgeInsets.only(top: 25.0, left: 92.0, right: 10.0),
                  alignment: Alignment.topLeft,
                  child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        eventName!,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ))),
              Container(
                padding: EdgeInsets.only(top: 35.0, left: 92.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  date,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 5.0, right: 5.0),
                alignment: Alignment.topRight,
                child: Text(
                  eventStatus ?? '',
                  style: TextStyle(color: Colors.grey),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
