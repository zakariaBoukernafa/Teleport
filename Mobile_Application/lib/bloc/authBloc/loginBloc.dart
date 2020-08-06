import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:teleport/modes/users/auth.dart';

import '../Events.dart';
import '../Validator.dart';

class SignInBloc extends Object with Validator implements BaseBloc {
  //initiate phone number authentication instance
  final AuthService _auth = new AuthService();

  //initiate email  & password Streams

  final _emailController = BehaviorSubject<String>();

  final _passwordController = BehaviorSubject<String>();

  final _stateController = BehaviorSubject<String>();

  //initiate Registration Event Stream
  final _signUpEventController = StreamController<Events>();

  // Create the sink for the the email&password stream

  StreamSink<String> get emailChanged => _emailController.sink;

  StreamSink<String> get passwordChanged => _passwordController.sink;

  StreamSink<String> get stateSink => _stateController.sink;

  //Check if the email&password  is valid or not

  Stream<String> get email => _emailController.stream.transform(emailValidator);

  Stream<String> get password =>
      _passwordController.stream.transform(passwordValidator);

  Stream<String> get state => _stateController.stream;

  Sink<Events> get signUpEventSink => _signUpEventController.sink;

  SignInBloc() {
    _signUpEventController.stream.listen(_registrationEventToState);
  }

  void _registrationEventToState(Events event) async {
    if (event is SignInEvent) {
      try {
        await _auth
            .signIn(_emailController.value.replaceAll(' ', ''),
            _passwordController.value)
            .then((onValue) {
          stateSink.add("Success");
        });
      } catch (e) {
        switch (e.code) {
          case "ERROR_INVALID_EMAIL":
            emailChanged.addError(
                "Your email address appears to be malformed.");
            break;
          case "ERROR_WRONG_PASSWORD":
            passwordChanged.addError("wrong password.");
            break;
          case "ERROR_USER_NOT_FOUND":
            emailChanged.addError("this email does not exist.");

            break;
          case "ERROR_USER_DISABLED":
            emailChanged.addError("this email disabled.");
            break;
          case "ERROR_TOO_MANY_REQUESTS":
            emailChanged.addError("Too many requests. Try again later.");
            break;
          case "ERROR_OPERATION_NOT_ALLOWED":
            emailChanged.addError(
                "Signing in with Email and Password is not enabled.");
            break;
          default:
            emailChanged.addError("An undefined Error happened.");
        }
        stateSink.add("Wrong Email or password");
        print(e);
      }
    }
  }

  //Close Streams when Done
  @override
  void dispose() {
    _emailController?.close();
    _signUpEventController?.close();
    _passwordController?.close();
    _stateController?.close();
  }
}

abstract class BaseBloc {
  void dispose();
}
