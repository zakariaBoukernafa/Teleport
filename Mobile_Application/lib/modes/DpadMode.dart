import 'package:control_pad/control_pad.dart';
import 'package:flutter/material.dart';
import 'package:teleport/bloc/Bloc_provider.dart';
import 'package:teleport/bloc/DpadBloc.dart';
import 'package:teleport/bloc/Events.dart';
import 'package:teleport/bloc/authBloc/profileBloc.dart';

class DpadMode extends StatefulWidget {
  @override
  _DpadModeState createState() => _DpadModeState();
}

class _DpadModeState extends State<DpadMode> with WidgetsBindingObserver {
  DpadModeBloc dpadDirection;
  ProfileBloc profileBloc;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.inactive:
        print('state INACTIVE');
        break;

      case AppLifecycleState.paused:
        _onControlEnd(context);
        print('state PAUSED');
        break;

      case AppLifecycleState.resumed:
        print('state RESUMED');
        break;

      case AppLifecycleState.detached:
        print('state DETACHED');
        break;
    }
  }

  void _onControlEnd(BuildContext context) {
    final dpadBloc = BlocProvider.of(context).dPadDirection;
    dpadBloc.dPadDirectionEventSink.add(DisconnectCurrentUser());
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    dpadDirection = BlocProvider.of(context).dPadDirection;
    profileBloc = BlocProvider.of(context).profileBloc;

    return Scaffold(
      body: Center(
        child: JoystickView(
          backgroundColor: Colors.blue,
          showArrows: true,
          onDirectionChanged: sendDirection,
        ),
      ),
    );
  }

  void sendDirection(double degrees, double distance) {
    dpadDirection.degreeChanged.add(degrees);
    dpadDirection.distanceChanged.add(distance);
    dpadDirection.userNameSink.add(profileBloc.userIdValue);
    dpadDirection.robotIDSink.add(profileBloc.robotIdValue);
    dpadDirection.dPadDirectionEventSink.add(DpadDirectionEvent());
  }
}
