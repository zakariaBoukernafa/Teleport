import 'dart:async';

mixin Validator {
  static final emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  //Channel input validator
  var channelInputValidator = StreamTransformer<String, String>.fromHandlers(
      handleData: (channel, sink) {
    if (channel.length > 0)
      sink.add(channel);
    else
      sink.addError('Channel name cannot be empty');
  });

  //Email validator
  var emailValidator =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (email.contains(emailRegex)) {
      sink.add(email);
    } else {
      sink.addError("Invalid email");
    }
  });

  //passwordValidator
  var passwordValidator = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    if (password.length > 5)
      sink.add(password);
    else {
      sink.addError("password length must be 6 or more characters");
    }
  });
}
