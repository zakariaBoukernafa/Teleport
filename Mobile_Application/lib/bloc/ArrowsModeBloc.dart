import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';

import 'Events.dart';

class ArrowsModeBloc extends Object implements BaseBloc {

  //Firebase
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  //Color for the animation
  Color _color = Colors.blue;

  //initiate the stream containing the direction of the Stream to be set in the Database
  final _directionStreamController = BehaviorSubject<String>();

  //initiate the stream containing the events of data
  final _directionEventController = StreamController<Events>();

  //here we add the directions coming from the buttons up/down/left/right (input)
  Sink<String> get directionChanged => _directionStreamController.sink;

  //the stream of all  data
  Stream<String> get direction => _directionStreamController.stream;

  //here we add the events to differentiate the types of events for future usage ,for now we only have one event in the class
  Sink<Events> get directionEventSink => _directionEventController.sink;


  //we consistently need to listen to the events
  ArrowsModeBloc() {
    _directionEventController.stream.listen(_directionEventToState);
  }
  //this function gets the event and reference the database to add the new data
  void _directionEventToState(Events event) async {
    if (event is DirectionEvent) {
      _color = Colors.green;
      await _database.reference().child('position').set({
        'direction': _directionStreamController.value,
      });
    }
  }
//close the streams to avoid memory leaks
  @override
  void dispose() {
    _directionEventController?.close();
    _directionStreamController?.close();
  }
}

abstract class BaseBloc {
  void dispose();
}