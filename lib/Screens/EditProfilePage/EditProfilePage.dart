import 'package:first_class_canine_demo/Screens/EditProfilePage/EditProfileBloc.dart';
import 'package:first_class_canine_demo/Service/ConnectivityCheck.dart';
import 'package:first_class_canine_demo/Storage/Pref/Shared.dart';
import 'package:first_class_canine_demo/UIComponents/CanineButton.dart';
import 'package:first_class_canine_demo/UIComponents/CanineStyle.dart';
import 'package:first_class_canine_demo/UIComponents/EditProfileTextField.dart';
import 'package:first_class_canine_demo/UIComponents/Progress.dart';
import 'package:first_class_canine_demo/UIComponents/UIComponents/TopSnackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfilePage extends StatefulWidget {
  late String name,
      username,
      email,
      phone,
      street,
      city,
      zip,
      statename,
      address;
  bool isBilling;
  Widget? widgetRoute;

  EditProfilePage(
      {required this.name,
      required this.username,
      required this.email,
      required this.phone,
      required this.street,
      required this.city,
      required this.zip,
      required this.statename,
      required this.isBilling,
      required this.address,
      this.widgetRoute});

  @override
  State<StatefulWidget> createState() {
    return EditProfilePageState();
  }
}

class EditProfilePageState extends State<EditProfilePage> {
  final formKeyEditProfile = GlobalKey<FormState>();
  String message = "";
  bool ? isError = false;
  Map<String, dynamic> data = {};

  TextEditingController name = TextEditingController();
  TextEditingController floor = TextEditingController();
  TextEditingController street = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController zip = TextEditingController();
  TextEditingController statename = TextEditingController();

  @override
  void initState() {
    super.initState();
    name.text = widget.name;
    street.text = widget.street;
    city.text = widget.city;
    zip.text = widget.zip;
    statename.text = widget.statename;
    floor.text = widget.address;
    ConnectivityCheck().checkNetwork();
  }

  _prefer() async {
    final pref = await Shared().getSharedStorage();
    print('AddrId:${pref.get('addr_id')}');
  }

