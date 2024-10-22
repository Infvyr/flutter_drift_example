import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required TextEditingController controller,
    required this.validatorText,
    required this.labelText,
    this.onTap,
    this.onEditingComplete,
    this.readOnly = false,
    this.autovalidateMode,
    this.keyboardType,
    this.autocorrect = false,
    this.hasCleared = false,
  }) : _controller = controller;

  final TextEditingController _controller;
  final String validatorText;
  final String labelText;
  final VoidCallback? onTap;
  final VoidCallback? onEditingComplete;
  final bool readOnly;
  final AutovalidateMode? autovalidateMode;
  final TextInputType? keyboardType;
  final bool autocorrect;

  final bool hasCleared;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autocorrect: autocorrect,
      autovalidateMode: autovalidateMode,
      controller: _controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      validator: (value) {
        if (hasCleared) {
          return null;
        } else if (value == null || value.isEmpty) {
          return validatorText;
        }

        return null;
      },
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
      ),
      onTap: onTap,
      onEditingComplete: onEditingComplete,
    );
  }
}
