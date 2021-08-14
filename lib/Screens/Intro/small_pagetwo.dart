import 'package:first_class_canine_demo/Service/ScreenSizeConfig.dart';
import 'package:first_class_canine_demo/UIComponents/CanineStyle.dart';
import 'package:first_class_canine_demo/UIComponents/CanineText.dart';
import 'package:flutter/cupertino.dart';

class sPageTwo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxHeight <= 600) {
          return screen(context, ScreenSize600.logo_logo);
        }
        return screen(context, ScreenSize800.logo_logo);
      },
    );
  }

  Widget screen(BuildContext context, double logoSize) {
    return Container(
        child: Column(
      children: [
        Container(
          child: ClipRRect(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(180.0),
                  bottomRight: Radius.circular(20)),
              child: Image.asset(
                "assets/images/OnBoardingImages/pic_2.webp",
                fit: BoxFit.fitWidth,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2,
              )),
        ),
        Container(
          margin: EdgeInsets.only(top: 2.0),
          child: Image.asset(
            "assets/images/logo.webp",
            height: logoSize,
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 2.0),
          child: Text(
            "Fun Dog Shows",
            style: TextStyle(
              color: CanineColors.textColor,
              fontSize: 25.0,
              fontFamily: CanineFonts.Rye,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 5.0),
          child: CanineText(
            color: CanineColors.textColor,
            text:
                "Welcome to First Class Canine Services\n the innovated way to purchase a booth\n for one of our upcoming Dog Shows",
            maxLines: 3,
            textAlign: TextAlign.center,
            fontSize: 14.0,
            fontFamily: CanineFonts.Aleo,
          ),
        ),
      ],
    ));
  }
}
