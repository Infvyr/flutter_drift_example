import 'dart:async' show Timer;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart' show Consumer, ReadContext;

import '../../../utils/index.dart' show ContextExtension;
import '../../../feature/employee/index.dart' show EmployeeNotifier;

class SearchBarWidget extends StatefulWidget implements PreferredSizeWidget {
  const SearchBarWidget({super.key});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final controller = TextEditingController();
  late EmployeeNotifier _employeeNotifier;
  Timer? debounce;

  @override
  void initState() {
    super.initState();
    _employeeNotifier = context.read<EmployeeNotifier>();
    controller.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    controller.dispose();
    debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (debounce?.isActive ?? false) debounce!.cancel();
    debounce = Timer(
      const Duration(milliseconds: 300),
      () {
        final query = controller.text;

        if (query.isEmpty) {
          _employeeNotifier.clearSearch();
        } else {
          _employeeNotifier.searchEmployee(query);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EmployeeNotifier>(
      builder: (context, notifier, ___) {
        return TextFormField(
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 10,
            ),
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: context.primaryFadedColor),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: context.primaryColor),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: context.primaryFadedColor),
            ),
            errorBorder: UnderlineInputBorder(),
            disabledBorder: UnderlineInputBorder(),
            suffixIcon: controller.text.isEmpty
                ? Icon(
                    Icons.search,
                    color: context.onSurfaceFadeColor,
                    size: 20,
                  )
                : IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: Colors.red[200],
                      size: 20,
                    ),
                    onPressed: () {
                      controller.clear();
                      context.hideKeyboard();
                      notifier.clearSearch();
                    },
                  ),
            hintText: 'Search by name or last name...',
            hintStyle: TextStyle(color: context.onSurfaceFadeColor),
          ),
          autocorrect: false,
          autofocus: false,
          controller: controller,
          keyboardType: TextInputType.text,
        );
      },
    );
  }
}
