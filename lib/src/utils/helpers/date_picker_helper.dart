import 'package:flutter/material.dart'
    show BuildContext, DatePickerEntryMode, Locale, SizedBox, TextEditingController, showDatePicker;
import 'package:intl/intl.dart' show DateFormat;

Future<void> openDatePicker(
  BuildContext context, {
  required TextEditingController controller,
  required DateTime? initialDate,
  required void Function(DateTime) onDatePicked,
}) async {
  final picked = await showDatePicker(
    context: context,
    initialEntryMode: DatePickerEntryMode.calendarOnly,
    initialDate: initialDate ?? DateTime.now(),
    firstDate: DateTime(1950),
    lastDate: DateTime.now(),
    locale: const Locale('en', 'GB'),
    builder: (_, child) => child ?? const SizedBox(),
  );
  if (picked != null) {
    onDatePicked(picked);
    controller.text = DateFormat('d MMM yyyy').format(picked);
  }
}
