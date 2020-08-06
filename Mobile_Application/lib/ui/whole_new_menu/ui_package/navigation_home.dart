import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:teleport/bloc/Bloc_provider.dart';
import 'package:teleport/bloc/Events.dart';
import 'package:teleport/bloc/authBloc/profileBloc.dart';
import 'package:teleport/bloc/localizationBloc/LocalizationBloc.dart';
import 'package:teleport/modes/localization/AppLocalizations.dart';
import 'package:teleport/modes/localization/Languages.dart';
import 'package:teleport/ui/whole_new_menu/widget_package/drawer_user_controller.dart';
import 'package:teleport/ui/whole_new_menu/widget_package/home_drawer.dart';
import 'app_theme.dart';
import 'dashboard.dart';
import 'edit_robot_id.dart';
import 'feedback.dart';

class NavigationHomePage extends StatefulWidget {
  @override
  _NavigationHomeState createState() => _NavigationHomeState();
}

class _NavigationHomeState extends State<NavigationHomePage> {
  Widget screenView;
  DrawerIndex drawerIndex;
  AnimationController sliderAnimationController;
  ProfileBloc profileBloc;
  bool loaded = false;
  AppLocalizations text;
  LocalizationBloc locBloc;
  @override
  void initState() {
    drawerIndex = DrawerIndex.DASHBOARD;
    screenView = DashboardPage();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!loaded) {
      loaded = true;
      profileBloc = BlocProvider.of(context).profileBloc;
      profileBloc.profileInfos.add(ProfileEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    text = AppLocalizations.of(context);
    locBloc = BlocProvider.of(context).localizationBloc;

    return Container(
      color: AppTheme.nearlyWhite,
      child: SafeArea(
        top: true,
        bottom: true,
        child: DrawerUserController(
          screenIndex: drawerIndex,
          userName: profileBloc.userName,
          drawerWidth: MediaQuery.of(context).size.width * 0.65,
          animationController: (AnimationController animationController) {
            sliderAnimationController = animationController;
          },
          onDrawerCall: (DrawerIndex drawerIndex) {
            changeIndex(drawerIndex);
          },
          screenView: screenView,
        ),
      ),
    );
  }

  void changeIndex(DrawerIndex drawerIndex) {
    if (this.drawerIndex != drawerIndex) {
      this.drawerIndex = drawerIndex;
      if (drawerIndex == DrawerIndex.DASHBOARD) {
        setState(() {
          screenView = DashboardPage();
        });
      } else if (drawerIndex == DrawerIndex.EDITROBOTID) {
        setState(() {
          screenView = EditRobotId();
        });
      } else if (drawerIndex == DrawerIndex.FEEDBACK) {
        setState(() {
          screenView = FeedbackPage();
        });
      } else if (drawerIndex == DrawerIndex.STUDENTS) {
        setState(() {
          screenView = Scaffold(
            body: DoubleBackToCloseApp(
              snackBar: SnackBar(
                  content: Text(text.translate('Tap again to exit the app.'))),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Text(text.translate('Get to know the Students'),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )),
                    // SizedBox(height: 90),
                    // Image.asset('assets/card_light.png', fit: BoxFit.fill),
                    SizedBox(height: 61),
                    Card(
                      child: Material(
                        clipBehavior: Clip.antiAlias,
                        elevation: 8,
                        //color: Colors.transparent,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(5),
                          topRight: Radius.circular(5),
                          topLeft: Radius.circular(5),
                          bottomRight: Radius.circular(5),
                        ),
                        child: Image.asset(
                          'assets/zaki_card.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Card(
                      child: Material(
                        clipBehavior: Clip.antiAlias,
                        elevation: 8,
                        //borderOnForeground: true,
                        //color: Colors.transparent,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(5),
                          topRight: Radius.circular(5),
                          topLeft: Radius.circular(5),
                          bottomRight: Radius.circular(5),
                        ),
                        child: Image.asset('assets/med_card.png',
                            fit: BoxFit.fill),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ); // To be Implemented
        });
      } else if (drawerIndex == DrawerIndex.PROFESSORS) {
        setState(() {
          screenView = Container(
            color: Colors.white,
            child: DoubleBackToCloseApp(
              snackBar: SnackBar(
                  content: Text(text.translate('Tap again to exit the app.'))),
              child: Center(child: Text(text.translate('Professors'))),
            ),
          ); // To be Implemented
        });
      } else if (drawerIndex == DrawerIndex.LANGUAGE) {
        setState(() {
          screenView = Container(
            color: Colors.white,
            child: DoubleBackToCloseApp(
              snackBar: SnackBar(
                  content: Text(text.translate('Tap again to exit the app.'))),
              child: Center(
                child: Center(
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 30),
                      Text(
                        text.translate('Languages'),
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 190),
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        color: Colors.black87,
                        child: Text(
                          "AR",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () => locBloc.localizationEvent
                            .add(LanguageSelectEvent(Language.AR)),
                      ),
                      SizedBox(height: 15),
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        color: Colors.black87,
                        child: Text(
                          "FR",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () => locBloc.localizationEvent
                            .add(LanguageSelectEvent(Language.FR)),
                      ),
                      SizedBox(height: 15),
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        color: Colors.black87,
                        child: Text(
                          "EN",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () => locBloc.localizationEvent
                            .add(LanguageSelectEvent(Language.EN)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
      }
    }
  }
}
