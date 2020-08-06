import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teleport/bloc/Bloc_provider.dart';
import 'package:teleport/bloc/Events.dart';
import 'package:teleport/bloc/authBloc/passwordResetBloc.dart';
import 'package:teleport/modes/localization/AppLocalizations.dart';

class PasswordResetRequest extends StatelessWidget {
  AppLocalizations text;

  @override
  Widget build(BuildContext context) {
    final passwordReset = BlocProvider.of(context).passwordResetBloc;
    text = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leading: BackButton(color: Colors.black87),
      ),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            ResetTopText(),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Text(text.translate("reset text"),
                  style: GoogleFonts.roboto(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.w400,
                      fontSize: 15)),
            ),
            SizedBox(height: 20),
            ResetTextField(passwordReset: passwordReset),
            ResetButton(passwordReset: passwordReset),
          ],
        ),
      ),
    );
  }
}

class ResetButton extends StatelessWidget {
  ResetButton({
    Key key,
    @required this.passwordReset,
  }) : super(key: key);

  final PasswordResetBloc passwordReset;
  AppLocalizations text;

  @override
  Widget build(BuildContext context) {
    text = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: 15, left: 100, right: 100),
      child: ButtonTheme(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15))),
        child: RaisedButton(
          color: Colors.red[400],
          splashColor: Colors.white,
          child: Center(
            child: Text(
              text.translate('Send'),
              style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 17),
            ),
          ),
          onPressed: () {
            passwordReset.passwordRestEventSink
                .add(PasswordResetRequestEvent());
          },
        ),
      ),
    );
  }
}

class ResetTextField extends StatelessWidget {
  ResetTextField({
    Key key,
    @required this.passwordReset,
  }) : super(key: key);

  final PasswordResetBloc passwordReset;
  AppLocalizations text;

  @override
  Widget build(BuildContext context) {
    text = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: StreamBuilder(
          stream: passwordReset.email,
          builder: (context, snapshot) {
            return TextFormField(
              onChanged: (event) {
                passwordReset.emailChanged.add(event);
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
                    color: Colors.red[400],
                  ),
                ),
              ),
            );
          }),
    );
  }
}

class ResetTopText extends StatelessWidget {
  ResetTopText({
    Key key,
  }) : super(key: key);
  AppLocalizations text;

  @override
  Widget build(BuildContext context) {
    text = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: <Widget>[
          Wrap(
            children: <Widget>[
              Container(
                //padding: const EdgeInsets.fromLTRB(20, 50, 5, 0),
                child: Text(text.translate('Reset password'),
                    style: GoogleFonts.roboto(
                        fontSize: 40, fontWeight: FontWeight.bold)),
              ),
              Text(
                '.',
                style: GoogleFonts.roboto(
                    color: Colors.redAccent,
                    fontSize: 40,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          // Positioned(
          //   left: 240,
          //   top: 108,
          //   child: Container(
          //     padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          //     child: Text(
          //       '.',
          //       style: GoogleFonts.roboto(
          //           color: Colors.redAccent,
          //           fontSize: 50,
          //           fontWeight: FontWeight.bold),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
