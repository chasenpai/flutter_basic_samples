import 'package:d_day/screen/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    //테마 적용
    theme: ThemeData(
      fontFamily: 'sunflower',
      textTheme: TextTheme(
        headline1: TextStyle(
            color: Colors.white,
            fontFamily: 'parisienne',
            fontSize: 60.0
        ),
        headline2: TextStyle(
            color: Colors.white,
            fontSize: 50.0,
            fontWeight: FontWeight.w700,
        ),
        bodyText1: TextStyle(
            color: Colors.white,
            fontSize: 30.0
        ),
        bodyText2: TextStyle(
            color: Colors.white,
            fontSize: 20.0
        )
      )
    ),
    home: HomeScreen(),
  ));
}
