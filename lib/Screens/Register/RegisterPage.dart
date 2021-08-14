import 'package:first_class_canine_demo/Screens/Bottomsheet/PrivacyPolicy.dart';
import 'package:first_class_canine_demo/Screens/Bottomsheet/TermsAndCoditions.dart';
import 'package:first_class_canine_demo/Screens/Login/LoginBLOC.dart';
import 'package:first_class_canine_demo/Screens/Login/LoginPage.dart';
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
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'RegisterBLOC.dart';

class RegisterPage extends StatefulWidget {
  final widgetRoute;

  RegisterPage({this.widgetRoute});

  @override
  State<StatefulWidget> createState() {
    return RegisterState();
  }
}

class RegisterState extends State<RegisterPage> {
  bool isOpen = false;
  final formKey = GlobalKey<FormState>();
  bool eyeButton = true;
  TextEditingController first_name = TextEditingController();
  TextEditingController mobile_no = TextEditingController();
  TextEditingController email_id = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController otp = TextEditingController();
  dynamic bottomSheet;
  final bottomSheetKey = GlobalKey<ScaffoldState>();
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
    final blocprovider = BlocProvider.of<RegisterBLOC>(context);
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
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BlocProvider(
                            create: (context) => LoginBLOC(),
                            child: LoginPage(
                              widgetRoute: widget.widgetRoute,
                            ))));
              },
              icon: Icon(Icons.arrow_back_ios),
            ),
          ),
          body: WillPopScope(
            onWillPop: () async {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BlocProvider(
                          create: (context) => LoginBLOC(),
                          child: LoginPage(
                            widgetRoute: widget.widgetRoute,
                          ))));
              return false;
            },
            child: Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage("assets/images/background.png"))),
                child: SingleChildScrollView(
                    child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: Image.asset("assets/images/logo.webp"),
                        height: 150,
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(5, 15, 5, 15),
                        child: Text(
                          "Sign Up / Create an account to receive our \n Newsletters and Special promotions.",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
                        child: CanineTextField(
                          inputAction: TextInputAction.next,
                          prefix: "Full name -",
                          isBackendMessage:
                              field['name'] != null ? isError : false,
                          message: isError == true
                              ? field['name'] != null
                                  ? field['name'][0]
                                  : ""
                              : "",
                          tag: "none",
                          controller: first_name,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
                        child: CanineTextField(
                          inputAction: TextInputAction.next,
                          prefix: "Email id -",
                          tag: "none",
                          isBackendMessage:
                          field['email'] != null ? isError : false,
                          message: isError == true
                              ? field['email'] != null
                              ? field['email'][0]
                              : ""
                              : "",
                          controller: email_id,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
                        child: CanineTextField(
                          textInputType: TextInputType.phone,
                          inputAction: TextInputAction.next,
                          inputFormatter: [FilteringTextInputFormatter.digitsOnly],
                          prefix: "Mobile no -",
                          tag: "none",
                          isBackendMessage:
                          field['phone'] != null ? isError : false,
                          message: isError == true
                              ? field['phone'] != null
                              ? field['phone'][0]
                              : ""
                              : "",
                          controller: mobile_no,
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
                          child: CaninePasswordField(
                            eyeButton: eyeButton,
                            controller: password,
                            isVerify: false,
                            isBackendMessage:
                                field['password'] != null ? isError : false,
                            message: isError == true
                                ? field['password'] != null
                                    ? field['password'][0]
                                    : ""
                                : "",
                            callback: () {
                              setState(() {
                                eyeButton = !eyeButton;
                              });

                            },
                            validatorMessage: false,
                          )),
                      Container(
                        margin: EdgeInsets.fromLTRB(5, 10, 5, 10),
                        alignment: Alignment.bottomCenter,
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                              text: "Already have an account? ",
                              style: TextStyle(
                                fontFamily: CanineFonts.Aleo,
                              ),
                              children: [
                                TextSpan(
                                  text: "Login Here",
                                  style: TextStyle(
                                      decoration: TextDecoration.underline),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  BlocProvider(
                                                      child: LoginPage(
                                                        widgetRoute:
                                                            widget.widgetRoute,
                                                      ),
                                                      create: (context) =>
                                                          LoginBLOC())));
                                    },
                                ),
                              ]),
                        ),
                      ),
                      BlocListener(
                        bloc: blocprovider,
                        listener: (context, state) {
                          if (state is InlineErrorState) {
                            setState(() {
                              isError = state.status;
                              message = "Error";
                              field = state.field;
                            });
                          }
                          if (state is EmailErrorState) {
                            setState(() {
                              isError = false;
                            });
                            emailDialog(context, blocprovider);
                          }
                          if (state is UserVerified) {
                            Navigator.pop(context);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BlocProvider(
                                        create: (context) => LoginBLOC(),
                                        child: LoginPage(
                                          widgetRoute: widget.widgetRoute,
                                        ))));
                          }
                          if (state is InputIsRegistered) {
                            verifyDialog(context, blocprovider);
                            CanineSnackBar.show(
                                context, "An otp is sent to your account");
                            setState(() {
                              isError = false;
                            });
                            /* Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BlocProvider(create: (context) => LoginBLOC(),child: LoginPage(widgetRoute: widget.widgetRoute,))));*/
                          }
                          if (state is ErrorState) {
                            CanineSnackBar.show(context, state.message);
                          }
                        },
                        child: BlocBuilder<RegisterBLOC, RegisterBlocState>(
                          builder: (context, state) {
                            if (state is InputIsProcessing) {
                              return Progress();
                            }
                            return Container(
                              margin: EdgeInsets.fromLTRB(5, 15, 5, 10),
                              child: CanineButton(
                                buttonWidth: 180.0,
                                color: CanineColors.transparentcolor,
                                text: "Sign Up",
                                borderRadius: 10,
                                callback: () => {
                                  FocusScope.of(context).unfocus(),
                                  if (formKey.currentState!.validate())
                                    {
                                      ConnectivityCheck().getConnectionState().then((value){
                                        if(value){
                                          blocprovider.add(RegisterEvent({
                                            "name": first_name.text.trim(),
                                            "phone": mobile_no.text,
                                            "email": email_id.text,
                                            "password": password.text
                                          }));
                                        }})

                                    }
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(5, 15, 5, 15),
                        alignment: Alignment.bottomCenter,
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                              text: "By Signing Up you accept our ",
                              children: [
                                TextSpan(
                                    text: "Terms of Service \n",
                                    style: TextStyle(
                                        decoration: TextDecoration.underline),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  TermsAndConditions(),
                                            ));
                                      }),
                                TextSpan(text: " and "),
                                TextSpan(
                                    text: "Privacy Policy",
                                    style: TextStyle(
                                        decoration: TextDecoration.underline),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  PrivacyPolicy(),
                                            ));
                                      }),
                              ]),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom))
                    ],
                  ),
                ))),
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

  emailDialog(BuildContext dcontext, RegisterBLOC blocprovider) {
    showDialog(
      barrierDismissible: false,
      context: dcontext,
      builder: (context) => WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Dialog(
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.only(bottom: 25.0),
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
                      }),
                ),
                Container(
                    margin: EdgeInsets.symmetric(vertical: 10.0),
                    child: Icon(
                      Icons.error,
                      color: Colors.red,
                      size: 50.0,
                    )),
                Container(
                  margin: EdgeInsets.only(bottom: 10.0),
                  alignment: Alignment.center,
                  child: CanineText(
                    text:
                        "Email id already exists. \n Sign up with new email or Please try sign in",
                    maxLines: 5,
                    fontSize: 20.0,
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  color: Colors.white,
                  margin: EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CanineButton(
                        color: Colors.white,
                        borderColor: CanineColors.dialogButton,
                        textColor: CanineColors.dialogButton,
                        text: "Sign In",
                        fontSize: 12.0,
                        callback: () {
                          blocprovider.add(LoginEvent());
                        },
                      ),
                      Container(
                        margin: EdgeInsets.all(10.0),
                        child: CanineButton(
                          borderColor: CanineColors.dialogButton,
                          textColor: CanineColors.dialogButton,
                          text: "Cancel",
                          color: Colors.white,
                          fontSize: 12.0,
                          callback: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  verifyDialog(BuildContext context, RegisterBLOC blocprovider) {
    showDialog(
        context: context,
        builder: (context) => WillPopScope(
              onWillPop: () async {
                return false;
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
                          margin: EdgeInsets.symmetric(vertical: 10.0),
                          child: CanineText(
                            textAlign: TextAlign.center,
                            text: "Verify OTP",
                            color: Colors.black87,
                            fontSize: 18.0,
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
                              if (state is OTPErrorState) {
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
                            if (state is OTPInputIsProcessing) {
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
                                  blocprovider.add(VerifyEvent(
                                      otp.text, email_id.text, password.text));
                                  /*Timer(Duration(seconds: 2), () {
                              Navigator.pop(context);
                            });*/
                                },
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  )),
            ));
  }
}
