import 'package:flutter/material.dart';
import 'package:scrollable_widgets/const/colors.dart';
import 'package:scrollable_widgets/layout/main_layout.dart';

class ListViewScreen extends StatelessWidget {

  final List<int> numbers = List.generate(
      100, (index) => index
  );

  ListViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'ListViewScreen',
      body: renderSeparator(),
    );
  }

  //기본 렌더링
  Widget renderDefault() {
    return ListView( //한번에 모든 위젯을 다 그린다
      children: numbers.map((e) =>
          renderContainer(
              color: rainbowColors[e % rainbowColors.length],
              index: e
          )
      ).toList(),
    );
  }

  //빌더
  Widget renderBuilder() {
    return ListView.builder(
      itemCount: 100,
      itemBuilder: (context, index) {
        //한번에 다 그리는게 아닌 스크롤을 할 때 마다 위젯을 그린다
        //넘어간 부분은 위젯을 지워버린다
        //퍼포먼스 향상에 도움을 준다
        return renderContainer(
          color: rainbowColors[index % rainbowColors.length],
          index: index,
        );
      },
    );
  }

  //세퍼레이터
  Widget renderSeparator() {
    return ListView.separated(
      itemCount: 100,
      itemBuilder: (context, index) {
        return renderContainer(
          color: rainbowColors[index % rainbowColors.length],
          index: index,
        );
      },
      //itemBuilder로 그려주는 위젯들 사이에 위젯들이 들어간다 - 베너, 광고등에 유용
      separatorBuilder: (context, index) {
        if(index % 5 == 0 && index != 0) {
          return renderContainer(
            color: Colors.black,
            index: index,
            height: 100,
          );
        }
        return Container();
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

