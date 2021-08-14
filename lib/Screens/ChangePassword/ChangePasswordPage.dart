import 'package:first_class_canine_demo/Screens/ChangePassword/ChangePasswordBLOC.dart';
import 'package:first_class_canine_demo/Screens/ProfilePage/ProfilePage.dart';
import 'package:first_class_canine_demo/Screens/ProfilePage/ProfilePageBloc.dart';
import 'package:first_class_canine_demo/Service/ConnectivityCheck.dart';
import 'package:first_class_canine_demo/UIComponents/CanineButton.dart';
import 'package:first_class_canine_demo/UIComponents/CanineStyle.dart';
import 'package:first_class_canine_demo/UIComponents/CanineText.dart';
import 'package:first_class_canine_demo/UIComponents/CanineTextUnderLined.dart';
import 'package:first_class_canine_demo/UIComponents/Progress.dart';
import 'package:first_class_canine_demo/UIComponents/UIComponents/CanineSnackBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ChangePasswordState();
  }
}

class ChangePasswordState extends State<ChangePasswordPage> {
  final formKey = GlobalKey<FormState>();
  bool eyeButton = true;
  bool eyeButton_c = true;
  bool eyeButton_n = true;

  TextEditingController old_password = TextEditingController();
  TextEditingController new_password = TextEditingController();
  TextEditingController confirm_password = TextEditingController();
  bool isError = false;
  String message = "";
  Map<String, dynamic> field = {};

  @override
  void initState() {
    super.initState();
    ConnectivityCheck().checkNetwork();
  }

  @override
  Widget build(BuildContext context) {
    final blocProvider = BlocProvider.of<ChangePasswordBLOC>(context);
    return SafeArea(
        child: GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.black,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: CanineText(
            text: "Change Password",
            fontFamily: CanineFonts.Aleo,
            color: Colors.white,
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(color: Colors.black),
            child: Container(
              margin: EdgeInsets.all(20.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 15.0),
                      child: CanineTextUnderLined(
                        tag: "",
                        type: CaninePasswordType.OldPassword,
                        controller: old_password,
                        label: "Current Password *",
                        isBackendMessage:
                            field['old_password'] != null ? isError : false,
                        message: isError == true
                            ? field['old_password'] != null
                                ? field['old_password'][0]
                                : ""
                            : "",
                        inputAction: TextInputAction.next,
                        eyeButton: eyeButton,
                        callback: () {
                          setState(() {
                            eyeButton = !eyeButton;
                          });
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 15.0),
                      child: CanineTextUnderLined(
                        tag: "",
                        type: CaninePasswordType.NewPassword,
                        controller: new_password,
                        label: "New Password *",
                        isBackendMessage:
                            field['new_password'] != null ? isError : false,
                        message: isError == true
                            ? field['new_password'] != null
                                ? field['new_password'][0]
                                : ""
                            : "",
                        inputAction: TextInputAction.next,
                        eyeButton: eyeButton_n,
                        callback: () {
                          setState(() {
                            eyeButton_n = !eyeButton_n;
                          });
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 15.0),
                      child: CanineTextUnderLined(
                        controller: confirm_password,
                        type: CaninePasswordType.ConfirmPassword,
                        tag: "",
                        label: "Confirm New Password *",
                        isBackendMessage:
                            field['confirm_password'] != null ? isError : false,
                        message: isError == true
                            ? field['confirm_password'] != null
                                ? field['confirm_password'][0]
                                : ""
                            : "",
                        inputAction: TextInputAction.done,
                        new_password_controller: new_password,
                        eyeButton: eyeButton_c,
                        callback: () {
                          setState(() {
                            eyeButton_c = !eyeButton_c;
                          });
                        },
                      ),
                    ),
                    BlocListener(
                      bloc: blocProvider,
                      listener: (context, state) {
                        if (state is ChangePasswordInlineErrorState) {
                          setState(() {
                            isError = state.status;
                            message = state.message;
                            field = state.field;
                          });
                        }
                        if (state is PasswordChangeSuccessful) {
                          CanineSnackBar.show(
                              context, "Password changed successfully");
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                    create: (context) => ProfileBloc(),
                                    child: ProfilePage()),
                              ));
                        }
                        if (state is ChangePasswordErrorState) {
                          CanineSnackBar.show(
                              context, state.message.toString());
                        }
                      },
                      child: BlocBuilder(
                        bloc: blocProvider,
                        builder: (context, state) {
                          if (state is ChangePasswordInputIsProcessing) {
                            return Progress();
                          }
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 25.0),
                            child: CanineButton(
                              text: "Save Changes",
                              color: CanineColors.transparentcolor,
                              fontSize: 14.0,
                              buttonWidth: 200.0,
                              callback: () {
                                FocusScope.of(context).unfocus();
                                if (formKey.currentState!.validate()) {
                                  ConnectivityCheck().getConnectionState().then((value){
                                    if(value){
                                      blocProvider.add(ChangePasswordInputEvent({
                                        "old_password": old_password.text,
                                        "new_password": new_password.text,
                                        "confirm_password": confirm_password.text,
                                      }));
                                    }});

                                }
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ));
  }
}
