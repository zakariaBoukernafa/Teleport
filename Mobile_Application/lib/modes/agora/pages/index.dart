import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teleport/bloc/Bloc_provider.dart';
import 'package:teleport/bloc/Events.dart';
import 'package:teleport/ui/whole_new_menu/ui_package/app_theme.dart';
import './call.dart';

class IndexPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => IndexState();
}

class IndexState extends State<IndexPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final channelInputBloc = BlocProvider.of(context).indexAgoraBloc;

    void submit() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallPage(
            channelName: channelInputBloc.channelValue,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        color: AppTheme.nearlyWhite,
        child: SafeArea(
          top: true,
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(top: 24),
            child: SizedBox(
              height: MediaQuery.of(context).size.width,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 24),
                  Container(
                      padding: const EdgeInsets.only(top: 8),
                      child: const Text(
                        'Start a Telepresence call',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )),
                  Container(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text('Teleport to the other side',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                          ))),
                  StreamBuilder<String>(
                      stream: channelInputBloc.channel,
                      builder: (context, snapshot) {
                        return Padding(
                          padding:
                              EdgeInsets.only(top: 16, left: 32, right: 32),
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
                                constraints: BoxConstraints(
                                    minHeight: 80, maxHeight: 160),
                                color: AppTheme.white,
                                child: SingleChildScrollView(
                                  padding: EdgeInsets.only(
                                      left: 10, right: 10, top: 0, bottom: 0),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: TextField(
                                      maxLines: null,
                                      onChanged: (event) => channelInputBloc
                                          .channelInputChanged
                                          .add(event),
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontName,
                                        fontSize: 16,
                                        color: AppTheme.dark_grey,
                                      ),
                                      cursorColor: Colors.blue,
                                      decoration: InputDecoration(
                                          errorText: snapshot.error,
                                          border: UnderlineInputBorder(
                                              borderSide: BorderSide(width: 1)),
                                          hintText: 'Enter channel\'s name'),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: StreamBuilder<String>(
                        stream: channelInputBloc.channel,
                        builder: (context, snapshot) {
                          return ButtonTheme(
                            minWidth: 100,
                            height: 40,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                            ),
                            child: RaisedButton(
                                splashColor: Colors.white,
                                color: Colors.black87,
                                child: Text(
                                  'Join',
                                  style: GoogleFonts.roboto(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                onPressed: () {
                                  if (snapshot.hasData) {
                                    channelInputBloc.channelEventSink
                                        .add(ChannelEvent());
                                    submit();
                                  }
                                }),
                          );
                        }),
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
