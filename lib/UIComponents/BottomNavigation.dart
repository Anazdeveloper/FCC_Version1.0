import 'package:first_class_canine_demo/Screens/HomePage/HomeBloc.dart';
import 'package:first_class_canine_demo/Screens/HomePage/HomePage.dart';
import 'package:first_class_canine_demo/Screens/Login/LoginBLOC.dart';
import 'package:first_class_canine_demo/Screens/Login/LoginPage.dart';
import 'package:first_class_canine_demo/Screens/ProfilePage/ProfilePage.dart';
import 'package:first_class_canine_demo/Screens/ProfilePage/ProfilePageBloc.dart';
import 'package:first_class_canine_demo/Storage/Pref/Shared.dart';
import 'package:first_class_canine_demo/UIComponents/CanineStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class BottomNavigation extends StatelessWidget {
  final void Function()? callback;
  final Widget? event;
  final bool? isOpen;
  Function(BuildContext context)? open;

  BottomNavigation({this.callback, this.event, this.isOpen = false, this.open});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          backgroundColor: CanineColors.Secondary,
          currentIndex: 0,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: SvgPicture.asset("assets/images/home.svg"),
              label: '',
              backgroundColor: CanineColors.Secondary,
            ),
            /* BottomNavigationBarItem(
              icon: SvgPicture.asset("assets/images/bone.svg"),
              label: '',
            ),*/
            BottomNavigationBarItem(
              icon: SvgPicture.asset("assets/images/profile.svg"),
              label: '',
            ),
            isOpen == false
                ? BottomNavigationBarItem(
                    icon: SvgPicture.asset("assets/images/menu.svg"),
                    label: '',
                  )
                : BottomNavigationBarItem(
                    icon: SvgPicture.asset("assets/images/circle_menu.svg"),
                    label: '',
                  ),
          ],
          onTap: (i) async {
            switch (i) {
              case 0:
                bool isNewRouteSameAsCurrent = false;
                Navigator.popUntil(context, (route) {
                  if (route.settings.name == "/home") {
                    isNewRouteSameAsCurrent = true;
                  }
                  return true;
                });
                if (ModalRoute.of(context)!.settings.name != "/home") {
                  if (!isNewRouteSameAsCurrent) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            settings: RouteSettings(name: "/home"),
                            builder: (context) => BlocProvider(
                                  create: (context) => HomeBloc(),
                                  child: HomePage(),
                                )));
                  }
                }
                break;
              case 4:
                /* Navigator.push(context,
                    MaterialPageRoute(builder: (context) => BlocProvider(
                        create: (context) =>ProductBLOC(),
                        child: ProductsPage()
                    )
                    )
                );*/
                break;
              case 1:
                final pref = await Shared().getSharedStorage();
                print('Route:${ModalRoute.of(context)!.settings.name}');
                if (ModalRoute.of(context)!.settings.name != "/profile" &&
                    ModalRoute.of(context)!.settings.name != "/login") {
                  bool isNewRouteSameAsCurrent = false;
                  Navigator.popUntil(context, (route) {
                    if (route.settings.name == "/profile") {
                      isNewRouteSameAsCurrent = true;
                    }
                    return true;
                  });
                  if (pref.containsKey("username")) {
                    if (!isNewRouteSameAsCurrent) {
                      print('Route:${ModalRoute.of(context)!.settings.name}');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            settings: RouteSettings(name: "/profile"),
                            builder: (context) => BlocProvider(
                                  create: (context) => ProfileBloc(),
                                  child: ProfilePage(),
                                )),
                      );
                    }
                  } else {
                    print('Route:${ModalRoute.of(context)!.settings.name}');
                    bool isNewRouteSameAsCurrent = false;
                    Navigator.popUntil(context, (route) {
                      if (route.settings.name == "/login") {
                        isNewRouteSameAsCurrent = true;
                      }
                      return true;
                    });
                    if (!isNewRouteSameAsCurrent) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              settings: RouteSettings(name: "/login"),
                              builder: (context) => BlocProvider(
                                  create: (context) => LoginBLOC(),
                                  child: LoginPage(
                                    widgetRoute: BlocProvider(
                                        create: (context) => ProfileBloc(),
                                        child: ProfilePage()),
                                  ))));
                    }
                  }
                }
                break;
              case 2:
                open!.call(context);
                //callback!.call();
                break;
            }
          }),
    );
  }
}
