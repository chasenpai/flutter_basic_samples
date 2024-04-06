import 'package:flutter/material.dart';
import 'package:scrollable_widgets/const/colors.dart';
import 'package:scrollable_widgets/layout/main_layout.dart';

class SingleChildScrollViewScreen extends StatelessWidget {

  final List<int> numbers = List.generate(
      100, (index) => index
  );

  SingleChildScrollViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'SingleChildScrollView',
      body: renderPerformance(),
    );
  }

  //기본 렌더링 방식
  Widget renderSimple() {
    //SingleChildScrollView - child 안의 위젯의 크기가 화면을 넘어서면 스크롤이 되도록 해준다
    return SingleChildScrollView(
      //대부분 한번에 여러 위젯을 스크롤하기 때문에 컬럼을 같이 사용하는 형태를 주로 사용
      child: Column(
        children: rainbowColors.map((e) => renderContainer(color: e)).toList(),
      ),
    );
  }

  //화면을 넘어가지 않아도 스크롤
  Widget renderAlwaysScroll() {
    return SingleChildScrollView(
      //스크롤이 어떻게 작용을 하는지 정한다
      //NeverScrollableScrollPhysics - 기본값
      physics: AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          renderContainer(color: Colors.black),
        ],
      ),
    );
  }

  //위젯이 잘리지 않게
  Widget renderClip() {
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      //clipBehavior - 잘렸을 때
      clipBehavior: Clip.none, //안 잘림
      child: Column(
        children: [
          renderContainer(color: Colors.black),
        ],
      ),
    );
  }

  //physics 정리
  Widget renderPhysics() {
    return SingleChildScrollView(
      //NeverScrollableScrollPhysics - 스크롤 안됨
      //AlwaysScrollableScrollPhysics - 스크롤 됨
      //BouncingScrollPhysics - 튕기는 형태로 스크롤(ios 스타일)
      //ClampingScrollPhysics - 튕기지 않고 걸리는 형태(android 스타일)
      physics: ClampingScrollPhysics(),
      child: Column(
        children: rainbowColors.map((e) => renderContainer(color: e)).toList(),
      ),
    );
  }

  //퍼포먼스
  Widget renderPerformance() {
    return SingleChildScrollView(
      child: Column(
        //100개가 한번에 실행 - 화면에 보이지 않는 부분도 전부 생성(성능 이슈 발생)
        children: numbers.map((e) =>
            renderContainer(
              color: rainbowColors[e % rainbowColors.length],
              index: e,
            )
        ).toList(),
      ),
    );
  }

  Widget renderContainer({required Color color, int? index}) {
    if(index != null) {
      print(index);
    }
    return Container(
      height: 300,
      color: color,
    );
  }
}
