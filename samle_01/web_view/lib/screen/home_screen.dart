import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

final homeUrl = Uri.parse("https://github.com/chasenpai");

class HomeScreen extends StatelessWidget {

  //원래 컨트롤러를 선언 할 땐 StatefulWidget에서 선언해야 한다
  WebViewController controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted) //자바스크립트 활성화 - ios는 기본값이 활성화
    ..loadRequest(homeUrl);
  //점 두개 - 이 함수를 실행은 하되 실행한 대상을 반환
  //final controller = WebViewController();
  //controller.loadRequest();

  //const 생성자는 안의 모든 값이 const여야 하지만 WebViewController는 const 생성자가 존재하지 않는다
  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //Scaffold - 단순한 구조를 만들 수 있게 해주는 위젯
    return Scaffold(
      //AppBar - 상단에 제목과 같은 것을 작성할 수 있게 해준다
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Web View Example', style: TextStyle(color: Colors.white),),
        //ios는 중간이 기본, android는 좌가 기본
        centerTitle: true,
        //actions - appBar의 오른쪽에 위젯을 배치
        actions: [
          IconButton(
            //콜백 함수
            onPressed: (){
              controller.loadRequest(homeUrl);
            },
            icon: Icon(
              Icons.home,
            )
          )
        ],
      ),
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}
