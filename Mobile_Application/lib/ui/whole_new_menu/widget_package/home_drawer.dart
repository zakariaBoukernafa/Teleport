import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teleport/bloc/Bloc_provider.dart';
import 'package:teleport/bloc/Events.dart';
import 'package:teleport/bloc/authBloc/profileBloc.dart';
import 'package:teleport/modes/localization/AppLocalizations.dart';
import 'package:teleport/ui/whole_new_menu/ui_package/app_theme.dart';

class HomeDrawer extends StatefulWidget {
  final AnimationController iconAnimationController;
  final DrawerIndex screenIndex;
  final Function(DrawerIndex) callBackIndex;

  HomeDrawer(
      {Key key,
      this.screenIndex,
      this.iconAnimationController,
      this.callBackIndex})
      : super(key: key);

  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  List<DrawerList> drawerList;
  AppLocalizations text;

  @override
  void initState() {
    setDrawer();
    super.initState();
  }

  void setDrawer() {
    drawerList = [
      DrawerList(
        index: DrawerIndex.DASHBOARD,
        labelName: 'Dashboard',
        icon: Icon(Icons.home),
      ),
      DrawerList(
        index: DrawerIndex.EDITROBOTID,
        labelName: 'Edit Robot id',
        icon: Icon(Icons.edit_attributes),
      ),
      DrawerList(
        index: DrawerIndex.FEEDBACK,
        labelName: 'Feedback',
        icon: Icon(Icons.help),
      ),
      DrawerList(
        index: DrawerIndex.STUDENTS,
        labelName: 'Students',
        icon: Icon(Icons.group),
      ),
      DrawerList(
        index: DrawerIndex.LANGUAGE,
        labelName: 'Languages',
        icon: Icon(Icons.language),
      ),
    ];
  }

  Widget inkwell(DrawerList listData) {
    return Material(
        color: Colors.transparent,
        child: InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              navigation(listData.index);
            },
            child: Stack(children: <Widget>[
              Container(
                  padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Row(children: <Widget>[
                    Container(
                      width: 6.0,
                      height: 46.0,
                    ),
                    Padding(
                      padding: EdgeInsets.all(4.0),
                    ),
                    Icon(listData.icon.icon,
                        color: widget.screenIndex == listData.index
                            ? Colors.black
                            : AppTheme.nearlyBlack),
                    Padding(
                      padding: EdgeInsets.all(4.0),
                    ),
                    Text(
                      text.translate(listData.labelName),
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        color: widget.screenIndex == listData.index
                            ? Colors.black
                            : AppTheme.nearlyBlack,
                      ),
                      textAlign: TextAlign.left,
                    )
                  ])),
              widget.screenIndex == listData.index
                  ? AnimatedBuilder(
                      animation: widget.iconAnimationController,
                      builder: (BuildContext context, Widget child) {
                        return Transform(
                            transform: Matrix4.translationValues(
                                (MediaQuery.of(context).size.width * 0.75 -
                                        64) *
                                    (1.0 -
                                        widget.iconAnimationController.value -
                                        1.0),
                                0.0,
                                0.0),
                            child: Padding(
                                padding: EdgeInsets.only(top: 8, bottom: 8),
                                child: Container(
                                    width: MediaQuery.of(context).size.width *
                                            0.75 -
                                        64,
                                    height: 46,
                                    decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.1),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(0),
                                          topRight: Radius.circular(28),
                                          bottomLeft: Radius.circular(0),
                                          bottomRight: Radius.circular(28),
                                        )))));
                      })
                  : SizedBox()
            ])));
  }

  void navigation(DrawerIndex indexScreen) {
    widget.callBackIndex(indexScreen);
  }

  @override
  Widget build(BuildContext context) {
    final profileBloc = BlocProvider.of(context).profileBloc;
    text = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppTheme.white.withOpacity(0.5),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(16, 40, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                AnimatedBuilder(
                    animation: widget.iconAnimationController,
                    builder: (BuildContext context, Widget child) {
                      return ScaleTransition(
                          scale: AlwaysStoppedAnimation(1.0 -
                              (widget.iconAnimationController.value) * 0.2),
                          child: RotationTransition(
                            turns: AlwaysStoppedAnimation(Tween(
                                        begin: 0.0, end: 24.0)
                                    .animate(CurvedAnimation(
                                        parent: widget.iconAnimationController,
                                        curve: Curves.fastOutSlowIn))
                                    .value /
                                360),
                            child: Container(
                                height: 90,
                                width: 90,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                        color: AppTheme.grey.withOpacity(0.6),
                                        offset: Offset(2.0, 4.0),
                                        blurRadius: 8),
                                  ],
                                ),
                                child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50.0)),
                                    child: CircleAvatar(
                                      backgroundImage: ExactAssetImage(
                                          'assets/robotIcon.png'),
                                      minRadius: 90,
                                      maxRadius: 150,
                                      backgroundColor: Colors.red,
                                    ))),
                          ));
                    }),
                Padding(
                  padding: const EdgeInsets.only(top: 8, left: 4),
                  child: StreamBuilder<String>(
                      stream: profileBloc.userName,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text(snapshot.data,
                              style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.grey,
                                  fontSize: 25));
                        } else {
                          return Text(text.translate("Loading"),
                              style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.grey,
                                  fontSize: 15));
                        }
                      }),
                ),
              ],
            ),
          ),
          SizedBox(height: 4),
          Divider(height: 1, color: AppTheme.grey.withOpacity(0.6)),
          Expanded(
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.all(0.0),
              itemCount: drawerList.length,
              itemBuilder: (context, index) {
                return inkwell(drawerList[index]);
              },
            ),
          ),
          Divider(height: 1, color: AppTheme.grey.withOpacity(0.6)),
          Column(
            children: <Widget>[
              ListTile(
                title: Text(
                  text.translate("Logout"),
                  style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: AppTheme.darkText),
                  textAlign: TextAlign.left,
                ),
                trailing: Icon(Icons.power_settings_new, color: Colors.red),
                onTap: () async {
                  await _confirmQuit(context, profileBloc, text);
                },
              ),
              SizedBox(height: MediaQuery.of(context).padding.bottom)
            ],
          ),
        ],
      ),
    );
  }
}

enum DrawerIndex {
  DASHBOARD,
  EDITROBOTID,
  FEEDBACK,
  STUDENTS,
  PROFESSORS,
  LANGUAGE,
}

class DrawerList {
  String labelName;
  Icon icon;
  DrawerIndex index;

  DrawerList({
    this.labelName = '',
    this.icon,
    this.index,
  });
}

Future<bool> _confirmQuit(BuildContext context, ProfileBloc profileBloc,
    AppLocalizations text) async {
  return (await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(text.translate('Are you sure')),
          content: Text(text.translate("Do you want to exit")),
          actions: <Widget>[
            RaisedButton(
              elevation: 0.0,
              color: Colors.transparent,
              highlightColor: Colors.grey,
              onPressed: () {
                SystemChrome.setPreferredOrientations([
                  DeviceOrientation.portraitDown,
                ]);
                Navigator.of(context).pop(false);
              },
              child: Text(text.translate("No"),
                  style: TextStyle(color: Colors.black)),
            ),
            RaisedButton(
              color: Colors.redAccent,
              highlightColor: Colors.white,
              onPressed: () {
                profileBloc.profileInfos.add(SignOutEvent());
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/SignIn', (Route<dynamic> route) => false);
                //Navigator.of(context).pop(false); //Closes call view.
              },
              child: Text(text.translate("Yes"),
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      )) ??
      false; //If we click outside the AlertDialog Box, we consider it a missclick so we stay in the current screen.
}
