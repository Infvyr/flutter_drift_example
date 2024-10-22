import 'package:flutter/material.dart';

import '../../feature/employee/index.dart'
    show
        EmployeeAddScreen,
        EmployeeAllScreen,
        EmployeeDetails,
        EmployeeDetailsArguments,
        EmployeeSearchScreen;
import '../index.dart' show RoutePath;

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case RoutePath.initial:
        return MaterialPageRoute(builder: (_) => const EmployeeAllScreen());
      case RoutePath.addEmployee:
        return MaterialPageRoute(builder: (_) => const EmployeeAddScreen());
      case RoutePath.searchEmployee:
        return MaterialPageRoute(builder: (_) => const EmployeeSearchScreen());
      case RoutePath.employee:
        if (args is EmployeeDetailsArguments) {
          return MaterialPageRoute(
            builder: (_) => EmployeeDetails(
              arguments: args,
            ),
          );
        }
        return _errorRoute();
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Error'),
          ),
          body: const Center(
            child: Text(
              'No route defined for this screen.',
              style: TextStyle(
                color: Colors.red,
                fontSize: 18,
              ),
            ),
          ),
        );
      },
    );
  }
}
