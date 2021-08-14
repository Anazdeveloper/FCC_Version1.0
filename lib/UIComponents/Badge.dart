import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Badge extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            border:Border.all(
              color: Colors.white
            ),
            borderRadius: BorderRadius.circular(50.0)
          ),
            child: Image.asset('assets/images/cart.png')),
        Positioned(
          top: 0,
            right: 0,
            child: CircleAvatar(
              backgroundColor: Colors.red,
              maxRadius: 6,
            ))
      ],
    );
  }

}
