import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _State();
}

class _State extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //const - 빌드 타임에 모든 값들을 알 수 있을 때만 사용 가능
            //단 한번만 화면에 그려지면 다시 빌드 할 때 위젯을 재사용 - 해당되는 위젯의 빌드 함수는 실행되지 않음
            const TestWidget(label: 'label1',),
            const TestWidget(label: 'label2',),
            //해당 버튼은 const 사용 불가능 - onPressed 안에서 무슨일이 일어날지 모르기 때문
            ElevatedButton(
                onPressed: (){
                  setState(() {

                  });
                },
                //안의 텍스트는 가능
                child: const Text(
                  'build',
                )
            )
          ],
        ),
      ),
    );
  }
}

class TestWidget extends StatelessWidget {

  final String label;
  const TestWidget({required this.label, Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('$label build 실행');
    return Container(
      child: Text(
        label,
      ),
    );
  }
}

