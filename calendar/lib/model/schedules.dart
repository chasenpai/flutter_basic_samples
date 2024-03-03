import 'package:drift/drift.dart';

class Schedules extends Table {

  //PK
  IntColumn get id => integer().autoIncrement()(); //컬럼을 만드는게 끝났다는 의미로 괄호
  //내용
  TextColumn get content => text()();
  //일정
  DateTimeColumn get date => dateTime()();
  //시작 시간
  IntColumn get startTime => integer()();
  //종료 시간
  IntColumn get endTime => integer()();
  //Category Color Table Id
  IntColumn get colorId => integer()();
  //생성 일시
  DateTimeColumn get createdAt => dateTime().clientDefault( //기본값 지정 - 값이 없을 때 실행
          () => DateTime.now(),
  )();

}