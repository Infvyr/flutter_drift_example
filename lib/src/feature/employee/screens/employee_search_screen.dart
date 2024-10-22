import 'package:flutter/material.dart';

import '../../../utils/index.dart' show ContextExtension;

class EmployeeSearchScreen extends StatelessWidget {
  const EmployeeSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Employee'),
        leading: IconButton(
          icon: Icon(
            Icons.adaptive.arrow_back,
            size: 20,
            semanticLabel: 'Navigate Back to All Employees',
          ),
          onPressed: () => context.popRoute(),
        ),
      ),
      body: const Center(
        child: Text('Search Employee Screen'),
      ),
    );
  }
}
