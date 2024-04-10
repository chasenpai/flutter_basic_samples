import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Timer? timer; //Async 패키지에서 제공하는 타이머

  PageController controller = PageController(
    initialPage: 0,
  );

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 2), (timer) { //Future와 유사함
      int currentPage = controller.page!.toInt();
      int nextPage = currentPage + 1;
      if(nextPage > 4){
        nextPage = 0;
      }
      //페이지를 바꾸는 기능
      controller.animateToPage(
          nextPage,
          duration: Duration(milliseconds: 500),
          curve: Curves.linear //애니메이션이 어떤식으로 실행되는지
      );
    });
  }

  @override
  void dispose() { //State가 사라질 때
    controller.dispose();
    if(timer != null){
      timer!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    //앱과 관련이 없는 상태바 등을 바꿀 수 있다
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return Scaffold(
      //PageView - 스크롤을 할 수 있는 스크린
      body: PageView(
        controller: controller, //페이지 뷰 조정
        children: [1, 2, 3, 4, 5].map((e) =>
            Image.asset('asset/img/image_$e.jpeg', fit: BoxFit.cover,) //BoxFit.cover - 이미지를 화면에 꽉차게 만들어준다, 다만 비율대로 늘리기 때문에 사진이 잘릴 수 있다
        ).toList(),
      ),
    );
  }
}
