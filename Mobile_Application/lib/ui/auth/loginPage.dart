import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teleport/bloc/Bloc_provider.dart';
import 'package:teleport/modes/localization/AppLocalizations.dart';
import 'package:teleport/ui/auth/passwordResetRequest.dart';
import 'package:teleport/ui/auth/signUp.dart';

import 'animated_btn.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  AppLocalizations text;

  @override
  Widget build(BuildContext context) {
    final signInBloc = BlocProvider.of(context).signInBloc;
    text = AppLocalizations.of(context);

    return Scaffold(
      body: ListView(
        children: <Widget>[
          LoginTopTexts(),
          SizedBox(height: 35),
          LoginTextFields(signInBloc: signInBloc),
          ForgotPasswordButton(),
          SizedBox(height: 50),
          AnimatedButton(text: "Login", color: Colors.green[400]),
          SizedBox(height: 20),
          NoAccountButton(),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

class LoginTopTexts extends StatelessWidget {
  AppLocalizations text;

  LoginTopTexts({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    text = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 60),
          Text(text.translate('Hello'),
              style: GoogleFonts.roboto(
                  fontSize: 50, fontWeight: FontWeight.bold)),
          Row(
            children: <Widget>[
              Container(
                // padding: const EdgeInsets.fromLTRB(20, 160, 5, 0),
                child: Text(text.translate('there'),
                    style: GoogleFonts.roboto(
                        fontSize: 50, fontWeight: FontWeight.bold)),
              ),
              Container(
                //padding: const EdgeInsets.fromLTRB(0, 150, 5, 0),
                child: Text(
                  '.',
                  style: GoogleFonts.roboto(
                      color: Colors.green[300],
                      fontSize: 50,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class NoAccountButton extends StatelessWidget {
  NoAccountButton({
    Key key,
  }) : super(key: key);
  AppLocalizations text;
  @override
  Widget build(BuildContext context) {
    text = AppLocalizations.of(context);

    return Row(
      children: <Widget>[
        Container(
          //TODO
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            text.translate('Dont have an account?'),
            style: GoogleFonts.roboto(color: Colors.black87, fontSize: 15),
          ),
        ),
        //TODO
        SizedBox(width: 3),
        Material(
          borderRadius: BorderRadius.circular(23),
          child: InkWell(
            child: Center(
                child: Text(text.translate('Sign up'),
                    style: GoogleFonts.roboto(
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.green[400],
                    ))),
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        SignUp(),
                    //transitionDuration: Duration(milliseconds: 500),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      var begin = Offset(0.0, -1.0);
                      var end = Offset.zero;
                      var tween = Tween(begin: begin, end: end);
                      var offsetAnimation = animation.drive(tween);
                      return SlideTransition(
                        position: offsetAnimation,
                        child: child,
                      );
                    }),
              );
            }, //TODO: To be implemented.
          ),
        ),
      ],
    );
  }
}

class ForgotPasswordButton extends StatelessWidget {
  const ForgotPasswordButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppLocalizations text = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.only(top: 20, right: 18),
      alignment: Alignment.centerRight,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    PasswordResetRequest(),
                // transitionDuration: Duration(milliseconds: 500),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  var begin = Offset(0.0, 1.0);
                  var end = Offset.zero;
                  var tween = Tween(begin: begin, end: end);
                  var offsetAnimation = animation.drive(tween);
                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  );
                }),
          );
        },
        child: Text(text.translate('Forgot password?'),
            style: GoogleFonts.roboto(
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Colors.green[400],
            )),
      ),
    );
  }
}

class LoginTextFields extends StatefulWidget {
  final signInBloc;

  LoginTextFields({Key key, this.signInBloc}) : super(key: key);

  @override
  _LoginTextFieldsState createState() => _LoginTextFieldsState();
}

class _LoginTextFieldsState extends State<LoginTextFields> {
  bool isPasswordvisible = false;
  AppLocalizations text;

  void _toggle() {
    setState(() {
      isPasswordvisible = !isPasswordvisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    text = AppLocalizations.of(context);

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: StreamBuilder(
              stream: widget.signInBloc.email,
              builder: (context, snapshot) {
                return TextFormField(
                  onChanged: (event) {
                    widget.signInBloc.emailChanged.add(event);
                  },
                  cursorColor: Colors.grey,
                  obscureText: false,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    errorText: text.translate(snapshot.error),
                    fillColor: Colors.grey[200],
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15))),
                    hintText: text.translate('Enter your email'),
                    prefixIcon: Icon(Icons.email, color: Colors.grey[700]),
                    alignLabelWithHint: true,
                    contentPadding: const EdgeInsets.only(top: 15, bottom: 10),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(15),
                          bottomLeft: Radius.circular(15)),
                      borderSide: BorderSide(
                        color: Colors.green,
                      ),
                    ),
                  ),
                );
              }),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16, left: 20, right: 20),
          child: StreamBuilder(
              stream: widget.signInBloc.password,
              builder: (context, snapshot) {
                return TextFormField(
                  onChanged: (event) {
                    widget.signInBloc.passwordChanged.add(event);
                  },
                  cursorColor: Colors.grey,
                  textCapitalization: TextCapitalization.sentences,
                  obscureText: isPasswordvisible ? false : true,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15))),
                    errorText: text.translate(snapshot.error),
                    fillColor: Colors.grey[200],
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15))),
                    contentPadding: const EdgeInsets.only(top: 15, bottom: 10),
                    hintText: text.translate('Enter your password'),
                    suffixIcon: GestureDetector(
                      child: Icon(
                        isPasswordvisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey[700],
                      ),
                      onTap: () {
                        _toggle();
                      },
                    ),
                    prefixIcon: Icon(Icons.vpn_key, color: Colors.grey[700]),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(15),
                          bottomLeft: Radius.circular(15)),
                      borderSide: BorderSide(
                        color: Colors.green,
                      ),
                    ),
                  ),
                );
              }),
        ),
      ],
    );
  }
}

/* class LoginButton extends StatelessWidget {
  final SignInBloc signInBloc;
  const LoginButton({
    Key key,
    this.signInBloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Center(
        child: Material(
          type: MaterialType.button,
          elevation: 3.0,
          borderRadius: BorderRadius.circular(23),
          color: Colors.green[400],
          child: Container(
            height: 50,
            width: 300,
            child: Center(
                child: Text('Login',
                    style: GoogleFonts.roboto(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.white))),
          ),
        ),
      ),
      onTap: () {
        signInBloc.signUpEventSink.add(SignInEvent());
      },
    );
  }
} */
