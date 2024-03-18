import 'package:fine_dust/model/stat_model.dart';
import 'package:fine_dust/screen/test_screen.dart';
import 'package:flutter/material.dart';
import 'screen/home_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

const testBox = 'text';

void main() async {

  //Hive - NoSql
  await Hive.initFlutter();
  //adapter
  Hive.registerAdapter<StatModel>(StatModelAdapter());
  Hive.registerAdapter<ItemCode>(ItemCodeAdapter());
  await Hive.openBox(testBox);
  //ItemCode로 총 6개의 박스를 열고 그 안에 StatModel을 넣는다
  for(ItemCode itemCode in ItemCode.values) {
    await Hive.openBox<StatModel>(itemCode.name);
  }

  runApp(MaterialApp(
    theme: ThemeData(
      fontFamily: 'sunflower',
    ),
    home: HomeScreen(),
  ));
}