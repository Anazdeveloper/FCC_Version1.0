import 'package:first_class_canine_demo/Screens/Bottomsheet/Faqs/FaqBloc.dart';
import 'package:first_class_canine_demo/Service/ConnectivityCheck.dart';
import 'package:first_class_canine_demo/UIComponents/BottomNavigation.dart';
import 'package:first_class_canine_demo/UIComponents/BottomSheet/CanineBottomSheet.dart';
import 'package:first_class_canine_demo/UIComponents/FaqCell.dart';
import 'package:first_class_canine_demo/UIComponents/Progress.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FAQ extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FAQState();
  }
}

class FAQState extends State<FAQ> {
  bool isOpen = false;
  dynamic bottomSheet;
  final bottomSheetKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    ConnectivityCheck().checkNetwork();
  }

  @override
  Widget build(BuildContext context) {
    final blocBuilder = BlocProvider.of<FaqBloc>(context);
    blocBuilder.add(FaqUiLoadedEvent());
    return Scaffold(
      key: bottomSheetKey,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'FAQ',
          style: TextStyle(color: Colors.white),
        ),
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
                fit: BoxFit.fill,
                image: AssetImage("assets/images/background.png"))),
        child: BlocBuilder(
          bloc: blocBuilder,
          builder: (context, state) {
            if (state is FaqDataLoaded) {
              return ListView.builder(
                itemCount: state.faqData!.length,
                itemBuilder: (BuildContext context, int index) {
                  return FaqCell(state.faqData![index].question,
                      state.faqData![index].answer);
                },
              );
            }
            return Progress();
          },
        ),
      ),
      bottomNavigationBar: BottomNavigation(
        isOpen: isOpen,
        open: (context) {
          if (isOpen == false) {
            bottomSheet = showBottomSheet(
                backgroundColor: Colors.transparent,
                context: context,
                builder: (context) => StatefulBuilder(
                      builder: (context, setStateBottomSheet) => WillPopScope(
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
