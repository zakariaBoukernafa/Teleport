import 'dart:async';
import 'dart:math';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:control_pad/views/joystick_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:teleport/bloc/Bloc_provider.dart';
import 'package:teleport/bloc/DpadBloc.dart';
import 'package:teleport/bloc/Events.dart';
import 'package:teleport/bloc/authBloc/profileBloc.dart';

import '../utils/settings.dart';

class CallPage extends StatefulWidget {
  /// non-modifiable channel name of the page
  final String channelName;

  /// flag for displaying the proper interfce, depending on the call.
  final bool isRobotview;

  /// Creates a call page with given channel name.
  const CallPage({
    Key key,
    this.channelName,
    this.isRobotview = false,
  }) : super(key: key);

  @override
  _CallPageState createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> with WidgetsBindingObserver {
  static final _users = <int>[];
  final _infoStrings = <String>[];
  bool muted = false;
  final dPadDirection = DpadModeBloc();
  ProfileBloc profileBloc;
  DpadModeBloc dpadBloc;

  @override
  void dispose() {
    // clear users
    _users.clear();
    // destroy sdk
    AgoraRtcEngine.leaveChannel();
    AgoraRtcEngine.destroy();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // initialize agora sdk
    initialize();
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.inactive:
        print('state INACTIVE');
        break;

      case AppLifecycleState.paused:
        _onCallEnd(context);
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

  Future<void> initialize() async {
    if (APP_ID.isEmpty) {
      setState(() {
        _infoStrings.add(
          'APP_ID missing, please provide your APP_ID in settings.dart',
        );
        _infoStrings.add('Agora Engine is not starting');
      });
      return;
    }

    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    await AgoraRtcEngine.enableWebSdkInteroperability(true);
    await AgoraRtcEngine.setParameters('''
    {\"che.video.lowBitRateStreamParameter\":{\"width\":320,\"height\":180,\"frameRate\":15,\"bitRate\":140}}''');
    await AgoraRtcEngine.joinChannel(null, widget.channelName, null, 0);
  }

  /// Create agora sdk instance and initialize
  Future<void> _initAgoraRtcEngine() async {
    await AgoraRtcEngine.create(APP_ID);
    await AgoraRtcEngine.enableVideo();
  }

  /// Add agora event handlers
  void _addAgoraEventHandlers() {
    AgoraRtcEngine.onError = (dynamic code) {
      setState(() {
        final info = 'onError: $code';
        _infoStrings.add(info);
      });
    };

    AgoraRtcEngine.onJoinChannelSuccess = (
      String channel,
      int uid,
      int elapsed,
    ) {
      setState(() {
        final info = 'onJoinChannel: $channel, uid: $uid';
        _infoStrings.add(info);
      });
    };

    AgoraRtcEngine.onLeaveChannel = () {
      setState(() {
        _infoStrings.add('onLeaveChannel');
        _users.clear();
      });
    };

    AgoraRtcEngine.onUserJoined = (int uid, int elapsed) {
      setState(() {
        final info = 'userJoined: $uid';
        _infoStrings.add(info);
        _users.add(uid);
      });
    };

    AgoraRtcEngine.onUserOffline = (int uid, int reason) {
      setState(() {
        final info = 'userOffline: $uid';
        _infoStrings.add(info);
        _users.remove(uid);
      });
    };

    AgoraRtcEngine.onFirstRemoteVideoFrame = (
      int uid,
      int width,
      int height,
      int elapsed,
    ) {
      setState(() {
        final info = 'firstRemoteVideo: $uid ${width}x $height';
        _infoStrings.add(info);
      });
    };
  }

  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    final list = [
      AgoraRenderWidget(0, local: true, preview: true),
    ];
    _users.forEach((int uid) => list.add(AgoraRenderWidget(uid)));
    return list;
  }

  /// Video view wrapper
  Widget _videoView(view) {
    return Expanded(child: Container(child: view));
  }

  /// Video view row wrapper
  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Expanded(
      child: Row(
        children: wrappedViews,
      ),
    );
  }

  /// Video layout wrapper
  Widget _viewRows() {
    final views = _getRenderViews();

    switch (views.length) {
      case 1:
        return Container(
            child: Column(
          children: <Widget>[_videoView(views[0])],
        ));
      case 2:
        return Container(
            child: Column(
          children: <Widget>[
            // _expandedVideoRow([views[0]]),
            _expandedVideoRow([views[1]])
          ],
        ));
      default:
    }
    return Container();
  }

