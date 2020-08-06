import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:rxdart/rxdart.dart';
import 'package:teleport/services/aws.dart';
import 'package:teleport/services/database.dart';

import 'Events.dart';

class DpadModeBloc extends Object implements BaseBloc {
  //Firebase
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final DatabaseService _db = DatabaseService();
  final Aws aws = Aws();

  //Color for the animation

  //initiate the stream containing the direction of the Stream to be set in the Database
  final _degreeStreamController = BehaviorSubject<double>();
  final _distanceStreamController = BehaviorSubject<double>();

  final _robotIdController = BehaviorSubject<String>();
  final _userIdController = BehaviorSubject<String>();

  //initiate the stream containing the events of data
  final _availabilityController = BehaviorSubject<String>();
  final _dPadDirectionEventController = BehaviorSubject<Events>();

  //here we add the directions coming from the dpad up/down/left/right (input)
  StreamSink<double> get degreeChanged => _degreeStreamController.sink;

  StreamSink<double> get distanceChanged => _distanceStreamController.sink;

  StreamSink<String> get robotIDSink => _robotIdController.sink;

  StreamSink<String> get userNameSink => _userIdController.sink;

  StreamSink<String> get availabilitySink => _availabilityController.sink;

  //the stream of all  data
  Stream<double> get degree => _degreeStreamController.stream;

  Stream<double> get distance => _distanceStreamController.stream;

  Stream<String> get robotId => _robotIdController.stream;

  Stream<String> get userName => _userIdController.stream;

  Stream<String> get availability => _availabilityController.stream;

  //here we add the events to differentiate the types of events for future usage for now we only have one event in the class
  StreamSink<Events> get dPadDirectionEventSink =>
      _dPadDirectionEventController.sink;

  //we consistently need to listen to the events
  DpadModeBloc() {
    _dPadDirectionEventController.stream.listen(_dPadDirectionEventToState);
  }

  //this function gets the event and reference the database to add the new data
  void _dPadDirectionEventToState(Events event) async {
    if (event is DpadDirectionEvent) {
      double _degree = _degreeStreamController.value;
      double _distance = _distanceStreamController.value;
      final String currentUser =
          await _db.getCurrentUser(_robotIdController.value);
      if (currentUser == null) {
        _database.reference().child(_robotIdController.value).set({
          'user': _userIdController.value,
        });
      }
      if (_userIdController.value == currentUser || currentUser == null) {
        availabilitySink.add("available");
        if (_degree >= 60.00 && _degree <= 130.00 && _distance != 0) {
          aws.sendDirection("DOWN", _robotIdController.value);
          print('down');
        } else if ((_degree >= 330.00 && _degree <= 360.00 && _distance != 0) ||
            (_degree > 0.00 && _degree <= 30.00 && _distance != 0)) {
          aws.sendDirection("RIGHT", _robotIdController.value);
          print('right');
        } else if (_degree >= 150.00 && _degree <= 210.00 && _distance != 0) {
          aws.sendDirection("LEFT", _robotIdController.value);
          print('left');
        } else if (_degree >= 240.00 && _degree <= 300.00 && _distance != 0) {
          aws.sendDirection("UP", _robotIdController.value);
          print('up');
        } else if (_degree > 30.00 && _degree < 60.00 && _distance != 0) {
          aws.sendDirection("DOWN RIGHT", _robotIdController.value);
          print('down right');
        } else if (_degree > 130.00 && _degree < 150.00 && _distance != 0) {
          aws.sendDirection("DOWN LEFT", _robotIdController.value);
          print('down left');
        } else if (_degree > 210.00 && _degree < 240.00 && _distance != 0) {
          aws.sendDirection("UP LEFT", _robotIdController.value);
          print('up left');
        } else if (_degree > 300.00 && _degree < 330.00 && _distance != 0) {
          aws.sendDirection("UP RIGHT", _robotIdController.value);
          print('up right ');
        } else {
          aws.sendDirection("STOPPED", _robotIdController.value);
          print('stopped');
        }
      } else {
        print("not available");
        availabilitySink.add("not available");
      }
    }
  }

  //close the streams to avoid memory leaks
  @override
  void dispose() {
    _distanceStreamController?.close();
    _degreeStreamController?.close();
    _dPadDirectionEventController?.close();
    _robotIdController?.close();
    _userIdController?.close();
    _availabilityController?.close();
  }
}

abstract class BaseBloc {
  void dispose();
}
