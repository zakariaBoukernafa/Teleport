import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:teleport/ui/auth/loginPage.dart';
import 'bloc/AppBloc.dart';
import 'bloc/Bloc_provider.dart';
import 'bloc/Events.dart';
import 'modes/localization/AppLocalizations.dart';
import 'modes/users/auth.dart';
import 'ui/auth/signUp.dart';
import 'ui/whole_new_menu/ui_package/navigation_home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final appBloc = AppBloc();

  runApp(MyApp(appBloc));
}

Future<bool> checkLogin() async {
  AuthService user = new AuthService();
  var _result = await user.getCurrentUser();
  if (_result == null)
    return true;
  else
    return false;
}

class MyApp extends StatelessWidget {
  final AppBloc bloc;

  MyApp(this.bloc);

  @override
  Widget build(BuildContext context) {
    bloc.localizationBloc.localizationEvent.add(LanguageLoadEvent());
    return BlocProvider(
      bloc: bloc,
      child: StreamBuilder<Locale>(
        stream: bloc.localizationBloc.localeStream,
        builder: (context, localSnap) {
          return FutureBuilder(
            future: checkLogin(),
            builder: (_, snapshot) {
              if (snapshot.hasData) {
                return MaterialApp(
                  locale: localSnap.data,
                  localizationsDelegates: [
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    AppLocalizations.delegate,
                  ],
                  supportedLocales: [
                    Locale('en'),
                    Locale('fr'),
                    Locale('ar'),
                  ],
                  theme: ThemeData(accentColor: Colors.grey[400]),
                  title: 'Teleport',
                  home: snapshot.data ? SignIn() : NavigationHomePage(),
                  routes: {
                    '/SignUp': (context) => SignUp(),
                    '/SignIn': (context) => SignIn(),
                    '/HomePage': (context) => NavigationHomePage(),
                  },
                );
              } else {
                return MaterialApp(
                    title: 'Teleport',
                    locale: localSnap.data,
                    localizationsDelegates: [
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                      AppLocalizations.delegate,
                    ],
                    supportedLocales: [
                      Locale('en'),
                      Locale('fr'),
                      Locale('ar'),
                    ],
                    home: Scaffold(
                        body: Center(
                            child: CircularProgressIndicator(
                      valueColor: null,
                      backgroundColor: Colors.green,
                    ))));
              }
            },
          );
        }
      ),
    );
  }
}
