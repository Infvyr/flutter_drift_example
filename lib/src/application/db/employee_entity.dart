import 'package:drift/drift.dart';

class Employee extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get firstName => text().named('first_name').withLength(min: 1, max: 50)();
  TextColumn get lastName => text().named('last_name').withLength(min: 1, max: 50)();
  DateTimeColumn get dob => dateTime().named('dob')();
}
