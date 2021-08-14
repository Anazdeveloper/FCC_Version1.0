import 'package:first_class_canine_demo/Screens/Bottomsheet/ContactUs/ContactUsBloc.dart';
import 'package:first_class_canine_demo/Service/ConnectivityCheck.dart';
import 'package:first_class_canine_demo/Storage/Pref/Shared.dart';
import 'package:first_class_canine_demo/UIComponents/BottomNavigation.dart';
import 'package:first_class_canine_demo/UIComponents/BottomSheet/CanineBottomSheet.dart';
import 'package:first_class_canine_demo/UIComponents/CanineButton.dart';
import 'package:first_class_canine_demo/UIComponents/CanineStyle.dart';
import 'package:first_class_canine_demo/UIComponents/CanineText.dart';
import 'package:first_class_canine_demo/UIComponents/Progress.dart';
import 'package:first_class_canine_demo/UIComponents/UIComponents/TopSnackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactUs extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ContactUsState();
  }
}

class ContactUsState extends State<ContactUs> {
  bool isOpen = false;

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController message = TextEditingController();
  dynamic bottomSheet;
  final bottomSheetKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    ConnectivityCheck().checkNetwork();
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final blocprovider = BlocProvider.of<ContactUsBloc>(context);

    return FutureBuilder(
        future: _getDescription(),
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            final contactDescription = snapshot.data;
            return Scaffold(
              key: bottomSheetKey,
              resizeToAvoidBottomInset: false,
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                elevation: 0.0,
                backgroundColor: Colors.transparent,
                leading: IconButton(
                  onPressed: () {
                    if (isOpen == false) Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back_ios),
                ),
              ),
              body: Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/images/background.png"),
                          fit: BoxFit.fill)),
                  child: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(20.0),
                                    bottomRight: Radius.circular(180.0)),
                                child: Image.asset(
                                    "assets/images/contactusImage.png",
                                    fit: BoxFit.fill,
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height /
                                        2)),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 8.0),
                            child: CanineText(
                              color: CanineColors.textColor,
                              text: "Contact Us",
                              fontSize: 25.0,
                              fontFamily: CanineFonts.Rye,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 5.0, top: 5.0),
                            child: CanineText(
                              color: CanineColors.textColor,
                              text: contactDescription,
                              maxLines: 3,
                              textAlign: TextAlign.center,
                              fontSize: 14.0,
                              fontFamily: CanineFonts.Aleo,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 20.0),
                            child: TextFormField(
                              controller: name,
                              style: TextStyle(color: Colors.white),
                              inputFormatters: [ FilteringTextInputFormatter.allow(RegExp( r'^[a-zA-Z\s]+$')),],
                              validator: (value) {
                                if (value!.trim().isEmpty) {
                                  return "Please enter fullname";
                                } else if (value.trim().length < 2 &&
                                    value.trim().length > 20) {
                                  return "Name should be only alphabets with 2-20 characters";
                                }

                                return null;
                              },
                              decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.fromLTRB(0.0, 0.0, 4.0, 0.0),
                                  prefixIconConstraints: BoxConstraints(
                                      maxWidth: 120,
                                      maxHeight: 20,
                                      minWidth: 100),
                                  prefixIcon: Padding(
                                      padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                                      child: Text("Full Name -",
                                          style: TextStyle(
                                            fontFamily: 'Aleo',
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                          ))),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          BorderSide(color: Colors.white)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          BorderSide(color: Colors.white)),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                      ))),
                            ),
                            // child: CanineTextField(
                            //   controller: name,
                            //   tag: "name",
                            //   prefix: "Full Name -",
                            // ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 20.0),
                            child: TextFormField(
                              controller: email,
                              style: TextStyle(color: Colors.white),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter email address";
                                }
                                var pattern =
                                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                if (!RegExp(pattern).hasMatch(value)) {
                                  return "Please enter a valid email address";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.fromLTRB(0.0, 0.0, 4.0, 0.0),
                                  prefixIconConstraints: BoxConstraints(
                                      maxWidth: 120,
                                      maxHeight: 20,
                                      minWidth: 100),
                                  prefixIcon: Padding(
                                      padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                                      child: Text("Email id -",
                                          style: TextStyle(
                                            fontFamily: 'Aleo',
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                          ))),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          BorderSide(color: Colors.white)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          BorderSide(color: Colors.white)),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                      ))),
                            ),
                            // child: CanineTextField(
                            //   controller: email,
                            //   tag: "email",
                            //   prefix: "Email id -",
                            // ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 20.0),
                            child: TextFormField(
                              maxLines: 2,
                              controller: message,
                              style: TextStyle(color: Colors.white),
                              validator: (value) {
                                if (value!.trim().isEmpty) {
                                  return "Please enter a message";
                                } else if (value.length > 300) {
                                  return "Message length limit < 300";
                                }
                                return null;
                              },
                              decoration: InputDecoration(

                                  contentPadding: new EdgeInsets.symmetric(
                                      vertical: 30.0, horizontal: 10.0),
                                  prefixIconConstraints: BoxConstraints(
                                      maxWidth: 120,
                                      maxHeight: 70,
                                      minWidth: 100),

                                  prefixIcon: Padding(

                                      padding:
                                          EdgeInsets.fromLTRB(15, 0, 0, 26),
                                      child: Text("Message -",
                                          style: TextStyle(
                                            fontFamily: 'Aleo',
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                          ))),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                      )),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          BorderSide(color: Colors.white)),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                    ),
                                  )),
                            ),
                            // child: CanineTextField(
                            //   controller: message,
                            //   tag: "message",
                            //   prefix: "Message -",
                            // ),
                          ),
                          BlocListener(
                            bloc: blocprovider,
                            listener: (context, state) {
                              if (state is SubmitSuccessful) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        "Thank you for contacting us. We'll get back to you shortly"),
                                  ),
                                );
                                name.text="";
                                email.text="";
                                message.text="";
                              }
                              if (state is ErrorState) {
                                // Fluttertoast.showToast(
                                //   msg: state.message,
                                //   toastLength: Toast.LENGTH_SHORT,
                                //   gravity: ToastGravity.TOP,
                                // );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(state.message),
                                  ),
                                );
                              }

                              if (state is CommonError) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(state.message),
                                  ),
                                );


                              }
                            },
                            child: BlocBuilder(
                              bloc: blocprovider,
                              builder: (context, state) {
                                if (state is InputIsProcessing) {
                                  return Progress();
                                }
                                return Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 5.0, horizontal: 20.0),
                                  child: CanineButton(
                                    buttonWidth: 200.0,
                                    text: "Send",
                                    color: Colors.transparent,
                                    callback: () async {
                                      FocusScopeNode currentFocus =
                                          FocusScope.of(context);
                                      if (!currentFocus.hasPrimaryFocus) {
                                        currentFocus.unfocus();
                                      }
                                      if (formKey.currentState!.validate()) {
                                        ConnectivityCheck().getConnectionState().then((value){
                                          if(value){
                                            blocprovider.add(ContactInputLoaded({
                                              'name': name.text.trim(),
                                              'email': email.text.trim(),
                                              'message': message.text.trim()
                                            }));
                                          }
                                        });

                                      }
                                    },
                                  ),
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
                    ),
                  )),
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
            );
          }
          return Progress();
        });
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
}

Future<String> _getDescription() async {
  final pref = await Shared().getSharedStorage();
  final description = pref.getString("contactus_description")!;
  return description;
}
