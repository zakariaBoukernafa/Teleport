import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:teleport/modes/localization/AppLocalizations.dart';

import 'Home.dart';

class DashboardPage extends StatefulWidget {
  DashboardPage({Key key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<DashboardPage>
    with TickerProviderStateMixin {
  AnimationController animationController;
  bool multiple = false;
  AppLocalizations text;

  AnimationController _controller;
  Duration _duration = Duration(milliseconds: 300);
  Tween<Offset> _tween = Tween(begin: Offset(0, 1), end: Offset(0, 0));

  @override
  void initState() {
    animationController = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);
    super.initState();

    _controller = AnimationController(vsync: this, duration: _duration);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Widget _myButton() {
    return DraggableScrollableSheet(
      initialChildSize: 0.93,
      builder: (BuildContext context, ScrollController scrollController) {
        return SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(10.0),
            padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 60.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
              border: Border.all(),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text('\t\t\t\t\t\tROBOT BIO',
                    style: TextStyle(fontSize: 40)),
                _buildText(
                    primary: 'Brand: ', secondary: 'Adept MobileRobots.'),
                _buildText(primary: 'Robot name: ', secondary: 'Pioneer-3dx.'),
                _buildText(primary: 'Height: ', secondary: '237mm.'),
                _buildText(primary: 'Width: ', secondary: '381mm.'),
                _buildText(primary: 'Length: ', secondary: '455mm.'),
                _buildText(primary: 'Weight:', secondary: '9kg.'),
                _buildText(primary: 'Type: ', secondary: 'Telepresence Robot.'),
                _buildText(primary: 'Core software: ', secondary: 'ARIA.'),
                _buildText(primary: 'Software used: ', secondary: 'ROS.'),
                _buildText(
                    primary: 'Tested Simulator: ', secondary: 'Gazebo.'),
                _buildText(
                    primary: 'Drivable via: ',
                    secondary: 'Android mobile application.'),
                _buildText(
                    primary: 'Battery: ',
                    secondary: '7.2 Ah, up to 3 at a time.'),
                _buildText(
                    primary: 'Run Time: ', secondary: '8-10 w/3 batteries.'),
                _buildText(primary: 'Body: ', secondary: 'Aluminium.'),
                _buildText(
                    primary: 'Tires: ', secondary: 'Foam-filled rubber.'),
                _buildText(primary: 'Numbre of wheels: ', secondary: '2.'),
                _buildText(
                    primary: 'Traversable Terrain: ', secondary: 'Indoor.'),
                _buildText(
                    primary: 'Support Operation payload: ', secondary: '17kg.'),
                _buildText(primary: 'Cuztomizable: ', secondary: 'Yes.'),
                _buildText(
                    primary: 'Supports other softwares: ', secondary: 'Yes.'),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    text = AppLocalizations.of(context);

    return Scaffold(
      // backgroundColor: AppTheme.white,

      floatingActionButton: GestureDetector(
        child: FloatingActionButton(
          child: AnimatedIcon(
              icon: AnimatedIcons.menu_close, progress: _controller),
          elevation: 5,
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          onPressed: () async {
            if (_controller.isDismissed)
              _controller.forward();
            else if (_controller.isCompleted) _controller.reverse();
          },
        ),
      ),
      body: DoubleBackToCloseApp(
        snackBar: SnackBar(content:  Text(text.translate('Tap again to exit the app.'))),
        child: SizedBox.expand(
          child: SafeArea(
            child: Stack(
              children: <Widget>[
                Home(),
                SizedBox.expand(
                  child: SlideTransition(
                    position: _tween.animate(_controller),
                    child: _myButton(),
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

Widget _buildText({String primary, String secondary}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Wrap(
      children: <Widget>[
        Text(primary,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(secondary, style: TextStyle(fontSize: 20)),
      ],
    ),
  );
}
