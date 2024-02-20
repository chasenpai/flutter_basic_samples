import 'package:flutter/material.dart';
import 'package:navigation/layout/main_layout.dart';
import 'package:navigation/screen/route_two_screen.dart';

class RouteOneScreen extends StatelessWidget {

  final int? number;

  const RouteOneScreen({this.number, super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
        title: 'RouteOne',
        children: [
          Text(
            number.toString(),
            //텍스트 위젯은 실제로 전체 사이즈를 차지하고 있지만 글자 자체가 왼쪽 > 오른쪽으로 쓰이기 때문에
            //전체 공간을 차지하고 있는 텍스트 위젯 안에서 정렬 가능
            textAlign: TextAlign.center,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(0);
            },
            child: Text('Pop'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).maybePop(0);
            },
            child: Text('Maybe Pop'),
          ),
          ElevatedButton(
            onPressed: () {
              print(Navigator.of(context).canPop());
            },
            child: Text('Can Pop'),
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => RouteTwoScreen(),
                    settings: RouteSettings( //arguments로 값 전달
                      arguments: 2,
                    )
                  ),
                );
              },
              child: Text('Push')
          )

        ]
    );
  }
}
