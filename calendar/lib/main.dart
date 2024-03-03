import 'package:calendar/database/drift_database.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'screen/HomeScreen.dart';
import 'package:intl/date_symbol_data_local.dart';

const DEFAULT_COLORS = [
  //빨강
  'F44336',
  //주황
  'FF9800',
  //노랑
  'FFEB3B',
  //초록
  'FCAF50',
  //파랑
  '2196F3',
  //남
  '3F51B5',
  //보라
  '9C27B0',
];

void main() async {

  //플러터 프레임워크가 준비될 때 까지 대기
  //runApp이 실행될 때 자동으로 실행되지만 지금 runApp 실행 전에 다른 코드를 실행해야 하기 때문
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting(); //Intl 패키지 안에 있는 모든 언어를 사용할 수 있게 초기화

  final database = LocalDatabase();
  //Get It 플러그인을 사용한 의존성 주입 - 스프링의 빈등록 같은
  GetIt.I.registerSingleton<LocalDatabase>(database);

  final colors = await database.getCategoryColors();
  if(colors.isEmpty) {
    for(String hexCode in DEFAULT_COLORS) {
      await database.createCategoryColor(
          CategoryColorsCompanion(
            hexCode: Value(hexCode), //값을 넣을 땐 Value로 감싸서
          ),
      );
    }
  }

  runApp(
    MaterialApp(
      theme: ThemeData(
        fontFamily: 'NotoSans',
      ),
      home: HomeScreen(),
    )
  );
}
