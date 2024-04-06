import 'dart:math';

import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final textStyle = TextStyle(
    fontSize: 16.0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          //StreamBuilder는 스트림을 닫을 필요없다
          child: StreamBuilder(
            builder: (context, snapshot) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'StreamBuilder',
                    style: textStyle.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 20.0
                    ),
                  ),
                  Text(
                    //스트림이 완전히 끝나지 않았다면 Active
                    'ConState : ${snapshot.connectionState}',
                    style: textStyle,
                  ),
                  // Row(
                  //   children: [
                  Text(
                    'Data : ${snapshot.data}',
                    style: textStyle,
                  ),
                  Text(
                    'Error : ${snapshot.error}',
                    style: textStyle,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        //FutureBuilder와 마찬가지로 캐싱이 됨
                        setState(() {
                        });
                      },
                      child: Text('setState',)
                  ),
                ],
              );
            }, stream: streamNumbers(),
          ),
        )
    );
  }

  Stream<int> streamNumbers() async* {
    for(int i = 0; i < 10; i++) {
      if(i == 5) throw Exception('i == 5');
      await Future.delayed(Duration(seconds: 1));
      yield i;
    }
  }

}


