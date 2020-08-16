import 'dart:async';
import 'package:base/core/sharedpref/shared_preference_helper.dart';
import 'package:base/generated/l10n.dart';
import 'package:base/injection_container.dart';
import 'package:base/presentation/blocs/language/bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:devicelocale/devicelocale.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  final SharedPreferenceHelper _sharedPreferenceHelper = sl<SharedPreferenceHelper>();
  String _locale = sl<DotEnv>().env['DEFAULT_LANGUAGE'];

  LanguageBloc() : super(LanguageState(locale: sl<DotEnv>().env['DEFAULT_LANGUAGE'])) {
    init();
  }

  String get locale => _locale;

  @override
  Stream<LanguageState> mapEventToState(LanguageEvent event) async* {
    if (event is ChangeLanguage) {
      this._locale = event.locale;
      await _sharedPreferenceHelper.setLanguage(event.locale);
      yield LanguageState(locale: locale);
    }
  }

  Future init() async {
    _locale = await _sharedPreferenceHelper.getLanguage();
    if (_locale == null) {
      var _currentLocale = await Devicelocale.currentLocale;
      if (_currentLocale != null) {
        var _langCode = _currentLocale.split('-').first.toString().split('_').first.toString();
        var _countryCode = _currentLocale.split('-').last.toString().split('_').last.toString();
        if ((S.delegate.isSupported(Locale(_langCode, "")) || S.delegate.isSupported(Locale(_langCode, _countryCode)))) {
          _locale = _langCode;
        }
      }
    }

    if (_locale == null) {
      _locale = sl<DotEnv>().env['DEFAULT_LANGUAGE'];
    }

    add(ChangeLanguage(locale: _locale));
  }
}
