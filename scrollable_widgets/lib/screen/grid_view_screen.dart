import 'package:flutter/material.dart';

import '../const/colors.dart';
import '../layout/main_layout.dart';

class GridViewScreen extends StatelessWidget {

  final List<int> numbers = List.generate(
      100, (index) => index
  );

  GridViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'GridViewScreen',
      body: renderMaxExtent(),
    );
  }

  //카운트
  Widget renderCount() {
    return GridView.count(
      //리스트들은 위에서 아래로가 메인 엑시스라고 가정을 한다
      crossAxisCount: 3, //가로로 넣을 개수
      crossAxisSpacing: 12.0, //가로 간격
      mainAxisSpacing: 12.0, //세로 간격
      //위젯을 한번에 다 그림
      children: numbers.map((e) =>
          renderContainer(
              color: rainbowColors[e % rainbowColors.length],
              index: e
          )
      ).toList(),
    );
  }

  //빌더
  Widget renderBuilderCrossAxisCount() {
    return GridView.builder(
      //어떤식으로 그릴지 정의
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12.0,
        mainAxisSpacing: 12.0,
      ),
      itemBuilder: (context, index) {  //ListView의 빌더와 같음
        return renderContainer(
          color: rainbowColors[index % rainbowColors.length],
          index: index,
        );
      },
    );
  }

  //최대 사이즈 지정
  Widget renderMaxExtent() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        //그리드를 똑같이 나눌 수 있는 크기를 자동으로 찾아서 배치
        //실제 위젯 사이즈가 늘어나진 않는다
        maxCrossAxisExtent: 100, //최대 사이즈를 설정
        // crossAxisSpacing: 12.0,
        // mainAxisSpacing: 12.0,
      ),
      itemCount: 100,
      itemBuilder: (context, index) {
        return renderContainer(
          color: rainbowColors[index % rainbowColors.length],
          index: index,
        );
      },
    );
  }

  Widget renderContainer({required Color color, required int index, double? height}) {
    print(index);
    return Container(
      height: height ?? 300,
      color: color,
      child: Center(
        child: Text(
          index.toString(),
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 30.0
          ),
        ),
      ),
    );
  }

}
