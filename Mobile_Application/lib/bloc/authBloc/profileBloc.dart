import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:teleport/modes/users/auth.dart';
import 'package:teleport/services/database.dart';

import '../Events.dart';
import '../Validator.dart';

class ProfileBloc extends Object with Validator implements BaseBloc {
  final DatabaseService _db = DatabaseService();
  final AuthService _auth = AuthService();

  //initiate  Streams for the database
  final _userid = BehaviorSubject<String>();
  final _userName = BehaviorSubject<String>();
  final _email = BehaviorSubject<String>();
  final _robotID = BehaviorSubject<String>();
  final _isemailVerified = BehaviorSubject<bool>();
  final _getPorfileDetails = StreamController<Events>();

  ////////////////////////////////////
  final _getRobotId = BehaviorSubject<String>();
  StreamSink<String> get getRobotIdSink => _getRobotId.sink;
  Stream<String> get getRobotIdController => _getRobotId.stream;

  ///////////////////////////////////

  // Create the sink for the the database streams.
  StreamSink<String> get useridSink => _userid.sink;

  StreamSink<String> get userNameSink => _userName.sink;

  StreamSink<String> get emailSink => _email.sink;

  StreamSink<String> get robotIDSink => _robotID.sink;

  StreamSink<bool> get isEmailVerifiedSink => _isemailVerified.sink;

  //create getters for the private data
  Stream<String> get userid => _userid.stream;

  Stream<String> get userName => _userName.stream;

  String get userNameValue => _userName.value;

  String get robotIdValue => _robotID.value;

  //
  String get userIdValue => _userid.value;

  Stream<String> get email => _email.stream;

  Stream<String> get robotID =>
      _robotID.stream.transform(channelInputValidator);

  Stream<bool> get isEmailVerified => _isemailVerified.stream;

  //this one is for the event
  Sink<Events> get profileInfos => _getPorfileDetails.sink;

  //and this one keeps track of the event
  ProfileBloc() {
    _getPorfileDetails.stream.listen(_getProfileEventToState);
  }
  //get the data from the database and then pass it into the stream sinks
  void _getProfileEventToState(Events event) async {
    if (event is ProfileEvent) {
      try {
        print("getting user");
        var user = await _auth.getUserID();
        _db.streamUsers(user).listen((onData) {
          userNameSink.add(onData.username);
          emailSink.add(onData.email);
          isEmailVerifiedSink.add(onData.isEmailVerified);
          useridSink.add(onData.userId);
          print("robot id is ${onData.robotId}");
          robotIDSink.add(onData.robotId);
        });
      } catch (e) {
        print("error");
        print(e);
      }
    }
    if (event is SignOutEvent) {
      await _auth.signOut();

      userNameSink.add(null);
      emailSink.add(null);
      isEmailVerifiedSink.add(null);
      robotIDSink.add(null);

      print("signed out");
    }
    if (event is ChangeRobotIdEvent) {
      var user = await _auth.getUserID();
      await _auth.robotUpdate(user, _robotID.value);
    }

    if (event is DisconnectCurrentUser) {
      final String currentUser = await _db.getCurrentUser(_robotID.value);
      if (_userid.value == currentUser || currentUser == null) {
        await _db.disconnectUser(_robotID.value);
      }
      print("disconnected");
    }
  }

  //Close Streams when Done
  @override
  void dispose() {
    _userid?.close();
    _userName?.close();
    _email?.close();
    _isemailVerified?.close();
    _robotID?.close();
    _getPorfileDetails?.close();
    _getRobotId?.close();
  }
}

abstract class BaseBloc {
  void dispose();
}
