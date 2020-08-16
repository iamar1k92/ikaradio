import 'package:flutter/material.dart';

enum AppTheme { Dark, Light }

const Map<int, Color> lightPrimaryColor = const <int, Color>{
  50: const Color(0xFFcf0921),
  100: const Color(0xFFcf0921),
  200: const Color(0xFFcf0921),
  300: const Color(0xFFcf0921),
  400: const Color(0xFFcf0921),
  500: const Color(0xFFcf0921),
  600: const Color(0xFFcf0921),
  700: const Color(0xFFcf0921),
  800: const Color(0xFFcf0921),
  900: const Color(0xFFcf0921)
};

const Map<int, Color> darkPrimaryColor = const <int, Color>{
  50: const Color(0xFF12151C),
  100: const Color(0xFF11141A),
  200: const Color(0xFF0F1217),
  300: const Color(0xFF0F1217),
  400: const Color(0xFF0E1015),
  500: const Color(0xff0C0E12),
  600: const Color(0xff0A0C10),
  700: const Color(0xff090A0D),
  800: const Color(0xff07080B),
  900: const Color(0xff050608)
};

final appThemeData = {
  AppTheme.Dark: ThemeData(
    brightness: Brightness.dark,
    primaryColor: MaterialColor(darkPrimaryColor[400].value, darkPrimaryColor),
    accentColor: Colors.white,
    canvasColor: darkPrimaryColor[900],
    cardColor: darkPrimaryColor[400],
    primaryIconTheme: IconThemeData(color: Colors.white),
    iconTheme: IconThemeData(color: Colors.white),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: darkPrimaryColor[400],
    ),
    indicatorColor: Colors.white,
    primaryColorBrightness: Brightness.dark,
    accentColorBrightness: Brightness.dark,
    toggleableActiveColor: Colors.white,
    cardTheme: CardTheme(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0)), side: BorderSide(color: Colors.grey.shade900)),
      margin: EdgeInsets.only(bottom: 1.0),
      elevation: 0,
    ),
    textTheme: TextTheme(
      caption: TextStyle(color: Colors.grey),
      headline1: TextStyle(fontSize: 24, color: Colors.white),
      headline2: TextStyle(inherit: true, fontSize: 36, color: Colors.white, fontWeight: FontWeight.bold),
    ),
  ),
  AppTheme.Light: ThemeData(
    brightness: Brightness.light,
    primaryColor: MaterialColor(lightPrimaryColor[50].value, lightPrimaryColor),
    accentColor: lightPrimaryColor[50],
    primarySwatch: Colors.blue,
    primaryIconTheme: IconThemeData(color: lightPrimaryColor[50]),
    iconTheme: IconThemeData(color: Colors.white),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.white,
    ),
    backgroundColor: Colors.white,
    canvasColor: Color(0xfff8f8f8),
    cardColor: Colors.white,
    primaryColorBrightness: Brightness.light,
    accentColorBrightness: Brightness.light,
    appBarTheme: AppBarTheme(
      color: Colors.white,
      elevation: 1,
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: Colors.transparent,
      filled: true,
      isDense: true,
      alignLabelWithHint: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
      ),
    ),
    textTheme: TextTheme(
      headline1: TextStyle(fontSize: 24, color: Colors.black),
      headline2: TextStyle(inherit: true, fontSize: 36, color: Colors.black, fontWeight: FontWeight.bold),
    ),
    cardTheme: CardTheme(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0)), side: BorderSide(color: Colors.grey.shade300)),
      margin: EdgeInsets.only(bottom: 1.0),
      elevation: 0,
      color: Colors.white,
    ),
  ),
};
