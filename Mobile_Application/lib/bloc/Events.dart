import 'package:teleport/modes/localization/Languages.dart';

abstract class Events {}

//Defines the type of the event to be added in the stream
class DirectionEvent extends Events {}

//Dpad Movements event
class DpadDirectionEvent extends Events {}

//Channel input Event
class ChannelEvent extends Events {}

class SignUpEvent extends Events {}

class SignInEvent extends Events {}

class ProfileEvent extends Events {}

class SignOutEvent extends Events {}

class PasswordResetRequestEvent extends Events {}

class PasswordResetEvent extends Events {}

class ChangeRobotIdEvent extends Events {}

class DisconnectCurrentUser extends Events {}

class LanguageLoadEvent extends Events {}

class LanguageSelectEvent extends Events {
  final Language languageCode;

  LanguageSelectEvent(this.languageCode) : assert(languageCode != null);
}
