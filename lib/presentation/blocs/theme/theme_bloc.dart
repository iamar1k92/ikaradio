import 'dart:async';
import 'package:base/core/constants/app_themes.dart';
import 'package:base/core/sharedpref/shared_preference_helper.dart';
import 'package:base/injection_container.dart';
import 'package:base/presentation/blocs/theme/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final SharedPreferenceHelper _sharedPreferenceHelper = sl<SharedPreferenceHelper>();
  bool isDarkTheme = false;

  ThemeBloc({this.isDarkTheme}) : super(ThemeState(themeData: isDarkTheme ? appThemeData[AppTheme.Dark] : appThemeData[AppTheme.Light]));

  @override
  Stream<ThemeState> mapEventToState(ThemeEvent event) async* {
    if (event is ChangeTheme) {
      if (event.isDarkTheme != null) {
        isDarkTheme = event.isDarkTheme;
      } else {
        isDarkTheme = !await _sharedPreferenceHelper.isDarkTheme();
      }
      await _sharedPreferenceHelper.setDarkMode(isDarkTheme);
      yield ThemeState(themeData: await _getThemeData(isDarkTheme));
    }
  }

  Future<ThemeData> _getThemeData(bool isDarkTheme) async {
    if (isDarkTheme == true) {
      return appThemeData[AppTheme.Dark];
    } else {
      return appThemeData[AppTheme.Light];
    }
  }
}
