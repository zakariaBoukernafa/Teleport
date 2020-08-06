import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teleport/bloc/Bloc_provider.dart';
import 'package:teleport/modes/DpadMode.dart';
import 'package:teleport/modes/SensorsMode.dart';
import 'package:teleport/modes/agora/pages/call.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final profileBloc = BlocProvider.of(context).profileBloc;
    print("robot id is ${profileBloc.robotIdValue}");
    Widget _buildButton(
        {String name,
        Widget page,
        Color textColor,
        Color buttonColor,
        Color splashColor,
        IconData icon,
        Color iconColor}) {
      return ButtonTheme(
        minWidth: 200,
        height: 50,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15))),
        child: RaisedButton.icon(
          icon: Icon(icon, color: iconColor),
          splashColor: splashColor,
          color: buttonColor,
          label: Text(
            name,
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
          onPressed: () {
            FocusScope.of(context).requestFocus(FocusNode());
            SystemChrome.setPreferredOrientations([
              DeviceOrientation.portraitUp,
            ]);

            Navigator.push(
              context,
              PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => page,
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    var begin = Offset(1.0, 0.0);
                    var end = Offset.zero;
                    var tween = Tween(begin: begin, end: end);
                    var offsetAnimation = animation.drive(tween);
                    return SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    );
                  }),
            );
          },
        ),
      );
    }

    print("widgets are rebuilding");

    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: 50.0),
            Image.asset('assets/pioneer3dx.png', fit: BoxFit.fill),
            SizedBox(height: 20.0),
            /*  _buildButton(
                'Arrows Mode', ArrowsMode(), Colors.white, Colors.black), */
            // SizedBox(height: 10.0),
            // _buildButton(
            //   name: 'Dpad Mode',
            //   page: DpadMode(),
            //   textColor: Colors.black,
            //   buttonColor: Colors.grey[200],
            //   splashColor: Colors.grey,
            //   icon: Icons.gamepad,
            //   iconColor: Colors.black87,
            // ),
            // SizedBox(height: 10.0),
            // _buildButton(
            //   name: 'Sensors Mode',
            //   page: SensorsMode(),
            //   textColor: Colors.white,
            //   buttonColor: Colors.black,
            //   splashColor: Colors.white,
            //   icon: Icons.wb_iridescent,
            //   iconColor: Colors.white,
            // ),
            SizedBox(height: 50.0),
            _buildButton(
                name: 'Teleop Call',
                page: CallPage(
                  isRobotview: false,
                  channelName: profileBloc.robotIdValue,
                ),
                textColor: Colors.white,
                buttonColor: Colors.black87,
                splashColor: Colors.white,
                icon: Icons.video_call,
                iconColor: Colors.white),
            SizedBox(height: 25.0),
            _buildButton(
                name: 'Robot callview',
                page: CallPage(
                  isRobotview: true,
                  channelName: profileBloc.robotIdValue,
                ),
                textColor: Colors.black87,
                buttonColor: Colors.white70,
                splashColor: Colors.black87,
                icon: Icons.video_call,
                iconColor: Colors.black87),
            SizedBox(height: 90.0),
          ],
        ),
      ),
    );
  }
}
