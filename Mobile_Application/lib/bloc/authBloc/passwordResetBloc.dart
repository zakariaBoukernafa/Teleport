import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:teleport/modes/users/auth.dart';

import '../Events.dart';
import '../Validator.dart';

class PasswordResetBloc extends Object with Validator implements BaseBloc {
  //initiate phone number authentication instance
  final AuthService _auth = new AuthService();

  //initiate email  & password Streams

  final _emailController = BehaviorSubject<String>();

  final _passwordController = BehaviorSubject<String>();

  final _stateController = BehaviorSubject<String>();

  final _oobCodeController = BehaviorSubject<String>();

  //initiate Registration Event Stream
  final _passwordRestEventController = StreamController<Events>();

  // Create the sink for the the email&password stream

  StreamSink<String> get emailChanged => _emailController.sink;

  StreamSink<String> get passwordChanged => _passwordController.sink;

  StreamSink<String> get stateSink => _stateController.sink;

  StreamSink<String> get oobCodeSink => _oobCodeController.sink;

  //Check if the email&password  is valid or not

  Stream<String> get email => _emailController.stream.transform(emailValidator);

  Stream<String> get password =>
      _passwordController.stream.transform(passwordValidator);

  Stream<String> get state => _stateController.stream;

  Stream<String> get oobCode => _oobCodeController.stream;

  //TODO: Refactor name to 'Reset'.
  Sink<Events> get passwordRestEventSink => _passwordRestEventController.sink;

  PasswordResetBloc() {
    _passwordRestEventController.stream.listen(_registrationEventToState);
  }

  void _registrationEventToState(Events event) async {
    if (event is PasswordResetRequestEvent) {
      try {
        await _auth.resetPasswordSend(_emailController.value).then((onValue) {
          stateSink.add("Password Sent");
        });
      } catch (e) {
        print(e);
      }
    }
    if (event is PasswordResetEvent) {
      try {
        await _auth
            .confirmPasswordChange(
            _oobCodeController.value, _passwordController.value)
            .then((onValue) {
          stateSink.add("password changed");
        });
      } catch (e) {
        stateSink.add("error");
        print(e);
      }
    }
  }

  //Close Streams when Done
  @override
  void dispose() {
    _emailController?.close();
    _passwordRestEventController?.close();
    _passwordController?.close();
    _stateController?.close();
    _oobCodeController?.close();
  }
}

abstract class BaseBloc {
  void dispose();
}
