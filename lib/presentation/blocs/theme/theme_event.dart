import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ThemeEvent {}

class ChangeTheme extends ThemeEvent {
  final bool isDarkTheme;

  ChangeTheme({this.isDarkTheme});
}
