import 'package:flutter/material.dart';
import 'package:web_view/screen/home_screen.dart';

void main() {

  //플러터 프레임워크가 실행할 준비가 될 때 까지 기다림
  //원래는 runApp을 실행할 때 자동 실행
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MaterialApp(
      home: HomeScreen(),
    )
  );
}