  /// Toolbar layout
  Widget _toolbar() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 35),
      child: widget.isRobotview
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RawMaterialButton(
                  onPressed: _onToggleMute,
                  child: Icon(
                    muted ? Icons.mic : Icons.mic_off,
                    color: muted ? Colors.white : Colors.blueAccent,
                    size: 20.0,
                  ),
                  shape: CircleBorder(),
                  elevation: 2.0,
                  fillColor: muted ? Colors.blueAccent : Colors.white,
                  // padding: const EdgeInsets.all(5.0),
                ),
                RawMaterialButton(
                  onPressed: () async {
                    SystemChrome.setPreferredOrientations(
                        [DeviceOrientation.landscapeLeft]);
                    await _confirmQuit();
                  },
                  child: Icon(
                    Icons.call_end,
                    color: Colors.white,
                    size: 20.0,
                  ),
                  shape: CircleBorder(),
                  elevation: 2.0,
                  fillColor: Colors.redAccent,
                  padding: const EdgeInsets.all(5.0),
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RawMaterialButton(
                  onPressed: _onToggleMute,
                  child: Icon(
                    muted ? Icons.mic : Icons.mic_off,
                    color: muted ? Colors.white : Colors.blueAccent,
                    size: 20.0,
                  ),
                  shape: CircleBorder(),
                  elevation: 2.0,
                  fillColor: muted ? Colors.blueAccent : Colors.white,
                  // padding: const EdgeInsets.all(5.0),
                ),
                RawMaterialButton(
                  onPressed: () async {
                    SystemChrome.setPreferredOrientations(
                        [DeviceOrientation.landscapeLeft]);
                    await _confirmQuit();
                  },
                  child: Icon(
                    Icons.call_end,
                    color: Colors.white,
                    size: 20.0,
                  ),
                  shape: CircleBorder(),
                  elevation: 2.0,
                  fillColor: Colors.redAccent,
                  padding: const EdgeInsets.all(5.0),
                ),
                RawMaterialButton(
                  onPressed: _onSwitchCamera,
                  child: Icon(
                    Icons.switch_camera,
                    color: Colors.blueAccent,
                    size: 20.0,
                  ),
                  shape: CircleBorder(),
                  elevation: 2.0,
                  fillColor: Colors.white,
                  padding: const EdgeInsets.all(5.0),
                )
              ],
            ),
    );
  }

  void _onCallEnd(BuildContext context) {
    profileBloc.profileInfos.add(DisconnectCurrentUser());
    print("dc event sent");
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    AgoraRtcEngine.leaveChannel();
    AgoraRtcEngine.destroy();
    Navigator.pop(context);
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    AgoraRtcEngine.muteLocalAudioStream(muted);
  }

  void _onSwitchCamera() {
    AgoraRtcEngine.switchCamera();
  }

  Widget _joystick() {
    return Positioned(
      bottom: 15.0,
      left: 15.0,
      child: Transform.rotate(
        angle: pi / 2,
        child: JoystickView(
          opacity: 0.4,
          backgroundColor: Colors.white,
          showArrows: true,
          onDirectionChanged: sendDirection,
        ),
      ),
    );
  }

  void sendDirection(double degrees, double distance) {
    dPadDirection.degreeChanged.add(degrees);
    dPadDirection.distanceChanged.add(distance);
    dPadDirection.userNameSink.add(profileBloc.userIdValue);
    dPadDirection.robotIDSink.add(profileBloc.robotIdValue);
    dPadDirection.dPadDirectionEventSink.add(DpadDirectionEvent());
  }

  Future<bool> _confirmQuit() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Do you want to exit'),
            actions: <Widget>[
              RaisedButton(
                elevation: 0.0,
                color: Colors.transparent,
                highlightColor: Colors.grey,
                onPressed: () {
                  SystemChrome.setPreferredOrientations([
                    DeviceOrientation.landscapeLeft,
                  ]);
                  Navigator.of(context).pop(false);
                },
                child: const Text('No', style: TextStyle(color: Colors.black)),
              ),
              RaisedButton(
                color: Colors.redAccent,
                highlightColor: Colors.white,
                onPressed: () {
                  profileBloc.profileInfos.add(DisconnectCurrentUser());
                  _onCallEnd(context);
                  Navigator.of(context).pop(false); //Closes call view.
                },
                child: const Text('Yes', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        )) ??
        false; //If we click outside the AlertDialog Box, we consider it a missclick so we stay in the current screen.
  }

  @override
  Widget build(BuildContext context) {
    //Hide Both Statut and Navigation Bar
    SystemChrome.setEnabledSystemUIOverlays([]);

    //Bring it back on.
    //SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);

    dpadBloc = BlocProvider.of(context).dPadDirection;

    final snackBar = SnackBar(
      backgroundColor: Colors.red,
      content: Row(
        children: <Widget>[
          Icon(Icons.warning),
          SizedBox(width: 10),
          Text(
              'The robot is being controlled by someone else please try again later'),
        ],
      ),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          SystemChrome.setEnabledSystemUIOverlays([]);
          // Some code to undo the change.
        },
      ),
    );
    profileBloc = BlocProvider.of(context).profileBloc;
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async => false,
        child: Stack(
          children: <Widget>[
            _viewRows(),
            _toolbar(),
            widget.isRobotview ? Container() : _joystick(),
            Builder(
              builder: (context) => StreamBuilder<String>(
                stream: dPadDirection.availability,
                builder: (_, snapshot) {
                  print(snapshot.data);
                  if (snapshot.data == "not available") {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Scaffold.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(snackBar);
                    });

                    return Container();
                  } else {
                    return Container();
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
