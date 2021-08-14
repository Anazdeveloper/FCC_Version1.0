import 'package:first_class_canine_demo/Modal/ShowEventModal.dart';
import 'package:first_class_canine_demo/Screens/ForgotPassword/ForgetPageBLOC.dart';
import 'package:first_class_canine_demo/Screens/ForgotPassword/ForgetPasswordPage.dart';
import 'package:first_class_canine_demo/Screens/Register/RegisterBLOC.dart';
import 'package:first_class_canine_demo/Screens/Register/RegisterPage.dart';
import 'package:first_class_canine_demo/Service/ConnectivityCheck.dart';
import 'package:first_class_canine_demo/UIComponents/BottomNavigation.dart';
import 'package:first_class_canine_demo/UIComponents/BottomSheet/CanineBottomSheet.dart';
import 'package:first_class_canine_demo/UIComponents/CanineButton.dart';
import 'package:first_class_canine_demo/UIComponents/CanineOTPTextField.dart';
import 'package:first_class_canine_demo/UIComponents/CaninePasswordField.dart';
import 'package:first_class_canine_demo/UIComponents/CanineStyle.dart';
import 'package:first_class_canine_demo/UIComponents/CanineText.dart';
import 'package:first_class_canine_demo/UIComponents/CanineTextField.dart';
import 'package:first_class_canine_demo/UIComponents/Progress.dart';
import 'package:first_class_canine_demo/UIComponents/UIComponents/CanineSnackBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'LoginBLOC.dart';

class LoginPage extends StatefulWidget {
  final widgetRoute;
  EventDetails? eventData;

  LoginPage({this.widgetRoute, this.eventData});

