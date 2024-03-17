import 'package:fine_dust/main.dart';
import 'package:fine_dust/screen/test2_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TestScreen'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ValueListenableBuilder<Box>( //StreamBuilder와 동일하다 - box안에서 변경사항이 있으면 빌더 재실행
            valueListenable: Hive.box(testBox).listenable(),
            builder: (context, box, widget) {
              return Column(
                children: box.values.map((e) => Text(e.toString()),).toList(),
              );
            },
          ),
          ElevatedButton(
            onPressed: () {
              final box = Hive.box(testBox);
              print('key : ${box.keys.toList()}');
              print('values : ${box.values.toList()}');
            },
            child: Text('PrintBox'),
          ),
          ElevatedButton(
            onPressed: () {
              final box = Hive.box(testBox);
              //box.add('test3'); //알아서 key를 정하고 key에 해당하는 value가 들어간다
              box.put(100, 'test4'); //key를 지정 - data 생성 또는 업데이트
              box.put(2, '2222');
              box.put(101, true);
              box.put(102, { //NoSql의 장점이자 단점 - 어떤 형태든 상관없다!
                'test1': 'testA',
                'test2': 'testB',
              });
              box.put(103, [1, 2, 3]);
              box.put(5, 'test5'); //key값을 기준으로 오름차순 정렬이 기본값
            },
            child: Text('InputData'),
          ),
          ElevatedButton(
            onPressed: () {
              final box = Hive.box(testBox);
              print(box.get(2));
              print(box.getAt(3)); //n번 index
            },
            child: Text('GetData'),
          ),
          ElevatedButton(
            onPressed: () {
              final box = Hive.box(testBox);
              box.delete(2);
              box.deleteAt(3);
              box.deleteAll([101, 102, 103]);
            },
            child: Text('DeleteData'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (_) => Test2Screen(),
                )
              );
            },
            child: Text('NextScreen'),
          ),
        ],
      ),
    );
  }
}
