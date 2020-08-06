import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:teleport/modes/localization/Languages.dart';
import 'package:teleport/modes/localization/SharedPreferences.dart';
import 'dart:io' show Platform;

import '../Events.dart';

class LocalizationBloc extends Object implements BaseBloc {
  final _localizationEvent = StreamController<Events>();

  final _localeController = BehaviorSubject<Locale>();

  Sink<Events> get localizationEvent => _localizationEvent.sink;

  StreamSink<Locale> get localeSink => _localeController.sink;

  Stream<Locale> get localeStream => _localeController.stream;

  LocalizationBloc() {
    _localizationEvent.stream.listen(_localizationEventToState);
  }

  void _localizationEventToState(Events event) {
    if (event is LanguageLoadEvent)
      _loadLanguage();
    else if (event is LanguageSelectEvent) _selectLanguage(event.languageCode);
  }

  _loadLanguage() async {
    final sharedPrefService = await SharedPreferencesService.instance;
    final defaultLanguageCode = sharedPrefService.languageCode;
    Locale locale;
    if (defaultLanguageCode == null) {
      String languageCode = Platform.localeName.split('_')[0];
      switch(languageCode){
        case 'ar': locale = Locale('ar'); break;
        case 'fr': locale = Locale('fr'); break;
        default: locale = Locale('en');   break;
      }
    } else {
      locale = Locale(defaultLanguageCode);
    }
    localeSink.add(locale);
  }

  void _selectLanguage(Language selectedLanguage) async {
    final sharedPrefService = await SharedPreferencesService.instance;
    final defaultLanguageCode = sharedPrefService.languageCode;
    if (selectedLanguage == Language.AR &&
        defaultLanguageCode != SharedPrefKeys.languageCode)
      _loadSelectedLang(sharedPrefService, 'ar');
    else if (selectedLanguage == Language.FR &&
        defaultLanguageCode != SharedPrefKeys.languageCode)
      _loadSelectedLang(sharedPrefService, 'fr');
    else if (selectedLanguage == Language.EN && defaultLanguageCode != SharedPrefKeys.languageCode)
      _loadSelectedLang(sharedPrefService, 'en');
  }

  _loadSelectedLang(
      SharedPreferencesService sharedPreferencesService,
      String languageCode,
      ) async {
    final locale = Locale(languageCode);
    await sharedPreferencesService.setLanguage(locale.languageCode);
    localeSink.add(locale);
  }

  @override
  void dispose() {
    _localizationEvent?.close();
    _localeController?.close();
  }
}

abstract class BaseBloc {
  void dispose();
}
