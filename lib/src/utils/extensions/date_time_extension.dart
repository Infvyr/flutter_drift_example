import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

extension DateTimeExtension on DateTime {
  String toLocalDate({
    String format = 'd MMM yyyy',
    Locale? locale = const Locale('en', 'GB'),
  }) {
    return DateFormat(format, locale?.toLanguageTag()).format(this);
  }
}
