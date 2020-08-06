import 'dart:async';

import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';

import 'ArrowsModeBloc.dart';
import 'Events.dart';
import 'Validator.dart';

class IndexAgoraBloc extends Object  with Validator implements BaseBloc {
  
  //Channel input Stream
  final _channelController      = BehaviorSubject<String>();

  //Input event
  final _channelEventController = StreamController<Events>();

  //Sink getter
  Sink<String> get channelInputChanged => _channelController.sink;

  //Stream getter
  Stream<String> get channel           => _channelController.stream.transform(channelInputValidator);
  //Event sink getter
  Sink<Events> get channelEventSink    => _channelEventController.sink;

  String get channelValue              => _channelController.value;

  IndexAgoraBloc(){
    _channelEventController.stream.listen(_channelEventToState);
  }

  void _channelEventToState(Events event) async {
    if (event is ChannelEvent)
      {
        await _handleCameraAndMic();
      }
  }

  Future<void> _handleCameraAndMic() async {
    await PermissionHandler().requestPermissions(
      [PermissionGroup.camera, PermissionGroup.microphone],
    );
  }

  @override
  void dispose() {
  _channelEventController?.close();
  _channelController?.close();
  }

}