import 'dart:math';

import 'package:flutter/material.dart';
import 'package:random_number/constant/color.dart';
import 'package:random_number/screen/settings_screen.dart';

import '../component/number_row.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int maxNumber = 1000;

  List<int> randomNumber = [
    123,
    456,
    789,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PRIMARY_COLOR,
      body: SafeArea(
        child: Padding( //Padding
          //zero - 효과 x
          //all - 사방에 모두 효과
          //fromLTRB - 왼쪽, 위, 오른쪽, 아래 순으로 적용
          //only - Named param
          //symmetric - 가로, 세로
          padding: EdgeInsets.symmetric(
            horizontal: 16.0
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HeaderWidget(onPressed: onSettingsPop),
              _BodyWidget(randomNumber: randomNumber),
              _FooterWidget(onPressed: onRandomRandomNumberGenerator),
            ],
          ),
        ),
      )
    );
  }

  void onRandomRandomNumberGenerator() {
    final random = Random();
    final Set<int> newNumber = {}; //Set으로 중복 제거
    while(newNumber.length != 3) {
      final number= random.nextInt(maxNumber);
      newNumber.add(number);
    }
    setState(() {
      randomNumber = newNumber.toList();
    });
  }

  void onSettingsPop() async {
      //위젯 트리에 있는 가장 가까운 네비게이터를 가져옴
      //list - add
      //[HomeScreen(), SettingsScreen()]
      final result = await Navigator.of(context).push<int>( //비동기로 파라미터를 받는다
        MaterialPageRoute(
            builder: (BuildContext context) {
              return SettingsScreen(maxNumber: maxNumber);
            }
        ),
      );
      if(result != null){
        setState(() {
          maxNumber = result;
        });
      }
    }
}

class _HeaderWidget extends StatelessWidget {

  final VoidCallback onPressed;
  const _HeaderWidget({required this.onPressed, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, //끝고 끝 차지
        children: [
          Text(
            '랜덤 숫자 생성기',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          IconButton(
              onPressed: onPressed,
              icon: Icon(
                Icons.settings,
                color: RED_COLOR,
              ),
          ),
        ]
    );
  }
}

class _BodyWidget extends StatelessWidget {

  final List<int> randomNumber;
  const _BodyWidget({required this.randomNumber, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded( //나머지 공간 차지
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: randomNumber.asMap()
              .entries //key&value
              .map((list) => Padding(
            padding: EdgeInsets.only(bottom: list.key == 2 ? 0 : 16.0),
            child: NumberRow(number: list.value.toInt()),
          ),
          ).toList(),
        )
    );
  }
}

class _FooterWidget extends StatelessWidget {

  final VoidCallback onPressed;
  const _FooterWidget({required this.onPressed, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      //SizedBox - 간단하게 너비 높이만 정할 수 있는 위젯 - 미세하게 Container 보다 빠르다
      //목적이 명확한 위젯이기 때문에 너비 높이만 조절할 경우 해당 위젯을 사용하는 것이 좋다 - 알아보기 쉬움
      SizedBox(
        width: double.infinity, //전체 사이즈 차지하게
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: RED_COLOR, //주색상
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0)
              )
          ),
          onPressed: onPressed,
          child: Text(
            '생성하기',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
  }
}


