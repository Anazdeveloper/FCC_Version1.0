import 'package:first_class_canine_demo/Screens/ChangePassword/ChangePasswordBLOC.dart';
import 'package:first_class_canine_demo/Screens/ChangePassword/ChangePasswordPage.dart';
import 'package:first_class_canine_demo/UIComponents/CanineStyle.dart';
import 'package:first_class_canine_demo/UIComponents/CanineText.dart';
import 'package:first_class_canine_demo/UIComponents/CanineTextUnderLined.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserProfile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UserProfileState();
  }
}

class UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 600,
        color: Colors.black,
        child: Container(
          margin: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 1,
                    fit: FlexFit.loose,
                    child: Container(
                      child: CanineText(
                        color: CanineColors.textColor,
                        text: "Name",
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 4,
                    child: Container(
                      child: CanineTextUnderLined(
                        label: "",
                      ),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 1,
                    fit: FlexFit.loose,
                    child: Container(
                      child: CanineText(
                        color: CanineColors.textColor,
                        text: "Email id",
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 4,
                    child: Container(
                      child: CanineTextUnderLined(
                        label: "",
                      ),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 1,
                    fit: FlexFit.loose,
                    child: Container(
                      child: CanineText(
                        color: CanineColors.textColor,
                        text: "Mobile no",
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 4,
                    child: Container(
                      child: CanineTextUnderLined(
                        label: "",
                      ),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 1,
                    fit: FlexFit.loose,
                    child: Container(
                      child: CanineText(
                        color: CanineColors.textColor,
                        text: "Password",
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 4,
                    child: Container(
                      child: CanineTextUnderLined(
                        label: "",
                      ),
                    ),
                  )
                ],
              ),
              Container(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider(
                                create: (context) => ChangePasswordBLOC(),
                                child: ChangePasswordPage(),
                              ),
                            ));
                      },
                      child: CanineText(
                          text: 'Change Password', color: Colors.white))),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 1,
                    fit: FlexFit.loose,
                    child: Container(
                      child: CanineText(
                        color: CanineColors.textColor,
                        text: "Name",
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 4,
                    child: Container(
                      child: CanineTextUnderLined(
                        label: "",
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
