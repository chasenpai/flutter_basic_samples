import 'package:flutter/material.dart';

void main() {
  //runApp - 플러터 진입 포인트
  runApp(
    //Widget - 일종의 클래스
    const MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
              'Hello World',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
              ),
          ),
        ),
      ),
    ),
  );
}