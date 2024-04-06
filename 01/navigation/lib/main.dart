import 'package:flutter/material.dart';
import 'package:navigation/screen/route_one_screen.dart';

import 'screen/home_screen.dart';
import 'screen/route_three_screen.dart';
import 'screen/route_two_screen.dart';

void main() {
  runApp(
    MaterialApp(
      // home: HomeScreen(),
      initialRoute: "/", //초기 라우트
      routes: {
        //Named Route
        //home은 무조건 슬래시(도메인)
        '/' : (context) => HomeScreen(),
        '/one' : (context) => RouteOneScreen(),
        '/two' : (context) => RouteTwoScreen(),
        '/three' : (context) => RouteThreeScreen(),
      },
    )
  );
}