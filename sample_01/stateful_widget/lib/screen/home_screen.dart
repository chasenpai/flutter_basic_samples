import 'package:flutter/material.dart';

//stful
class HomeScreen extends StatefulWidget {

  final Color color;
  HomeScreen({
    required this.color,
    Key? key,
  }) : super(key: key) {
    print('constructor 실행');
  }

  @override
  State<StatefulWidget> createState() { //StatefulWidget의 State를 돌려준다
    print('createState 실행'); //새로 생성된 위젯은 기존의 State를 찾는다
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> { //State는 무조건 StatefulWidget과 한세트다

  int num = 0;

  @override
  void initState() {
    print('initState 실행');
    super.initState();
  }

  @override
  void didChangeDependencies() {
    print('didChangeDependencies 실행');
    super.didChangeDependencies();
  }

  @override
  void deactivate() {
    print('deactivate 실행');
    super.deactivate();
  }

  @override
  void dispose() {
    print('dispose 실행');
    super.dispose(); //State도 사라짐
  }

  @override
  void didUpdateWidget(covariant HomeScreen oldWidget) {
    print('didUpdateWidget 실행');
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    print('build 실행');
    //GestureDetector - 화면에서 인식할 수 있는 모든 행동들을 넣을 수 있다
    return GestureDetector(
      onTap: () {
        setState(() { //변경하고 싶은 값을 이 함수에서 변경
          num++; //위젯은 새로 만들어지지만 State는 계속 유지
        });
      },
      child: Container(
        width: 50.0,
        height: 50.0,
        color: widget.color, //제네릭을 통해서 위젯이 어떤 값이 될지 알고 있다
        child: Center(
          child: Text(num.toString()),
        ),
      ),
    );
  }
}

// class HomeScreen extends StatelessWidget {
//
//   final Color color;
//
//   const _HomeScreen({ //생성자로 생성이 되고 build 함수를 실행한다, 변경이 필요하면 새로운 위젯을 생성
//     required this.color,
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 50.0,
//       height: 50.0,
//       color: color,
//     );
//   }
// }