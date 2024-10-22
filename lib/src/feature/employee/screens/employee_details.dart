import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' show ReadContext;

import '../../../application/index.dart' show EmployeeCompanion, EmployeeData;
import '../../../common/widgets/index.dart' show CustomTextFormField;
import '../../../utils/index.dart' show ContextExtension, DateTimeExtension, openDatePicker;
import '../index.dart' show EmployeeNotifier;

class EmployeeDetails extends StatefulWidget {
  const EmployeeDetails({
    super.key,
    required this.arguments,
  });

  final EmployeeDetailsArguments arguments;

  @override
  State<EmployeeDetails> createState() => _EmployeeDetailsState();
}

class _EmployeeDetailsState extends State<EmployeeDetails> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  DateTime? _dob;
  bool _isValidForm = false;
  late EmployeeNotifier _employeeNotifier;

  @override
  void initState() {
    super.initState();
    _firstNameController.text = widget.arguments.employeeFirstName;
    _lastNameController.text = widget.arguments.employeeLastName;
    _dobController.text = widget.arguments.employeeDob.toLocalDate();
    _dob = DateTime.tryParse(widget.arguments.employeeDob.toIso8601String());

    _employeeNotifier = context.read<EmployeeNotifier>();
  }

  @override
  void dispose() {
    _clearFields();
    super.dispose();
  }

  void _clearFields() {
    _firstNameController.clear();
    _lastNameController.clear();
    _dobController.clear();
  }

  void _validateForm() {
    setState(() {
      _isValidForm = _formKey.currentState?.validate() ?? false;
    });
  }

  void _updateEmployee() async {
    if (_isValidForm) {
      final fName = _firstNameController.text;
      final lName = _lastNameController.text;
      final employee = EmployeeCompanion(
        id: Value(widget.arguments.employeeId),
        firstName: Value(fName),
        lastName: Value(lName),
        dob: Value(_dob!),
      );

      final updated = await context.read<EmployeeNotifier>().editEmployee(employee);

      if (updated && mounted) {
        context.showBanner(
          message: 'The employee has successfully been updated.',
          duration: 2,
        );
        context.popRoute();
      }
    }
  }

  void _deleteEmployee() async {
    await _employeeNotifier.deleteEmployee(widget.arguments.toEmployeeData());
    if (mounted) {
      context.popRoute();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: const Text('Employee Details'),
        actions: [
          IconButton(
            tooltip: 'Delete',
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: _deleteEmployee,
          ),
          IconButton(
            tooltip: 'Refresh employee details',
            icon: const Icon(Icons.refresh),
            onPressed: () => _employeeNotifier.getEmployee(widget.arguments.employeeId),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          onChanged: _validateForm,
          child: Column(
            children: [
              CustomTextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: _firstNameController,
                validatorText: 'Please enter a name',
                labelText: 'Employee First Name',
                keyboardType: TextInputType.name,
              ),
              const SizedBox(height: 10),
              CustomTextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: _lastNameController,
                validatorText: 'Please enter a name',
                labelText: 'Employee Last Name',
                keyboardType: TextInputType.name,
              ),
              const SizedBox(height: 10),
              CustomTextFormField(
                controller: _dobController,
                validatorText: 'Please enter a date of birth',
                labelText: 'Date of Birth',
                readOnly: true,
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  return openDatePicker(
                    context,
                    controller: _dobController,
                    initialDate: _dob,
                    onDatePicked: (date) => setState(() => _dob = date),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      persistentFooterAlignment: AlignmentDirectional.center,
      persistentFooterButtons: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
          ),
          onPressed: _isValidForm ? _updateEmployee : null,
          child: const Text('Update'),
        ),
      ],
    );
  }
}

class EmployeeDetailsArguments {
  final int employeeId;
  final String employeeFirstName;
  final String employeeLastName;
  final DateTime employeeDob;

  EmployeeDetailsArguments(
    this.employeeId,
    this.employeeFirstName,
    this.employeeLastName,
    this.employeeDob,
  );

  EmployeeData toEmployeeData() {
    return EmployeeData(
      id: employeeId,
      firstName: employeeFirstName,
      lastName: employeeLastName,
      dob: employeeDob,
    );
  }
}
