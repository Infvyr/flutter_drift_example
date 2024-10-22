import 'package:flutter/material.dart';
import 'package:flutter_drift_example/src/utils/extensions/context_extension.dart';
import 'package:provider/provider.dart' show Consumer, ReadContext;

import '../../../common/widgets/index.dart';
import '../../../feature/employee/index.dart' show EmployeeNotifier;

class AllScreenSearchBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AllScreenSearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: const SearchBarWidget()),
        Consumer<EmployeeNotifier>(
          builder: (context, notifier, ___) {
            final hasEmployees = notifier.filteredEmployees.isNotEmpty;
            return Visibility(
              visible: hasEmployees,
              child: Row(
                children: [
                  const VerticalDivider(width: 20),
                  IconButton(
                    icon: const Icon(Icons.delete_forever, color: Colors.red),
                    onPressed: () => context.showConfirmationDialog(
                      title: 'Delete All Employees',
                      content: 'Are you sure you want to delete all employees?',
                      onConfirm: () => context.read<EmployeeNotifier>().deleteAllEmployees(),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
