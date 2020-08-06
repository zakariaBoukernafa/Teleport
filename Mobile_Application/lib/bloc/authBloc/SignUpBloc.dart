import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:teleport/modes/users/auth.dart';

import '../Events.dart';
import '../Validator.dart';

class SignUpBloc extends Object with Validator implements BaseBloc {
  //initiate phone number authentication instance
  final AuthService _auth = new AuthService();

  //initiate email  & password Streams

  final _userNameController = BehaviorSubject<String>();

  final _emailController = BehaviorSubject<String>();

  final _passwordController = BehaviorSubject<String>();

  final _robotIDController = BehaviorSubject<String>();

  final _stateController = BehaviorSubject<String>();

  //initiate Registration Event Stream
  final _signUpEventController = StreamController<Events>();

  // Create the sink for the the email&password stream

  StreamSink<String> get userNameChanged => _userNameController.sink;

  StreamSink<String> get emailChanged => _emailController.sink;

  StreamSink<String> get passwordChanged => _passwordController.sink;

  StreamSink<String> get robotIDChanged => _robotIDController.sink;

  StreamSink<String> get stateSink => _stateController.sink;

  Stream<String> get state => _stateController.stream;

  //Check if the email&password  is valid or not

  Stream<String> get userName => _userNameController.stream;

  Stream<String> get email => _emailController.stream.transform(emailValidator);

  Stream<String> get password =>
      _passwordController.stream.transform(passwordValidator);

  Stream<String> get robotID => _robotIDController.stream;

  Sink<Events> get signUpEventSink => _signUpEventController.sink;

  SignUpBloc() {
    _signUpEventController.stream.listen(_registrationEventToState);
  }

  void _registrationEventToState(Events event) async {
    if (event is SignUpEvent) {
      try {
        FirebaseUser user = await _auth.signUp(
            _emailController.value.replaceAll(' ', ''),
            _passwordController.value);


        await _auth.databaseSignUp(
            user, _userNameController.value, _robotIDController.value).then((onValue) {
          stateSink.add("Success");
        });
      } catch (e) {
        switch (e.code) {
          case "ERROR_OPERATION_NOT_ALLOWED":
            emailChanged.addError("Anonymous accounts are not enabled");
            break;
          case "ERROR_WEAK_PASSWORD":
            passwordChanged.addError("Your password is too weak");
            break;
          case "ERROR_INVALID_EMAIL":
            emailChanged.addError("this email is invalid");

            break;
          case "ERROR_EMAIL_ALREADY_IN_USE":
            emailChanged.addError("this email is already in use");
            break;
          case "ERROR_INVALID_CREDENTIAL":
            emailChanged.addError("this email is invalid");
            break;

          default:
            emailChanged.addError("An undefined Error happened.");
        }
        stateSink.add("error");

        print(e);
      }
    }
  }

  //Close Streams when Done
  @override
  void dispose() {
    _userNameController?.close();
    _emailController?.close();
    _signUpEventController?.close();
    _passwordController?.close();
    _robotIDController?.close();
    _stateController?.close();
    stateSink?.close();
    userNameChanged?.close();
    emailChanged?.close();
    signUpEventSink?.close();
    robotIDChanged?.close();
    stateSink?.close();
  }
}

abstract class BaseBloc {
  void dispose();
}
