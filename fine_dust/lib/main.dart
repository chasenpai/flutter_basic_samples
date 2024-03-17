import 'package:fine_dust/screen/test_screen.dart';
import 'package:flutter/material.dart';
import 'screen/home_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

const testBox = 'text';

void main() async {

  //Hive - NoSql
  await Hive.initFlutter();
  await Hive.openBox(testBox);


  runApp(MaterialApp(
    theme: ThemeData(
      fontFamily: 'sunflower',
    ),
    home: HomeScreen(),
  ));
}