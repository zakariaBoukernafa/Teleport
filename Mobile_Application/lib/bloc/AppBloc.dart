import 'package:teleport/bloc/authBloc/profileBloc.dart';
import 'ArrowsModeBloc.dart';
import 'DpadBloc.dart';
import 'IndexAgoraBloc.dart';
import 'authBloc/SignUpBloc.dart';
import 'authBloc/loginBloc.dart';
import 'authBloc/passwordResetBloc.dart';
import 'localizationBloc/LocalizationBloc.dart';

class AppBloc {
  /// A class made to provide the Blocs to the widget tree , but instead of exposing the
  /// streams directly , this class will be exposed for the blocProvider in main.dart
  ArrowsModeBloc _direction;
  DpadModeBloc _dPadDirection;
  IndexAgoraBloc _indexAgoraBloc;

  //auth
  SignUpBloc _signUpBloc;
  SignInBloc _signInBloc;
  ProfileBloc _profileBloc;
  PasswordResetBloc _passwordResetBloc;

  //localization
  LocalizationBloc _localizationBloc;

  AppBloc()
      : _direction = ArrowsModeBloc(),
        _dPadDirection = DpadModeBloc(),
        _indexAgoraBloc = IndexAgoraBloc(),
        _signUpBloc = SignUpBloc(),
        _signInBloc = SignInBloc(),
        _profileBloc = ProfileBloc(),
        _passwordResetBloc = PasswordResetBloc(),
        _localizationBloc = LocalizationBloc();

  ArrowsModeBloc get direction => _direction;

  DpadModeBloc get dPadDirection => _dPadDirection;

  IndexAgoraBloc get indexAgoraBloc => _indexAgoraBloc;

  SignUpBloc get signUpBloc => _signUpBloc;

  SignInBloc get signInBloc => _signInBloc;

  ProfileBloc get profileBloc => _profileBloc;

  PasswordResetBloc get passwordResetBloc => _passwordResetBloc;

  LocalizationBloc get localizationBloc => _localizationBloc;
}
