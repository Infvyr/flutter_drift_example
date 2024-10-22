import 'package:flutter/material.dart';
import 'package:provider/provider.dart' show Consumer, ReadContext, SelectContext;

import '../../../application/index.dart' show EmployeeData;
import '../../../common/widgets/index.dart' show BlurredAppBar;
import '../../../config/index.dart' show RoutePath;
import '../../../utils/index.dart' show ContextExtension, DateTimeExtension;
import '../index.dart' show EmployeeDetailsArguments, EmployeeNotifier;
import '../widgets/index.dart' show AllScreenSearchBarWidget;

class EmployeeAllScreen extends StatefulWidget {
  const EmployeeAllScreen({super.key});

  @override
  State<EmployeeAllScreen> createState() => _EmployeeAllScreenState();
}

class _EmployeeAllScreenState extends State<EmployeeAllScreen> {
  late EmployeeNotifier _employeeNotifier;

  @override
  void initState() {
    super.initState();
    _employeeNotifier = context.read<EmployeeNotifier>();
    _employeeNotifier.addListener(_listenToProviderChanges);
  }

  @override
  void dispose() {
    _employeeNotifier.removeListener(_listenToProviderChanges);
    super.dispose();
  }

  Future<bool?> _onDismissed(DismissDirection direction, EmployeeData employee) async {
    if (direction == DismissDirection.endToStart) {
      return context.showConfirmationDialog(
        title: 'Delete Employee',
        content: 'Are you sure you want to delete ${employee.firstName} ${employee.lastName}?',
      );
    }
    return false;
  }

  void _listenToProviderChanges() {
    if (_employeeNotifier.deletedEmployee) {
      final employee = _employeeNotifier.lastDeletedEmployee;
      if (employee != null) {
        context.showBanner(
          message: '${employee.firstName} ${employee.lastName} has successfully been deleted.',
          duration: 2,
          showActions: false,
        );
      }
      _employeeNotifier.resetDeletedEmployee();
    }
    if (_employeeNotifier.deletedAll) {
      context.showBanner(
        message: 'All employees have been successfully deleted.',
        duration: 2,
        showActions: false,
      );
      _employeeNotifier.resetDeletedAll();
    }
  }

  @override
  Widget build(BuildContext context) {
    final loading = context.select<EmployeeNotifier, bool>((notifier) => notifier.isLoading);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const BlurredAppBar(
        automaticallyImplyLeading: false,
        bottom: AllScreenSearchBarWidget(),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          bottom: 30,
        ),
        child: Visibility(
          visible: !loading,
          replacement: const Center(child: CircularProgressIndicator.adaptive()),
          child: Consumer<EmployeeNotifier>(
            builder: (context, notifier, _) {
              final employees = notifier.filteredEmployees;

              if (employees.isEmpty) {
                return const Center(child: Text('No employees found.'));
              }
              return ListView.builder(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                itemCount: employees.length,
                itemBuilder: (context, index) {
                  final employee = employees[index];
                  return Dismissible(
                    key: UniqueKey(),
                    onDismissed: (_) => context.read<EmployeeNotifier>().deleteEmployee(employee),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 16),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    confirmDismiss: (direction) => _onDismissed(direction, employee),
                    child: ListTile(
                      title: Text('${employee.firstName} ${employee.lastName}'),
                      subtitle: Text('Birthdate: ${employee.dob.toLocalDate()}'),
                      onTap: () => context.pushNamed(
                        RoutePath.employee,
                        arguments: EmployeeDetailsArguments(
                          employee.id,
                          employee.firstName,
                          employee.lastName,
                          employee.dob,
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context
          ..hideBanner()
          ..pushNamed(RoutePath.addEmployee),
        icon: const Icon(Icons.add),
        label: const Text('Add Employee'),
        tooltip: 'Add New Employee',
      ),
    );
  }
}
