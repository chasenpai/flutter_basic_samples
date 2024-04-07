import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

//최상위에서 상태를 관리하는게 좋다 - 데이터의 흐름은 부모에서 자식으로, 자식에서 부모로는 X
class _HomeScreenState extends State<HomeScreen> {

  DateTime selectedDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.pink[100], //연하게 - 기본 500
        body: SafeArea(
          bottom: false,
          child: Container(
            width: MediaQuery
                .of(context)
                .size
                .width, //가운대로 모든 위젯이 이동
            child: Column(
                children: [
                  _TopPart(selectedDate: selectedDate, onPressed: onStarPressed),
                  _BottomPart(),
                ]
            ),
          ),
        )
    );
  }

  onStarPressed() {
    final now = DateTime.now();
    //CupertinoDialog - 화면을 덮는 또 하나의 화면(ios 스타일)
    showCupertinoDialog(
        context: context,
        barrierDismissible: true, //barrierDismissible - 컨테이너 밖을 누르면 닫힘
        builder: (BuildContext context) {
          return Align( //어디에 자식 위젯을 정렬해야 할지 지정
            alignment: Alignment.bottomCenter,
            child: Container(
                color: Colors.white,
                //플러터의 특징 - 특정 위젯이 어디에 정렬을 해야 하는지 알 수 없으면 전체를 덮어버림
                height: 300.0,
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: selectedDate,
                  maximumDate: DateTime(now.year, now.month, now.day),
                  onDateTimeChanged: (DateTime datetime) {
                    setState(() { //Stateful 위젯에서 변수를 변경 시킬 때 빌드를 다시 할 때 호출
                      selectedDate = datetime;
                    });
                  },
                )
            ),
          );
        }
    );
  }
}


class _TopPart extends StatelessWidget {

  final DateTime selectedDate;
  final VoidCallback onPressed;

  _TopPart({required this.selectedDate, required this.onPressed, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final now = DateTime.now();
    //위젯트리에서 가장 가까운 테마 인스턴스를 가져옴
    //inherited widget
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            'Flutter Study',
            style: textTheme.headline1,
          ),
          Column( //컬럼 안에 컬럼 - 하위 컬럼에 위젯이 몇개 있던지 하나의 위젯으로 인식
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '플러터 공부 시작',
                style: textTheme.bodyText1,
              ),
              Text(
                '${selectedDate.year}-${selectedDate.month}-${selectedDate
                    .day}',
                style: textTheme.bodyText2,
              ),
            ],
          ),
          IconButton(
              iconSize: 60.0,
              onPressed: onPressed,
              icon: Icon(
                Icons.star,
                color: Colors.blue[300],
              )
          ),
          Text(
            'D+${
                DateTime(
                  now.year,
                  now.month,
                  now.day,
                )
                    .difference(selectedDate)
                    .inDays + 1
            }',
            style: textTheme.headline2,
          )
        ],
      ),
    );
  }
}


class _BottomPart extends StatelessWidget {
  const _BottomPart({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Image.asset(
        'asset/img/flutter.png',
      ),
    );
  }
}

