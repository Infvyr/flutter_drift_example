import 'dart:io' show File;

import 'package:drift/drift.dart';
import 'package:drift/native.dart' show NativeDatabase;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import 'employee_entity.dart';

part 'app_db.g.dart';

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(path.join(dbFolder.path, 'employee.sqlite'));
    return NativeDatabase(file);
  });
}

@DriftDatabase(tables: [Employee])
class AppDb extends _$AppDb {
  AppDb() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<List<EmployeeData>> getAllEmployees() => (select(employee)
        ..orderBy(
          [
            (tbl) => OrderingTerm(
                  expression: tbl.id,
                  mode: OrderingMode.desc,
                )
          ],
        ))
      .get();

  Stream<List<EmployeeData>> watchAllEmployees() => (select(employee)
        ..orderBy(
          [
            (tbl) => OrderingTerm(
                  expression: tbl.id,
                  mode: OrderingMode.desc,
                )
          ],
        ))
      .watch();

  Future<List<EmployeeData>> searchEmployees(String query) => (select(employee)
        ..where(
          (tbl) => tbl.firstName.like('%$query%') | tbl.lastName.like('%$query%'),
        ))
      .get();

  Future<EmployeeData?> getEmployee(int id) => (select(employee)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

  Future<int> addEmployee(EmployeeCompanion entity) => into(employee).insert(entity);

  Future<bool> editEmployee(EmployeeCompanion entity) => update(employee).replace(entity);

  Future<int> deleteEmployee(int id) => (delete(employee)..where((tbl) => tbl.id.equals(id))).go();

  Future<int> deleteAllEmployees() => delete(employee).go();

  Future<List<EmployeeData>> searchEmployee(String query) => (select(employee)
        ..where(
          (tbl) => tbl.firstName.like('%$query%') | tbl.lastName.like('%$query%'),
        )
        ..orderBy(
          [
            (tbl) => OrderingTerm(
                  expression: tbl.id,
                  mode: OrderingMode.desc,
                )
          ],
        ))
      .get();
}
