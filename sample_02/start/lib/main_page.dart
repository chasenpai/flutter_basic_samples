import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/*
 * Dart에서 일반적인 룰
 * 클래스는 CamelCase
 * 파일명은 snake_case
 */
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  //Hot Restart
  int count = 0;
  String _text = '';
  //Dart는 인스턴스 생성 시 new 키워드 생략 가능, 상수는 선언부 생략 가능
  final _textController = TextEditingController(); //언더바(_) - private

  @override
  void dispose() {
    _textController.dispose(); //삭제해서 메모리 관리
    super.dispose();
  }

  //Hot Reload
  @override
  Widget build(BuildContext context) {
    //Scaffold - 앱을 구성하는 뼈대
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home',
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            //메인 방향 정렬
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                //크기와 색을 가질 수 있다
                color: Colors.blue,
                width: 100,
                height: 100,
              ),
              SizedBox(
                //크기만 가질 수 있다 - 성능상 유리
                height: 50,
              ),
              Text(
                count.toString(),
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 100,
                ),
              ),
              Text(
                count.toString(),
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 100,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  print('ElevatedButton Click!');
                },
                child: Text(
                  'ElevatedButton',
                ),
              ),
              TextButton(
                onPressed: () {
                  print('TextButton Click!');
                },
                child: Text(
                  'TextButton',
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  print('OutlinedButton Click!');
                },
                child: Text(
                  'OutlinedButton',
                ),
              ),
              Row(
                children: [
                  //Expanded - 나머지 영역을 채운다
                  Expanded(
                    flex: 3,
                    child: TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        labelText: 'text',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        _text = value;
                      },
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        print(_text);
                        //onChanged를 사용하지 않고 텍스트 필드에 있는 값을 얻을 수 있음
                        print(_textController.value.text);
                        setState(() {});
                      },
                      child: Text(
                        'login',
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                _textController.text,
              ),
              Image.network(
                'https://img1.daumcdn.net/thumb/R1280x0.fjpg/?fname=http://t1.daumcdn.net/brunch/service/user/32E9/image/BA2Qyx3O2oTyEOsXe2ZtE8cRqGk.JPG',
                width: 300,
                height: 100,
                fit: BoxFit.cover,
              ),
              Container(
                //크기 지정이 없으면 컨테이너의 크기는 자식 위젯의 크기를 따른다
                color: Colors.blue,
                width: 400,
                //크기 지정이 있으면 자식은 컨테이너의 크기를 따른다
                child: Image.asset(
                  'assets/tesla.jpg',
                  width: 300,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //화면 갱신 - 위젯 재빌드
          setState(() {
            count++;
          });
        },
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }
}
