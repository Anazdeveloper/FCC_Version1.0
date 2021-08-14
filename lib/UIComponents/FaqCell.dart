import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FaqCell extends StatelessWidget {
  final String ? question;
  final String ? answer;

  FaqCell(this.question,this.answer);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(top: 30.0, left: 40.0, right: 40.0),
          alignment: Alignment.centerLeft,
          child: Text(question!,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.width * 0.04
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 5.0,left: 40.0, right: 40.0),
          alignment: Alignment.centerLeft,
          child: Text(answer!,
            style: TextStyle(
              color: Colors.grey,
              fontSize: MediaQuery.of(context).size.width * 0.04,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 20.0,left: 20.0,right: 20.0),
          child: Divider(
            color: Colors.white,
            thickness: 1.0,
          ),
        )
      ],
    );
  }
}