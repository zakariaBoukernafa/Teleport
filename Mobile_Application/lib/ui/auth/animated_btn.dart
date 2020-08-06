import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teleport/bloc/Bloc_provider.dart';
import 'package:teleport/bloc/Events.dart';
import 'package:teleport/bloc/authBloc/SignUpBloc.dart';
import 'package:teleport/bloc/authBloc/loginBloc.dart';
import 'package:teleport/modes/localization/AppLocalizations.dart';

class AnimatedButton extends StatefulWidget {
  final String text;
  final Color color;
  AnimatedButton({Key key, this.title, this.text, this.color})
      : super(key: key);

  final String title;

  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with TickerProviderStateMixin {
  int _state = 0;
  Animation _animation;
  AnimationController _controller;
  GlobalKey _globalKey = GlobalKey();
  double _width = 300;
  bool _isLogin = false;
  AppLocalizations text;

  @override
  void initState() {
    super.initState();
    switch (widget.text) {
      case 'Login':
        _isLogin = true;
        break;
      case 'Sign Up':
        _isLogin = false;
        break;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final signInBloc = BlocProvider.of(context).signInBloc;
    final signUpBloc = BlocProvider.of(context).signUpBloc;
    text = AppLocalizations.of(context);

    return StreamBuilder(
        stream: _isLogin ? signInBloc.email : signUpBloc.email,
        builder: (context, snapshot) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Align(
                alignment: Alignment.center,
                child: PhysicalModel(
                  shadowColor: widget.color,
                  color: widget.color,
                  borderRadius: BorderRadius.circular(25),
                  child: Container(
                    key: _globalKey,
                    height: 50,
                    width: _width,
                    child: RaisedButton(
                      splashColor: Colors.white,
                      animationDuration: Duration(milliseconds: 700),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: EdgeInsets.all(0),
                      child: setUpButtonChild(signInBloc, signUpBloc),
                      onPressed: () {
                        setState(() {
                          switch (widget.text) {
                            case 'Login':
                              signInBloc.signUpEventSink.add(SignInEvent());
                              if (snapshot.hasData) {
                                if (_state == 0) {
                                  signInBloc.state.listen((data) {
                                    if (data == 'Success') {
                                      animateButton();
                                    } else {
                                      return null;
                                    }
                                  });
                                }
                              }
                              break;
                            case 'Sign up':
                              signUpBloc.signUpEventSink.add(SignUpEvent());
                              if (snapshot.hasData) {
                                if (_state == 0) {
                                  signUpBloc.state.listen((data) {
                                    if (data == 'Success') {
                                      animateButton();
                                    } else {
                                      return null;
                                    }
                                  });
                                }
                              }
                              break;
                          }
                        });
                      },
                      color: widget.color,
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  setUpButtonChild(SignInBloc signInBloc, SignUpBloc signUpBloc) {
    if (_state == 0) {
      ///Before Click
      return Text(text.translate(widget.text),
          style: GoogleFonts.roboto(
              fontWeight: FontWeight.bold, fontSize: 25, color: Colors.white));
    } else if (_state == 1) {
      /// After Click
      return SizedBox(
        height: 36,
        width: 36,
        child: CircularProgressIndicator(
          //value: null,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    } else {
      signInBloc.state.listen((data) {
        if (data == 'Success') {
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/HomePage', (Route<dynamic> route) => false);
          signInBloc.stateSink.add('done');
          signInBloc.emailChanged.add('');
          signInBloc.passwordChanged.add('');
        }
      });
      signUpBloc.state.listen((data) {
        if (data == 'Success') {
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/HomePage', (Route<dynamic> route) => false);
          signUpBloc.stateSink.add('done');
          signUpBloc.emailChanged.add('');
          signUpBloc.passwordChanged.add('');
        }
      });
      return Icon(Icons.check, color: Colors.white);
    }
  }

  void animateButton() {
    double initialWidth = _globalKey.currentContext.size.width;
    _controller =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);

    _animation = Tween(begin: 0.0, end: 1).animate(_controller)
      ..addListener(() {
        setState(() {
          _width = initialWidth - ((initialWidth - 60) * _animation.value);
        });
      });
    _controller.forward();

    setState(() {
      _state = 1;
    });

    Future.delayed(Duration(milliseconds: 2000), () {
      setState(() {
        _state = 2;
      });
    });
  }
}
