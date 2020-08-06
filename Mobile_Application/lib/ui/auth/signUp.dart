import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teleport/bloc/Bloc_provider.dart';
import 'package:teleport/bloc/authBloc/SignUpBloc.dart';
import 'package:teleport/modes/localization/AppLocalizations.dart';

import 'animated_btn.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    final signUpBloc = BlocProvider.of(context).signUpBloc;

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: BackButton(color: Colors.black87)),
      body: ListView(
        children: <Widget>[
          SignupTopTexts(),
          SignupTextFields(signUpBloc: signUpBloc),
          SizedBox(height: 50),
          AnimatedButton(text: 'Sign up', color: Colors.blue),
        ],
      ),
    );
  }
}

class SignupTopTexts extends StatelessWidget {
  SignupTopTexts({
    Key key,
  }) : super(key: key);
  AppLocalizations text;

  @override
  Widget build(BuildContext context) {
    text = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 30),
            child: Text(text.translate('Sign up'),
                style: GoogleFonts.roboto(
                    fontSize: 50, fontWeight: FontWeight.bold)),
          ),
          Container(
            //padding: const EdgeInsets.fromLTRB(190, 20, 0, 20),
            child: Text(
              '.',
              style: GoogleFonts.roboto(
                  color: Colors.blueAccent,
                  fontSize: 50,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

class SignupTextFields extends StatefulWidget {
  final SignUpBloc signUpBloc;
  const SignupTextFields({
    Key key,
    this.signUpBloc,
  }) : super(key: key);

  @override
  _SignupTextFieldsState createState() => _SignupTextFieldsState();
}

class _SignupTextFieldsState extends State<SignupTextFields> {
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
              stream: widget.signUpBloc.userName,
              builder: (context, snapshot) {
                return TextFormField(
                  onChanged: (event) {
                    widget.signUpBloc.userNameChanged.add(event);
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
                    hintText: text.translate('User name'),
                    prefixIcon: Icon(Icons.person_pin, color: Colors.grey[700]),
                    alignLabelWithHint: true,
                    contentPadding: const EdgeInsets.only(top: 15, bottom: 10),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(15),
                          bottomLeft: Radius.circular(15)),
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                );
              }),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16, left: 20, right: 20),
          child: StreamBuilder(
              stream: widget.signUpBloc.email,
              builder: (context, snapshot) {
                return TextFormField(
                  onChanged: (event) {
                    widget.signUpBloc.emailChanged.add(event);
                  },
                  cursorColor: Colors.grey,
                  textCapitalization: TextCapitalization.sentences,
                  obscureText: false,
                  decoration: InputDecoration(
                    errorText: text.translate(snapshot.error),
                    fillColor: Colors.grey[200],
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15))),
                    contentPadding: const EdgeInsets.only(top: 15, bottom: 10),
                    hintText: text.translate('email'),
                    prefixIcon: Icon(Icons.email, color: Colors.grey[700]),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(15),
                          bottomLeft: Radius.circular(15)),
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                );
              }),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16, left: 20, right: 20),
          child: StreamBuilder(
              stream: widget.signUpBloc.password,
              builder: (context, snapshot) {
                return TextFormField(
                  onChanged: (event) {
                    widget.signUpBloc.passwordChanged.add(event);
                  },
                  cursorColor: Colors.grey,
                  textCapitalization: TextCapitalization.sentences,
                  obscureText: isPasswordvisible ? false : true,
                  decoration: InputDecoration(
                    errorText: text.translate(snapshot.error),
                    fillColor: Colors.grey[200],
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15))),
                    contentPadding: const EdgeInsets.only(top: 15, bottom: 10),
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
                    hintText: text.translate('password'),
                    prefixIcon: Icon(Icons.vpn_key, color: Colors.grey[700]),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(15),
                          bottomLeft: Radius.circular(15)),
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                );
              }),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16, left: 20, right: 20),
          child: StreamBuilder(
              stream: widget.signUpBloc.robotID,
              builder: (context, snapshot) {
                return TextFormField(
                  onChanged: (event) {
                    widget.signUpBloc.robotIDChanged.add(event);
                  },
                  cursorColor: Colors.grey,
                  textCapitalization: TextCapitalization.sentences,
                  obscureText: false,
                  decoration: InputDecoration(
                    errorText: text.translate(snapshot.error),
                    fillColor: Colors.grey[200],
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15))),
                    contentPadding: const EdgeInsets.only(top: 15, bottom: 10),
                    hintText: text.translate('Robot ID'),
                    prefixIcon:
                        Icon(Icons.bookmark_border, color: Colors.grey[700]),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(15),
                          bottomLeft: Radius.circular(15)),
                      borderSide: BorderSide(
                        color: Colors.blue,
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

/* class SignUpButton extends StatelessWidget {
  const SignUpButton({
    Key key,
    @required this.signUpBloc,
  }) : super(key: key);

  final SignUpBloc signUpBloc;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 100, right: 100),
      child: GestureDetector(
        child: Material(
          elevation: 3.0,
          clipBehavior: Clip.antiAlias,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            color: Colors.blueAccent,
            width: 200,
            height: 40,
            child: Center(
                child: Text('Sign up',
                    style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold))),
          ),
        ),
        onTap: () {
          signUpBloc.signUpEventSink.add(SignUpEvent());
        },
      ),
    );
  }
} */
