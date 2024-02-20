import 'package:flutter/material.dart';
import 'package:navigation/screen/route_three_screen.dart';

import '../layout/main_layout.dart';

class RouteTwoScreen extends StatelessWidget {
  const RouteTwoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //위젯 트리에서 가장 가까운 ModalRoute를 가져옴
    //ModalRoute - 풀 스크린 위젯(RouteTwoScreen)
    final arguments = ModalRoute.of(context)!.settings.arguments;
    return MainLayout(
        title: 'RouteTwo',
        children: [
          Text(
            'arguments : ${arguments.toString()}',
            textAlign: TextAlign.center,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Pop'),
          ),
          ElevatedButton(
            onPressed: () {
              //Push Named
              Navigator.of(context).pushNamed('/three', arguments: 3);
            },
            child: Text('Push Named'),
          ),
          ElevatedButton(
            onPressed: () {
              //replacement - 바로 전 라우터를 지워버림(대체)
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (_) => RouteThreeScreen(),
                    settings: RouteSettings(
                      arguments: 2,
                    )
                ),
              );
            },
            child: Text('Push Replacement'),
          ),
          ElevatedButton(
            onPressed: () {
              //replacement - 바로 전 라우터를 지워버림(대체)
              Navigator.of(context).pushReplacementNamed('/three', arguments: 3);
            },
            child: Text('Push Replacement Named'),
          ),
          ElevatedButton(
            onPressed: () {
              //pushAndRemoveUntil - 라우트 스텍을 삭제
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (_)  => RouteThreeScreen()
                ),
                //false를 리턴하면 삭제 - HomeScreen 제외하고 삭제
                //조건이 참인 라우트만 살린다
                (route) => route.settings.name == '/',
              );
            },
            child: Text('Push And Remove Until'),
          ),
          ElevatedButton(
            onPressed: () {
              //pushAndRemoveUntil - 라우트 스텍을 삭제
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/three', arguments: 3,
                (route) => route.settings.name == '/',
              );
            },
            child: Text('Push Named And Remove Until'),
          )
        ]
    );
  }
}
