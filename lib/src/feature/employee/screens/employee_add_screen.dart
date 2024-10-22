import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' show ReadContext;

import '../../../utils/index.dart' show ContextExtension, openDatePicker;
import '../../../application/index.dart' show EmployeeCompanion;
import '../../../common/widgets/index.dart' show CustomTextFormField;
import '../index.dart' show EmployeeNotifier;

class EmployeeAddScreen extends StatefulWidget {
  const EmployeeAddScreen({super.key});

  @override
  State<EmployeeAddScreen> createState() => _EmployeeAddScreenState();
}

class _EmployeeAddScreenState extends State<EmployeeAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  DateTime? _dob;
  bool _hasClearedTheForm = false;
  late EmployeeNotifier _employeeNotifier;

  @override
  void initState() {
    super.initState();
    _employeeNotifier = context.read<EmployeeNotifier>();
    _employeeNotifier.addListener(_listenToProviderChanges);
  }

  @override
  void dispose() {
    _clearFields();
    _employeeNotifier.removeListener(_listenToProviderChanges);
    super.dispose();
  }

  void _clearFields() {
    _firstNameController.clear();
    _lastNameController.clear();
    _dobController.clear();
    _dob = null;
  }

  void _addEmployee() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (isValid) {
      final fName = _firstNameController.text;
      final lName = _lastNameController.text;

      final employee = EmployeeCompanion(
        firstName: Value(fName),
        lastName: Value(lName),
        dob: Value(_dob!),
      );

      context.read<EmployeeNotifier>().addEmployee(employee);
    }
  }

  void _listenToProviderChanges() {
    if (_employeeNotifier.addedEmployee) {
      context.showBanner(
        message:
            '${_firstNameController.text} ${_lastNameController.text} has been added successfully.',
        duration: 3,
      );
      _clearFields();
      setState(() => _hasClearedTheForm = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: BackButton(
          onPressed: () => context
            ..hideBanner()
            ..popRoute(),
        ),
        title: const Text('Add Employee'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: _firstNameController,
                validatorText: 'Please enter first name',
                labelText: 'First Name',
                keyboardType: TextInputType.name,
                hasCleared: _hasClearedTheForm,
              ),
              const SizedBox(height: 10),
              CustomTextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: const ValueKey('lastName'),
                controller: _lastNameController,
                validatorText: 'Please enter last name',
                labelText: 'Last Name',
                keyboardType: TextInputType.name,
                hasCleared: _hasClearedTheForm,
              ),
              const SizedBox(height: 10),
              CustomTextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: _dobController,
                validatorText: 'Please enter date of birth',
                labelText: 'Date of Birth',
                readOnly: true,
                hasCleared: _hasClearedTheForm,
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
          onPressed:
              _formKey.currentState?.validate() == true ? _addEmployee : null,
          child: const Text('Add'),
        ),
      ],
    );
  }
}
