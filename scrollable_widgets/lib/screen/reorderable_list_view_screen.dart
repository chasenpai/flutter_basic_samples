import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_widgets/const/colors.dart';
import 'package:scrollable_widgets/layout/main_layout.dart';

class ReorderableListViewScreen extends StatefulWidget {
  const ReorderableListViewScreen({super.key});

  @override
  State<ReorderableListViewScreen> createState() => _ReorderableListViewScreenState();
}

class _ReorderableListViewScreenState extends State<ReorderableListViewScreen> {

  List<int> numbers = List.generate(
      100, (index) => index
  );

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'ReorderableListViewScreen',
      body: ReorderableListView.builder(
        onReorder: (int oldIndex, int newIndex) {
          setState(() {
            if(oldIndex < newIndex) {
              newIndex -= 1;
            }
            final item = numbers.removeAt(oldIndex);
            numbers.insert(newIndex, item);
          });
        },
        itemCount: numbers.length,
        itemBuilder: (context, index) {
          //index 값을 그냥 받으면 위젯을 옮겼을 때 숫자와 색상이 바뀐다
          //실제 변경하는 데이터를 레퍼런스해야 한다
          return renderContainer(
              color: rainbowColors[numbers[index] % rainbowColors.length],
              index: numbers[index],
          );
        },
      ),
    );
  }

  Widget renderDefault() {
    return ReorderableListView(
      //순서를 바꿨을 때 실행 - 실제 값의 순서를 바꿔주면 된다
      onReorder: (int oldIndex, int newIndex) {
        setState(() {
          //old와 new 모두 이동이 되기 전에 산정된다
          //[red, orange, yellow]
          //[0, 1, 2]
          //red를 yellow 다음으로 옮기면
          //red : 0(oldIndex) > 3(newIndex)
          //[orange, yellow, red] //1을 빼줘야 함
          //
          //[red, orange, yellow]
          //yellow를 맨 앞으로 옮기면
          //yellow : 2(oldIndex) > 0(newIndex)
          //[yellow, red, orange]
          if(oldIndex < newIndex) {
            newIndex -= 1;
          }
          final item = numbers.removeAt(oldIndex);
          numbers.insert(newIndex, item);
        });
      },
      children: numbers.map((e) =>
          renderContainer(
              color: rainbowColors[e % rainbowColors.length],
              index: e
          )
      ).toList(),
    );
  }

  Widget renderContainer({required Color color, required int index, double? height}) {
    print(index);
    return Container(
      key: Key(index.toString()),
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
