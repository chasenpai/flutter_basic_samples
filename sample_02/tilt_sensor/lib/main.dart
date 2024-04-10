import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sensors_plus/sensors_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SensorApp(),
    );
  }
}

class SensorApp extends StatelessWidget {
  const SensorApp({super.key});

  @override
  Widget build(BuildContext context) {
    //가로모드 고정 - 허용되는 방향 설정
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);

    //MediaQuery를 통해 가운데 위치 값을 얻음
    final centerX = MediaQuery.of(context).size.width / 2 - 50;
    final centerY = MediaQuery.of(context).size.height / 2 - 50;

    return Scaffold(
      //Stack - 컬럼이나 로우는 겹칠 수 없지만 스택은 자식들을 겹칠 수 있고 원하는 위치에 배치 가능
      body: Stack(
        children: [
          //sensor plus
          StreamBuilder<AccelerometerEvent>(
            stream: accelerometerEventStream(), //가속도 이벤트 값이 스트림으로 들어온다
            builder: (context, snapshot) {
              if(!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              final event = snapshot.data!;
              List<double> values = [event.x, event.y, event.z];
              return Positioned( //Positioned - 위젯의 위치를 원하는 곳으로 이동
                left: centerX + values[1] * 20,
                top: centerY + values[0] * 20,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    //데코레이션 안에서 색상 지정 시 컨테이너의 색상은 제거해야 함
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
              );
            }
          ),
        ],
      ),
    );
  }
}
