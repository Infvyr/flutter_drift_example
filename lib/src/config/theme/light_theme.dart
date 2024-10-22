import 'package:flutter/material.dart';

import '../../utils/index.dart' show kAppButtonRadius, kAppTextFieldRadius;

class AppLightTheme {
  AppLightTheme._();

  static ThemeData get lightTheme {
    return ThemeData.light().copyWith(
      colorScheme: const ColorScheme.light(
        primary: Colors.indigo,
        secondary: Colors.indigoAccent,
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
      inputDecorationTheme: InputDecorationTheme(
        alignLabelWithHint: true,
        hoverColor: Colors.black87,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(kAppTextFieldRadius)),
          borderSide: BorderSide(
            color: Colors.indigo,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(kAppTextFieldRadius)),
          borderSide: BorderSide(
            color: Colors.black87,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius:
              const BorderRadius.all(Radius.circular(kAppTextFieldRadius)),
          borderSide: BorderSide(
            color: Colors.grey.shade900,
          ),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(kAppTextFieldRadius)),
          borderSide: BorderSide(
            color: Colors.red,
          ),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(kAppTextFieldRadius)),
          borderSide: BorderSide(
            color: Colors.red,
          ),
        ),
        labelStyle: const TextStyle(
          color: Colors.black87,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      ),
      dividerTheme: DividerThemeData(
        color: Colors.grey.shade300,
        thickness: 1,
        space: 0,
      ),
    );
  }
}
