import 'dart:io';

import 'package:calendar/model/category_color.dart';
import 'package:calendar/model/schedule_with_color.dart';
import 'package:calendar/model/schedules.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

//part - import 보다 넓은 기능, private 값들도 불러올 수 있다
part 'drift_database.g.dart'; //DB 파일 생성

//터미널 - flutter pub run build_runner build
@DriftDatabase(
  tables: [
    Schedules,
    CategoryColors,
  ],
)
class LocalDatabase extends _$LocalDatabase { //Drift가 만들어줄 클래스

  LocalDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1; //DB에 설정한 테이블들의 버전 - DB구조 변경 시 버전업

  //INSERT
  Future<int> createSchedule(SchedulesCompanion data)
    => into(schedules).insert(data);

  Future<int> createCategoryColor(CategoryColorsCompanion data)
    => into(categoryColors).insert(data);

  //SELECT
  Future<List<CategoryColor>> getCategoryColors()
    => select(categoryColors).get(); //모두

  //SELECT ONE
  Future<Schedule> findScheduleById(int id)
    => (select(schedules)..where((tbl) => tbl.id.equals(id))).getSingle();

  //Steam 받기
  //지속적으로 업데이트된 값을 받음
  // Stream<List<Schedule>> watchSchedules(DateTime date) {
    // final query = select(schedules);
    // query.where((tbl) => tbl.date.equals(date));
    // return query.watch();
    //=> select(schedules).where((tbl) => tbl.date.equals(date)).watch();

    //.. 사용
    //int number = 3;
    //'3'
    //final res = number.toString();
    //3
    //final res2 = number..toString(); //toString이 실행된 대상이 리턴

    //where가 실행된 대상인 select가 리턴
    //return (select(schedules)..where((tbl) => tbl.date.equals(date))).watch();
  // }

  //Join
  Stream<List<ScheduleWithColor>> watchSchedules(DateTime date) {
    final query = select(schedules).join([
      innerJoin(categoryColors, categoryColors.id.equalsExp(schedules.colorId))
    ]);
    query.where(schedules.date.equals(date));
    query.orderBy([
      OrderingTerm.asc(schedules.startTime)
    ]);
    //rows - 필터링된 모든 값들
    return query.watch().map((rows) =>
        rows.map((row) =>
            ScheduleWithColor(
              schedule: row.readTable(schedules),
              categoryColor: row.readTable(categoryColors),
            ),
      ).toList(),
    );
  }

  //DELETE
  Future<int> removeScheduleById(int id)
    => (delete(schedules)..where((tbl) => tbl.id.equals(id))).go();

  //UPDATE
  Future<int> updateScheduleById(int id, SchedulesCompanion data)
    => (update(schedules)..where((tbl) => tbl.id.equals(id))).write(data);

}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    //시스템에서 앱별로 사용할 수 있는 HDD 특정 위치를 지정 해준다
    final dbFolder = await getApplicationDocumentsDirectory();
    //실제 경로에 db.sqlite 파일을 생성
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}