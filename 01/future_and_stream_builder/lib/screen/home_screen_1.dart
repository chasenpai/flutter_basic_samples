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
        child: FutureBuilder<int>( //함수에서 예측을 하기 때문에 제네릭을 넣을 필요는 없다 - 명시 용도
          //connectionState가 바뀔 때 마다 builder를 새로 호출 - setState를 사용하지 않고 화면변경 가능
          builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
            //데이터를 한번도 요청하지 않았을 때만 로딩바
            // if(!snapshot.hasData){
            //   return Center(
            //     child: CircularProgressIndicator(),
            //   );
            // }
            //데이터가 있을 때 위젯 렌더링
            if(snapshot.hasData){
            }
            //에러가 발생했을 때 위젯 렌더링
            if(snapshot.hasError){
            }
            //로딩 중일 때 위젯 렌더링
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'FutureBuilder',
                  style: textStyle.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 20.0
                  ),
                ),
                Text(
                  'ConState : ${snapshot.connectionState}',
                  style: textStyle,
                ),
                // Row(
                //   children: [
                    Text(
                      'Data : ${snapshot.data}',
                      style: textStyle,
                    ),
                  //   if(snapshot.connectionState == ConnectionState.waiting)
                  //     CircularProgressIndicator(),
                  // ],
                // ),
                Text(
                  'Error : ${snapshot.error}',
                  style: textStyle,
                ),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        //setState함수를 불러서도 FutureBuilder를 다시 호출할 수 있다
                        //빌드를 다시해도 기존의 데이터 값을 유지 - 캐싱
                      });
                    },
                    child: Text('setState',)
                ),
              ],
            );
          }, future: getNumber(),
        ),
      )
    );
  }

  Future<int> getNumber() async {
    await Future.delayed(Duration(seconds: 3));
    final random = Random();
    throw Exception('에러 발생!!');
    return random.nextInt(100);
  }

}