  @override
  Widget build(BuildContext context) {
    final blocProvider = BlocProvider.of<EditProfileBloc>(context);
    Widget EditProfilePage;
    if (!widget.isBilling) {
      EditProfilePage = Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
            centerTitle: true,
            title: Text(
              'Name',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.black,
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            )),
        body: Container(
          color: Colors.black,
          //alignment: Alignment.center,
          padding: EdgeInsets.all(30.0),
          child: Form(
            key: formKeyEditProfile,
            child: Column(
              children: [

                EditProfileTextField(
                  tag: 'none',
                  hint: 'Enter Full Name*',
                  controller: name,
                  isBackendMessage: data['name'] != null ? isError : false,
                  message: isError == true
                      ? data['name'] != null
                      ? data['name'][0]
                      : ""
                      : "",
                ),
                /*TextFormField(
                  autofocus: true,
                  cursorColor: Colors.white,
                  controller: name,
                  style: TextStyle(color: Colors.white),

                  decoration: const InputDecoration(
                    labelText: 'Enter Full Name*',
                    labelStyle: TextStyle(
                      color: Colors.white,
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                  ),
                )*/
                BlocListener(
                  bloc: blocProvider,
                  listener: (context, state) {
                    if (state is EditProfileErrorState) {
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

                    if (state is InlineErrorState) {
                      setState(() {
                        isError = state.status;
                        message = "Error";
                        data = state.data;
                      });
                    }
                    if (state is EditProfileSaveSuccessful) {
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
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => widget.widgetRoute!));
                    }
                  },
                  child: BlocBuilder(
                      bloc: blocProvider,
                      builder: (context, state) {
                        print('name:${name.text}');
                        _prefer();
                        if (state is EditProfileInputIsProcessing) {
                          return Progress();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 80.0),
                          child: CanineButton(
                            color: CanineColors.transparentcolor,
                            text: "Save Changes",
                            borderRadius: 10,
                            callback: () async {
                              FocusScopeNode currentFocus =
                                  FocusScope.of(context);
                              if (formKeyEditProfile.currentState!.validate()) {
                                final pref = await Shared().getSharedStorage();
                                pref.setString('user', name.text);
                                ConnectivityCheck().getConnectionState().then((value){
                                  if(value){
                                    blocProvider.add(EditProfileInputSaved({
                                      'name': name.text.trim(),
                                      'username': widget.username,
                                      'email': widget.email,
                                      'phone': widget.phone,
                                    }));
                                  }});

                              }
                            },
                          ),
                        );
                      }),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      EditProfilePage = Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            centerTitle: true,
            title: Text(
              'Billing Address',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.black,
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            )),
        body: Container(
          color: Colors.black,
          //alignment: Alignment.center,
          padding: EdgeInsets.all(30.0),
          child: Form(
            key: formKeyEditProfile,
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(top: 30.0),
                  child: Text(
                    'Billing Address',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                EditProfileTextField(
                  tag: 'none',
                  hint: 'Street Address*',
                  controller: street,
                  isBackendMessage: data['street'] != null ? isError : false,
                  message: isError == true
                      ? data['street'] != null
                      ? data['street'][0]
                      : ""
                      : "",
                ),
                // TextFormField(
                //   autofocus: true,
                //   cursorColor: Colors.white,
                //   controller: street,
                //   style: TextStyle(color: CanineColors.textColorSecondary),
                //   decoration: InputDecoration(
                //       hintText: 'Street Address*',
                //       hintStyle:
                //           TextStyle(color: CanineColors.textColorSecondary),
                //       enabledBorder: UnderlineInputBorder(
                //           borderSide: BorderSide(color: Colors.grey)),
                //       focusedBorder: UnderlineInputBorder(
                //           borderSide: BorderSide(color: Colors.grey)),
                //     errorText: isError! == true ? data['street'][0] : null,
                //   ),
                //   validator: (value) {
                //     if (value == null ||
                //         value.isEmpty ||
                //         street.text.trim().isEmpty) {
                //       return 'Street address is required';
                //     }
                //     // else if (value.length < 2 || value.length > 50 ) {
                //     //   return 'Street name can have 2-50 characters';
                //     // }
                //     return null;
                //   },
                // ),
                TextFormField(
                  autofocus: true,
                  cursorColor: Colors.white,
                  controller: floor,
                  style: TextStyle(color: CanineColors.textColorSecondary),
                  decoration: InputDecoration(
                      hintText: 'Apt #, Floor, etc. (optional)',
                      hintStyle:
                          TextStyle(color: CanineColors.textColorSecondary),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                    //errorText: isError! == true ? data['address'][0] : null,
                  ),
               /*   validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        street.text.trim().isEmpty) {
                      return null;
                    }
                    else if (value.length <2 || value.length > 50 ) {
                      return 'Address can have 2-50 characters';
                    }
                    return null;
                  }*/
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.40,
                      child: EditProfileTextField(
                        tag: 'none',
                        hint: 'City*',
                        controller: city,
                        isBackendMessage: data['city'] != null ? isError : false,
                        message: isError == true
                            ? data['city'] != null
                            ? data['city'][0]
                            : ""
                            : "",
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.40,
                      child: EditProfileTextField(
                        tag: 'none',
                        hint: 'State*',
                        controller: statename,
                        isBackendMessage: data['state'] != null ? isError : false,
                        message: isError == true
                            ? data['state'] != null
                            ? data['state'][0]
                            : ""
                            : "",
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.40,
                    child: EditProfileTextField(
                      tag: 'none',
                      hint: 'Zipcode*',
                      controller: zip,
                      isBackendMessage: data['zip'] != null ? isError : false,
                      message: isError == true
                          ? data['zip'] != null
                          ? data['zip'][0]
                          : ""
                          : "",
                    ),
                  ),
                ),
                BlocListener(
                  bloc: blocProvider,
                  listener: (context, state) {
                    if (state is InlineErrorState) {
                      setState(() {
                        isError = state.status;
                        message = "Error";
                        data = state.data;
                      });
                    }
                    if (state is EditBillingSaveSuccessful) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message),
                        ),
                      );
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => widget.widgetRoute!));
                    }
                  },
                  child: BlocBuilder(
                      bloc: blocProvider,
                      builder: (context, state) {
                        _prefer();
                        if (state is EditBillingInputIsProcessing) {
                          return Progress();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 80.0),
                          child: CanineButton(
                            color: CanineColors.transparentcolor,
                            text: "Save Changes",
                            borderRadius: 10,
                            callback: () {
                              FocusScopeNode currentFocus =
                                  FocusScope.of(context);
                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }
                              if (formKeyEditProfile.currentState!.validate()) {
                                ConnectivityCheck().getConnectionState().then((value){
                                  if(value){
                                    blocProvider.add(EditBillingInputSaved({
                                      'street': street.text.trim(),
                                      'city': city.text.trim(),
                                      'state': statename.text.trim(),
                                      'zip': zip.text.trim(),
                                      'address': floor.text.trim()
                                    }));
                                  }else{
                                    TopSnackBar.show();
                                  }
                                });

                              }
                            },
                          ),
                        );
                      }),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return EditProfilePage;
  }
}
