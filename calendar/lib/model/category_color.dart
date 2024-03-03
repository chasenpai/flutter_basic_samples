import 'package:drift/drift.dart';

class CategoryColors extends Table {

  //PK
  IntColumn get id => integer().autoIncrement()();
  //헥스 코드
  TextColumn get hexCode => text()();

}