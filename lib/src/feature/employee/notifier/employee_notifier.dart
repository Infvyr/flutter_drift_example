import 'dart:developer';

import 'package:flutter/foundation.dart' show ChangeNotifier;

import '../../../application/index.dart' show AppDb, EmployeeCompanion, EmployeeData;

class EmployeeNotifier extends ChangeNotifier {
  late AppDb _appDb;

  /// The list of employees. Used for future builder.
  ///
  List<EmployeeData> _employees = [];
  List<EmployeeData> get employees => _employees;

  List<EmployeeData> _filteredEmployees = [];
  List<EmployeeData> get filteredEmployees => _filteredEmployees;

  /// The list of employees. Used for stream builder.
  ///
  final List<EmployeeData> _employeesStream = [];
  List<EmployeeData> get employeesStream => _employeesStream;

  /// Employee data for the details screen.
  ///
  EmployeeData? _employeeData;
  EmployeeData? get employeeData => _employeeData;

  /// The error message.
  ///
  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  /// The loading state.
  ///
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// If an employee has been added.
  ///
  bool _addedEmployee = false;
  bool get addedEmployee => _addedEmployee;

  /// If an employee has been edited.
  ///
  bool _editedEmployee = false;
  bool get editedEmployee => _editedEmployee;

  /// If an employee has been deleted.
  ///
  bool _deletedEmployee = false;
  bool get deletedEmployee => _deletedEmployee;

  EmployeeData? _lastDeletedEmployee;
  EmployeeData? get lastDeletedEmployee => _lastDeletedEmployee;

  bool _deletedAll = false;
  bool get deletedAll => _deletedAll;

  /// Search input query.
  ///
  final String _searchQuery = '';
  String get searchQuery => _searchQuery;

  /// Search input query error message.
  ///
  String _searchQueryErrorMessage = '';
  String get searchQueryErrorMessage => _searchQueryErrorMessage;

  /// Initialize the notifier.
  ///
  void initAppDb(AppDb appDb) => _appDb = appDb;

  Future<void> getAllEmployees() async {
    try {
      _isLoading = true;
      _employees = await _appDb.getAllEmployees();
      _filteredEmployees = List.from(_employees);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Stream<List<EmployeeData>> watchAllEmployees() {
    return _appDb.watchAllEmployees().handleError(
      (e) {
        _errorMessage = e.toString();
        notifyListeners();
      },
    );
  }

  void getEmployee(int id) async {
    try {
      _employeeData = await _appDb.getEmployee(id);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  /// Add an employee.
  ///
  void addEmployee(EmployeeCompanion employee) async {
    try {
      final result = await _appDb.addEmployee(employee);
      _addedEmployee = result > 0 ? true : false;
      if (result > 0) {
        final newEmployee = await _appDb.getEmployee(result);
        if (newEmployee != null) {
          _filteredEmployees.insert(0, newEmployee);
          notifyListeners();
        }
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  /// Edit an employee.
  ///
  Future<bool> editEmployee(EmployeeCompanion employee) async {
    try {
      final result = await _appDb.editEmployee(employee);
      _editedEmployee = result;
      if (result) {
        final updatedEmployee = await _appDb.getEmployee(employee.id.value);
        if (updatedEmployee != null) {
          final index = _filteredEmployees.indexWhere((e) => e.id == employee.id.value);
          _filteredEmployees[index] = updatedEmployee;
          notifyListeners();
        }
      }
      return result;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Delete an employee.
  ///
  Future<void> deleteEmployee(EmployeeData employee) async {
    try {
      final result = await _appDb.deleteEmployee(employee.id);
      _deletedEmployee = result == 1 ? true : false;
      _lastDeletedEmployee = employee;
      if (result > 0) {
        _filteredEmployees.removeWhere((e) => e.id == employee.id);
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  void resetDeletedEmployee() {
    _deletedEmployee = false;
    _lastDeletedEmployee = null;
  }

  void deleteAllEmployees() async {
    try {
      final result = await _appDb.deleteAllEmployees();
      _deletedAll = result > 0 ? true : false;
      if (result > 0) {
        _filteredEmployees.clear();
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  void resetDeletedAll() {
    _deletedAll = false;
  }

  void searchEmployee(String query) async {
    try {
      final searchQuery = query.trim();
      if (searchQuery.isEmpty || searchQuery.length < 2) {
        _filteredEmployees = _employees;
        _searchQueryErrorMessage = 'Please enter at least 2 characters to search for an employee.';
        notifyListeners();
        return;
      }

      final result = await _appDb.searchEmployee(searchQuery);

      _filteredEmployees = result;
      _searchQueryErrorMessage =
          result.isEmpty ? 'No employees found with that name. Please edit your search query.' : '';
      notifyListeners();
    } catch (e, st) {
      log(
        'Search Error: $e',
        name: 'EmployeeNotifier',
        error: e,
        stackTrace: st,
      );
      _searchQueryErrorMessage = 'An error occurred during the search';
      notifyListeners();
    }
  }

  void clearSearch() {
    _filteredEmployees = _employees;
    _searchQueryErrorMessage = '';
    notifyListeners();
  }

  void setEmployees(List<EmployeeData> employees) {
    _employees = employees;
    _filteredEmployees = List.from(employees);
    notifyListeners();
  }
}
