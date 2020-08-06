import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teleport/bloc/Bloc_provider.dart';
import 'package:teleport/bloc/Events.dart';
import 'package:teleport/bloc/authBloc/profileBloc.dart';
import 'package:teleport/modes/localization/AppLocalizations.dart';

import 'app_theme.dart';

class EditRobotId extends StatefulWidget {
  @override
  _EditRobotIdState createState() => _EditRobotIdState();
}

class _EditRobotIdState extends State<EditRobotId> {
  TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }
  AppLocalizations text;

  Widget _buildComposer(ProfileBloc profileBloc) {
    return Padding(
      padding: EdgeInsets.only(top: 16, left: 32, right: 32),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey.withOpacity(0.8),
                offset: Offset(4, 4),
                blurRadius: 8),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Container(
            padding: EdgeInsets.all(4.0),
            constraints: BoxConstraints(minHeight: 80, maxHeight: 160),
            color: AppTheme.white,
            child: SingleChildScrollView(
              padding: EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0),
              child: StreamBuilder(
                  stream: profileBloc.robotID,
                  builder: (context, snapshot) {
                    return TextFormField(
                      controller: _textController,
                      onChanged: (event) => profileBloc.robotIDSink.add(event),
                      style: TextStyle(
                        fontFamily: AppTheme.fontName,
                        fontSize: 16,
                        color: AppTheme.dark_grey,
                      ),
                      cursorColor: Colors.blue,
                      decoration: InputDecoration(
                          errorText: text.translate(snapshot.error),
                          border: InputBorder.none,
                          hintText: text.translate('Edit Robot id')),
                    );
                  }),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ProfileBloc profileBloc = BlocProvider.of(context).profileBloc;
    text = AppLocalizations.of(context);
    return DoubleBackToCloseApp(
      snackBar: SnackBar(
        content:  Text(text.translate('Tap again to exit the app.')),
      ),
      child: Container(
        color: AppTheme.nearlyWhite,
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(top: 24.0),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 24.0),
                  Container(
                    padding: EdgeInsets.only(top: 8),
                    child:  Text(
                      text.translate('Choose another robot',),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _buildComposer(profileBloc),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: ButtonTheme(
                      minWidth: 100,
                      height: 40,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      child: RaisedButton(
                          splashColor: Colors.white,
                          color: Colors.black87,
                          child: Text(
                            'Edit',
                            style: GoogleFonts.roboto(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            profileBloc.profileInfos.add(ChangeRobotIdEvent());
                            _textController.clear();
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text(text.translate('Robot ID edited successfully')),
                              backgroundColor: Colors.green,
                            ));
                          }),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
