import 'package:web_socket_channel/io.dart';

class Aws {
  final awsChannel = IOWebSocketChannel.connect(
    '',
  );

  void sendDirection(String direction,String robotID){
    print("triggerd");
    awsChannel.sink.add('{    "action": "sendMessage","direction":"$direction","robotID":"$robotID"}');

  }

  Stream dataListener(){
    awsChannel.stream.listen((event) {
      print(event);
    });
    return awsChannel.stream;
  }

}