  @override
  State<StatefulWidget> createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  bool isOpen = false;
  final formKeyLogin = GlobalKey<FormState>();
  bool eyeButton = true;
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController otp = TextEditingController();
  dynamic bottomSheet;
  final bottomSheetKey = GlobalKey<ScaffoldState>();
  DateTime? duration;
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
    final blocprovider = BlocProvider.of<LoginBLOC>(context);
    blocprovider.add(LoginUiLoadedEvent());
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          key: bottomSheetKey,
          extendBodyBehindAppBar: true,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0.0,
            backgroundColor: Colors.transparent,
          ),
          body: WillPopScope(
            onWillPop: () async {
              if (isOpen == false) {
                Navigator.popUntil(context, ModalRoute.withName('/home'));
              }
              return false;
            },
            child: Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage("assets/images/background.png"))),
                child: BlocListener(
                  bloc: blocprovider,
                  listener: (context, state) {
                    if (state is LoginInlineErrorState) {
                      setState(() {
                        isError = state.status;
                        message = state.message;
                        field = state.field;
                      });
                    }
                  },
                  child: SingleChildScrollView(
                      child: Form(
                    key: formKeyLogin,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Image.asset(
                            "assets/images/logo.webp",
                          ),
                          height: 160,
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(5, 0, 5, 30),
                          alignment: Alignment.center,
                          child: Text(
                            "Login to your account to start exploring",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
                          child: CanineTextField(
                            inputAction: TextInputAction.next,
                            prefix: "Email id -",
                            tag: "none",
                            isVerify: false,
                            isBackendMessage:
                                field["username"] != null ? isError : false,
                            message: isError == true
                                ? field['username'] != null
                                    ? field['username'][0]
                                    : ""
                                : "",
                            controller: username,
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
                            child: CaninePasswordField(
                              isVerify: false,
                              isBackendMessage:
                                  field["password"] != null ? isError : false,
                              message: isError == true
                                  ? field['password'] != null
                                      ? field['password'][0]
                                      : ""
                                  : "",
                              eyeButton: eyeButton,
                              controller: password,
                              callback: () {
                                setState(() {
                                  eyeButton = !eyeButton;
                                });
                              },
                            )),
                        Container(
                          margin: EdgeInsets.only(right: 20, bottom: 10),
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BlocProvider(
                                            create: (context) =>
                                                ForgetPageBLOC(),
                                            child: ForgetPasswordPage(
                                              widgetRoute: widget.widgetRoute,
                                            ),
                                          )));
                            },
                            child: CanineText(
                              text: "Forgot Password?",
                              color: CanineColors.textColor,
                              decoration: TextDecoration.underline,
                              fontFamily: CanineFonts.Aleo,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(5, 10, 5, 10),
                          alignment: Alignment.bottomCenter,
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                                text: "Don’t have an account? ",
                                style: TextStyle(
                                  fontFamily: CanineFonts.Aleo,
                                ),
                                children: [
                                  TextSpan(
                                    text: "Sign Up Here",
                                    style: TextStyle(
                                        decoration: TextDecoration.underline),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    BlocProvider(
                                                        child: RegisterPage(
                                                          widgetRoute: widget
                                                              .widgetRoute,
                                                        ),
                                                        create: (context) =>
                                                            RegisterBLOC())));
                                      },
                                  ),
                                ]),
                          ),
                        ),
                        BlocListener(
                          bloc: blocprovider,
                          listener: (context, state) {
                            if (state is LoginSuccessfulVerify) {
                              verifyDialog(context, blocprovider);
                              setState(() {
                                isError=false;
                              });
                            }
                            if (state is LoginSuccessful) {
                              print("WidgetRoute${widget.widgetRoute}");
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          widget.widgetRoute));
                            }
                            if (state is LoginOTPSuccessful) {
                              Navigator.pop(context);
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          widget.widgetRoute));
                            }
                            if (state is LoginErrorState) {
                              CanineSnackBar.show(context, state.message);
                            }
                          },
                          child: BlocBuilder(
                            bloc: blocprovider,
                            builder: (context, state) {
                              if (state is LoginInputIsProcessing) {
                                return Progress();
                              }
                              return Container(
                                margin: EdgeInsets.fromLTRB(5, 10, 5, 10),
                                child: CanineButton(
                                    buttonWidth: 160.0,
                                    color: CanineColors.transparentcolor,
                                    text: "Login",
                                    borderRadius: 10,
                                    callback: () => {
                                          FocusScope.of(context).unfocus(),
                                          if (formKeyLogin.currentState!
                                              .validate())
                                            {
                                            ConnectivityCheck().getConnectionState().then((value){
                                            if(value){
                                              blocprovider.add(InputLoaded({
                                                "username": username.text,
                                                "password": password.text
                                              }));
                                            }})

                                            }
                                        }),
                              );
                            },
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom))
                      ],
                    ),
                  )),
                )),
          ),
          bottomNavigationBar: BottomNavigation(
            isOpen: isOpen,
            open: (context) {
              if (isOpen == false) {
                bottomSheet = showBottomSheet(
                    backgroundColor: Colors.transparent,
                    context: context,
                    builder: (context) => StatefulBuilder(
                          builder: (context, setStateBottomSheet) =>
                              WillPopScope(
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
                });
              } else {
                try {
                  bottomSheet!.close();
                  setState(() {
                    isOpen == false ? isOpen = true : isOpen = false;
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
                  });
                } finally {
                  setState(() {
                    isOpen == false ? isOpen = true : isOpen = false;
                  });
                  isOpen == false ? isOpen = true : isOpen = false;
                }
              }
              //openBottomSheet(context)
            },
          ),
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
      bottomSheet.close();
    }
    setState(() {
      isOpen == false ? isOpen = true : isOpen = false;
    });
  }

  verifyDialog(BuildContext context, LoginBLOC blocprovider) {
    showDialog(
        context: context,
        builder: (context) => WillPopScope(
              onWillPop: () async {
                return true;
              },
              child: Dialog(
                  backgroundColor: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                              icon: Icon(
                                Icons.close,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              top: 10.0, left: 10.0, right: 10.0),
                          child: CanineText(
                            maxLines: 5,
                            textAlign: TextAlign.center,
                            text: "Your account is not activated yet.",
                            color: Colors.red,
                            fontSize: 16.0,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              left: 10.0, right: 10.0, bottom: 10.0),
                          child: CanineText(
                            maxLines: 5,
                            textAlign: TextAlign.center,
                            text:
                                "Enter the OTP verification code which has been sent to your email id.",
                            color: Colors.black87,
                            fontSize: 12.0,
                          ),
                        ),
                        CanineTextFieldOTP(
                          tag: "other",
                          prefix: "OTP",
                          controller: otp,
                          textColor: Colors.black87,
                          borderColor: Colors.black87,
                        ),
                        BlocBuilder(
                            bloc: blocprovider,
                            builder: (context, state) {
                              if (state is LoginOTPErrorState) {
                                return Container(
                                    margin: EdgeInsets.only(top: 10.0),
                                    child: CanineText(
                                      text: state.message,
                                      color: Colors.red,
                                    ));
                              }
                              return Container();
                            }),
                        BlocBuilder(
                          bloc: blocprovider,
                          builder: (context, state) {
                            if (state is LoginOTPInputIsProcessing) {
                              return Progress();
                            }
                            return Container(
                              margin: EdgeInsets.symmetric(vertical: 10.0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  onPrimary: CanineColors.dialogButton,
                                  primary: CanineColors.textColor,
                                  minimumSize: Size(100, 40),
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  shape: const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(25)),
                                      side: BorderSide(
                                          color: CanineColors.dialogButton,
                                          width: 1.0)),
                                ),
                                child: const Text('Verify'),
                                onPressed: () {
                                  FocusScope.of(context).unfocus();
                                  blocprovider.add(VerifyUserEvent(
                                      otp.text, username.text, password.text));
                                },
                              ),
                            );
                          },
                        ),
                        Flexible(
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 10.0),
                            child: Material(
                              color: Colors.white,
                              child: InkWell(
                                splashColor: Colors.blue,
                                onTap: () {
                                  blocprovider.add(LoginOTPResend({
                                    "username": username.text,
                                    "password": password.text
                                  }));
                                },
                                child: CanineText(
                                  text: "Resend",
                                  color: CanineColors.dialogButton,
                                  fontSize: 14.0,
                                  decoration: TextDecoration.underline,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )),
            ));
  }
}
