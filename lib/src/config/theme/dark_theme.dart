import 'package:flutter/material.dart';

import '../../utils/index.dart' show kAppButtonRadius, kAppTextFieldRadius;

class AppDarkTheme {
  AppDarkTheme._();

  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      colorScheme: const ColorScheme.dark(
        primary: Colors.indigo,
        secondary: Colors.purple,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(kAppButtonRadius)),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        alignLabelWithHint: true,
        hoverColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(kAppTextFieldRadius)),
          borderSide: BorderSide(
            color: Colors.indigo,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(kAppTextFieldRadius)),
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(kAppTextFieldRadius)),
          borderSide: BorderSide(
            color: Colors.white70,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(kAppTextFieldRadius)),
          borderSide: BorderSide(
            color: Colors.red,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(kAppTextFieldRadius)),
          borderSide: BorderSide(
            color: Colors.red,
          ),
        ),
        labelStyle: TextStyle(
          color: Colors.white70,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20),
      ),
      dividerTheme: DividerThemeData(
        color: Colors.grey.shade900,
        thickness: 1,
        space: 0,
      ),
    );
  }
}
