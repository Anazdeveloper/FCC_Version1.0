import 'package:first_class_canine_demo/Screens/Products/ProductBLOC.dart';
import 'package:first_class_canine_demo/UIComponents/Badge.dart';
import 'package:first_class_canine_demo/UIComponents/BottomNavigation.dart';
import 'package:first_class_canine_demo/UIComponents/BottomSheet/CanineBottomSheet.dart';
import 'package:first_class_canine_demo/UIComponents/CanineStyle.dart';
import 'package:first_class_canine_demo/UIComponents/CanineText.dart';
import 'package:first_class_canine_demo/UIComponents/Progress.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ProductsState();
  }
}

class ProductsState extends State<ProductsPage> {
  bool isOpen = false;
  Widget ListBox(paid, product) {
    bool paidStatus = paid;
    return Container(
      width: 150,
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset("assets/images/products.webp",
                fit: BoxFit.fill, width: 200, height: 100),
          ),
          Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(top: 10.0, left: 10.0),
              child: CanineText(
                text: "Addcart",
                color: CanineColors.textColor,
              )),
          Expanded(
            child: Container(
              alignment: Alignment.bottomCenter,
              child: paidStatus
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: 50,
                          child: Container(
                              margin: EdgeInsets.only(left: 10.0),
                              child: CanineText(
                                text: "70",
                                color: CanineColors.textColor,
                              )),
                        ),
                        Container(
                            margin: EdgeInsets.all(5),
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 2),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                              color: Colors.red,
                            ),
                            child: Text(
                              "Addtocart",
                              style: TextStyle(
                                color: Colors.white,
                                decoration: TextDecoration.underline,
                              ),
                            ))
                      ],
                    )
                  : Container(
                      margin: EdgeInsets.all(10.0),
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        "Free",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final blocBuilder = BlocProvider.of<ProductBLOC>(context);
    blocBuilder.add(UiLoadedEvent());
    return Theme(
      data: ThemeData(
        fontFamily: CanineFonts.Aleo,
      ),
      child: SafeArea(
        child: Scaffold(
            backgroundColor: Colors.black,
            body: Container(
              margin: EdgeInsets.only(left: 25, right: 25),
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              child: Text(
                            "Products",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Rye",
                                fontSize: 30),
                          )),
                          Container(
                            alignment: Alignment.centerRight,
                            child: Badge(),
                          )
                        ],
                      ),
                    ),
                    Divider(
                      color: Colors.white,
                      thickness: 1.0,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10.0, bottom: 20.0),
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          print("view all");
                        },
                        child: Text(
                          "View All",
                          style: TextStyle(
                              fontSize: 20,
                              decorationStyle: TextDecorationStyle.solid,
                              decoration: TextDecoration.underline,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox.fromSize(
                      size: Size.fromHeight(200),
                      child: BlocBuilder(
                          bloc: blocBuilder,
                          builder: (context, state) {
                            if (state is DataLoaded) {
                              return ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemCount: state.data.length,
                                  itemBuilder: (context, index) {
                                    return ListBox(
                                        true, state.data.elementAt(index));
                                  });
                            }
                            return Progress();
                          }),
                    ),
                    //
                    Container(
                      margin: EdgeInsets.only(top: 40.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              child: Text(
                            "Services",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: CanineFonts.Rye,
                                fontSize: 30),
                          )),
                          Container(
                            alignment: Alignment.centerRight,
                          )
                        ],
                      ),
                    ),
                    Divider(
                      color: Colors.white,
                      thickness: 1.0,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10.0, bottom: 20.0),
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          print("view");
                        },
                        child: Text(
                          "View All",
                          style: TextStyle(
                              fontSize: 20,
                              decorationStyle: TextDecorationStyle.solid,
                              decoration: TextDecoration.underline,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox.fromSize(
                      size: Size.fromHeight(200),
                      child: BlocBuilder(
                        bloc: blocBuilder,
                        builder: (context, state) {
                          if (state is DataLoaded) {
                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: state.servicedata.length,
                              itemBuilder: (context, index) {
                                return ListBox(
                                    false, state.servicedata.elementAt(index));
                              },
                            );
                          }
                          return Progress();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            bottomSheet: isOpen == true ? CanineBottomSheet() : null,
            bottomNavigationBar: BottomNavigation(
              callback: () => {openBottomSheet()},
            )),
      ),
    );
  }

  void openBottomSheet() {
    setState(() {
      isOpen == false ? isOpen = true : isOpen = false;
    });
  }
}
