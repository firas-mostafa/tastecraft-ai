import 'package:flutter/material.dart'
    show BuildContext, Theme, ThemeData, ColorScheme, TextTheme;

extension ThemeHelperExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;
}
