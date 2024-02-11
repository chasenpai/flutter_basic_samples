import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false, //디버그 배너 없애기
      home: HomeScreen(),
    ),
  );
}

//위젯은 하나의 클래스
class HomeScreen extends StatelessWidget { //상태를 가지지 않는 위젯
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF99231), //Hex Code 사용
      //Column은 기본 값이 가장 위에 이 위젯을, children 안에 있는 위젯들을 배치
      body: Column(
        //주축을 지정
        mainAxisAlignment: MainAxisAlignment.center,
        //대부분 위젯들은 child 또는 children
        children: [
          Image.asset(
              'asset/img/logo.png',
          ),
          CircularProgressIndicator(
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
