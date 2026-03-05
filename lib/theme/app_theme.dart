import 'package:flutter/material.dart';

class AppTheme {

  static const Color error = Color.fromRGBO(255, 0, 0, 1);
  static const Color onError = Color.fromRGBO(0, 0, 0, 1);
  static const Color lightBgColor = Color.fromRGBO(255, 255, 255, 1);
  static const Color lightOnBgColor = Color.fromRGBO(0, 0, 0, 1);

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
        error: error,
        onError: onError,
        surface: lightBgColor,
        onSurface: lightOnBgColor
    )
  );

  static const Color darkBgColor = Color.fromRGBO(47, 47, 47, 1);
  static const Color darkOnBgColor = Color.fromRGBO(255, 255, 255, 1);


  static final ThemeData darkTheme = ThemeData(
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
          error: error,
          onError: onError,
          surface: darkBgColor,
          onSurface: darkOnBgColor
      )
  );

}