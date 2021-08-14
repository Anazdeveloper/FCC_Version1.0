import 'package:first_class_canine_demo/Screens/ForgotPassword/ForgetPageBLOC.dart';
import 'package:first_class_canine_demo/Screens/Login/LoginBLOC.dart';
import 'package:first_class_canine_demo/Screens/Login/LoginPage.dart';
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

class ForgetPasswordPage extends StatefulWidget {
  final dynamic? widgetRoute;

  ForgetPasswordPage({this.widgetRoute});

  @override
  State<StatefulWidget> createState() {
    return ForgetPasswordState();
  }
}

class ForgetPasswordState extends State<ForgetPasswordPage> {
  bool isSend = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  TextEditingController npasswordController = TextEditingController();
  TextEditingController cpasswordController = TextEditingController();
  String? email;
  bool eyeButton_c = true;
  bool eyeButton_n = true;
  final formKey = GlobalKey<FormState>();
  final popupFormKey = GlobalKey<FormState>();
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
    final blocProvider = BlocProvider.of<ForgetPageBLOC>(context);
    return SafeArea(
        child: GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.black,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              onBack();
            },
          ),
          title: CanineText(
            text: "Forgot Password",
            fontFamily: CanineFonts.Aleo,
            color: Colors.white,
          ),
          centerTitle: true,
        ),
        body: WillPopScope(
          onWillPop: ()async{
            onBack();
            return false;
          },
          child: SingleChildScrollView(
            child: BlocListener(
              bloc: blocProvider,
              listener: (context, state) {
                if (state is ForgetPasswordInlineErrorState) {
                  setState(() {
                    isError = state.status;
                    message = state.message;
                    field = state.field;
                  });
                }
                if (state is ResetSuccessful) {
                  CanineSnackBar.show(
                      context, "Your password has been reset successfully");
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BlocProvider(
                                create: (context) => LoginBLOC(),
                                child: LoginPage(
                                  widgetRoute: widget.widgetRoute,
                                ),
                              )));
                  // messageDialog(context,"Your password has been reset successfully");
                }
                if (state is ForgetPasswordErrorState) {
                  CanineSnackBar.show(context, state.message);
                }
                if (state is PasswordChangeSuccessful) {
                  CanineSnackBar.show(context, "Successful");
                }
                if (state is PasswordChangeOtp) {
                  setState(() {
                    isSend = true;
                    isError = false;
                  });
                  CanineSnackBar.show(context, state.message);
                }
              },
              child: Container(
                margin: EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CanineTextUnderLined(
                          controller: emailController,
                          showEyeButton: false,
                          tag: "none",
                          isBackendMessage:
                              field['email'] != null ? isError : false,
                          message: isError == true
                              ? field['email'] != null
                                  ? field['email'][0]
                                  : ""
                              : "",
                          label: "Enter Email id",
                        ),
                        BlocBuilder(
                          bloc: blocProvider,
                          builder: (context, state) {
                            if (state is ForgetPasswordInputIsProcessing) {
                              return Progress();
                            }
                            return isSend
                                ? Container(
                                    margin: EdgeInsets.symmetric(vertical: 25.0),
                                    child: Column(
                                      children: [
                                        CanineButton(
                                          color: CanineColors.transparentcolor,
                                          text: "",
                                          fontSize: 14.0,
                                          buttonWidth: 200.0,
                                          textWidget: false,
                                          callback: () {
                                            setState(() {});
                                          },
                                        ),
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 10.0),
                                          child: TextButton(
                                            onPressed: () {
                                              FocusScope.of(context).unfocus();
                                              if (formKey.currentState!
                                                  .validate()) {
                                                blocProvider.add(InputEvent(
                                                    inputEmail:
                                                        emailController.text));
                                              }
                                            },
                                            child: CanineText(
                                              text:
                                                  "Didn't receive the code? Resend",
                                              color: CanineColors.textColor,
                                              fontSize: 14.0,
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                          ),
                                        ),
                                        popupView(
                                            blocProvider,
                                            npasswordController,
                                            cpasswordController,
                                            otpController,
                                            popupFormKey)
                                      ],
                                    ))
                                : BlocBuilder(
                                    bloc: blocProvider,
                                    builder: (context, state) {
                                      if (state
                                          is ForgetPasswordInputEventIsProcessing) {
                                        return Progress();
                                      }
                                      return Container(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 25.0),
                                        child: CanineButton(
                                          text: "Send Verification Code",
                                          color: CanineColors.transparentcolor,
                                          fontSize: 14.0,
                                          buttonWidth: 250.0,
                                          callback: () {
                                            FocusScope.of(context).unfocus();
                                            if (formKey.currentState!
                                                .validate()) {
                                              ConnectivityCheck().getConnectionState().then((value){
                                                if(value){
                                                  blocProvider.add(InputEvent(
                                                      inputEmail:
                                                      emailController.text));
                                                }});

                                            }
                                          },
                                        ),
                                      );
                                    },
                                  );
                          },
                        ),
                      ]),
                ),
              ),
            ),
          ),
        ),
      ),
    ));
  }

  Widget popupView(
      ForgetPageBLOC blocProvider,
      TextEditingController npasswordController,
      TextEditingController cpasswordController,
      TextEditingController otpController,
      GlobalKey<FormState> popupFormKey) {
    return Form(
      key: popupFormKey,
      child: Column(
        children: [
          Container(
              margin: EdgeInsets.symmetric(vertical: 25.0),
              child: CanineTextUnderLined(
                tag: "none",
                isBackendMessage: field['otp'] != null ? isError : false,
                message: isError == true
                    ? field['otp'] != null
                        ? field['otp'][0]
                        : ""
                    : "",
                controller: otpController,
                label: "Enter Validation code *",
                showEyeButton: false,
              )),
          Container(
              margin: EdgeInsets.symmetric(vertical: 25.0),
              child: CanineTextUnderLined(
                eyeButton: eyeButton_n,
                label: "New Password *",
                isBackendMessage: field['password'] != null ? isError : false,
                message: isError == true
                    ? field['password'] != null
                        ? field['password'][0]
                        : ""
                    : "",
                controller: npasswordController,
                type: CaninePasswordType.NewPassword,
                tag: "none",
                callback: () {
                  setState(() {
                    eyeButton_n = !eyeButton_n;
                  });
                },
              )),
          Container(
              margin: EdgeInsets.symmetric(vertical: 25.0),
              child: CanineTextUnderLined(
                eyeButton: eyeButton_c,
                new_password_controller: npasswordController,
                controller: cpasswordController,
                type: CaninePasswordType.ConfirmPassword,
                tag: "none",
                isBackendMessage:
                    field['confirm_password'] != null ? isError : false,
                message: isError == true
                    ? field['confirm_password'] != null
                        ? field['confirm_password'][0]
                        : ""
                    : "",
                label: "Confirm New Password *",
                callback: () {
                  setState(() {
                    eyeButton_c = !eyeButton_c;
                  });
                },
              )),
          BlocBuilder(
              bloc: blocProvider,
              builder: (context, state) {
                print("state is $state");
                if (state is ForgetPasswordInputEventIsProcessing) {
                  return Progress();
                }
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 25.0),
                  child: CanineButton(
                    text: "Save Changes",
                    color: CanineColors.transparentcolor,
                    fontSize: 14.0,
                    callback: () {
                      FocusScope.of(context).unfocus();
                      if (popupFormKey.currentState!.validate()) {
                        ConnectivityCheck().getConnectionState().then((value){
                          if(value){
                            blocProvider.add(ResetEvent(
                                inputEmail: emailController.text,
                                npassword: npasswordController.text,
                                cpassword: cpasswordController.text,
                                otp: otpController.text));
                          }});

                      }
                    },
                  ),
                );
              }),
        ],
      ),
    );
  }

  onBack()
  {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => BlocProvider(
                create: (context) => LoginBLOC(),
                child: LoginPage(
                  widgetRoute: widget.widgetRoute,
                ))));
  }

  messageDialog(BuildContext dcontext, String message) {
    showDialog(
      barrierDismissible: false,
      context: dcontext,
      builder: (context) => WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Dialog(
          child: Container(
            padding: EdgeInsets.all(10.0),
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.pop(dcontext);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                      create: (context) => LoginBLOC(),
                                      child: LoginPage(
                                        widgetRoute: widget.widgetRoute,
                                      ),
                                    )));
                      }),
                ),
                Container(
                    child: Icon(
                  Icons.done_all,
                  color: Colors.green,
                  size: 50.0,
                )),
                Container(
                  alignment: Alignment.center,
                  child: CanineText(
                    text: "Your password has been reset \n successfully",
                    maxLines: 2,
                    fontSize: 20.0,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
