import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scrollable_widgets/const/colors.dart';


class CustomScrollViewScreen extends StatelessWidget {

  final List<int> numbers = List.generate(
      10, (index) => index
  );

  CustomScrollViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        //슬리버는 넣을 수 있는 위젯들이 특정되어있다 - Sliver ~~~로 시작
        slivers: [
          //AppBar도 리스트의 일부로
          renderSliverAppBar(),
          renderHeader(),
          renderBuilderSliverList(),
          renderHeader(),
          renderSliverGridBuilder(),
          renderHeader(),
          renderSliverGridBuilder(),
        ],
      ),
    );
  }

  //Sliver AppBar
  SliverAppBar renderSliverAppBar() {
    return SliverAppBar(
      floating: true, //true - 위로 스크롤하면 다시 앱바가 보이는 형태
      pinned: false, //true - 스크롤을 해도 기본 앱바 처럼 고정
      snap: true, //true - 터치해서 움직이면 앱바가 완전히 움직임(자석 효과?) - floating이 true일 때 사용가능
      stretch: true, //true - 리스트를 맨위에서 당기면 앱바가 늘어남
      expandedHeight: 200, //늘어났을 때 최대 사이즈
      collapsedHeight: 150, //최소 사이즈
      title: Text('CustomScrollViewScreen'),
      flexibleSpace: FlexibleSpaceBar( //늘어났을 때 넣을 수 있는 공간
        background: Image.asset(
          'asset/img/image_1.jpeg',
          fit: BoxFit.cover,
        ),
        // title: Text('FlexibleSpace'),
      ),
      backgroundColor: Colors.blue,
    );
  }

  //Sliver Persistent Header
  SliverPersistentHeader renderHeader() {
    return SliverPersistentHeader(
      pinned: true, //헤더가 쌓임
      delegate: _SliverFixedHeaderDelegate(
        child: Container(
          color: Colors.black,
          child: Center(
            child: Text(
              'ㅋㅋㅋㅋ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              ),
            ),
          ),
        ),
        maxHeight: 150,
        minHeight: 100,
      ),
    );
  }

  //Sliver ListView Constructor
  SliverList renderChildSliverList() {
    return SliverList(
      //어떤 형태로 SliverList를 만들어낼지
      delegate: SliverChildListDelegate( //기본 형태의 리스트
        numbers.map((e) =>
            renderContainer(
              color: rainbowColors[e % rainbowColors.length],
              index: e,
            ),
        ).toList(),
      ),
    );
  }

  //Sliver ListView builder
  SliverList renderBuilderSliverList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        return renderContainer(
          color: rainbowColors[index % rainbowColors.length],
          index: index,
        );
      },
        childCount: 10,
      ),
    );
  }

  //Sliver GridView count 유사
  SliverGrid renderChildSliverGrid() {
    return SliverGrid(
      delegate: SliverChildListDelegate( //동일하게 사용
        numbers.map((e) =>
            renderContainer(
              color: rainbowColors[e % rainbowColors.length],
              index: e,
            ),
        ).toList(),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
    );
  }

  //Sliver GridView builder
  SliverGrid renderSliverGridBuilder() {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate((context, index) {
        return renderContainer(
          color: rainbowColors[index % rainbowColors.length],
          index: index,
        );
      },
        childCount: 30,
      ),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 250,
      ),
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

  Widget renderColumn() {
    return Column(
      children: [
        //모든 리스트 또는 스크롤 가능한 위젯을 컬럼 안에 넣었을 때 Expanded 안에 넣지 않으면 오류가 난다
        //리스트로 무한하게 많은 위젯들을 넣을 수 있기 때문에 이론상으로 무한한 높이를 차지할 수 있다
        Expanded(
          child: ListView(
            children: rainbowColors.map((e) =>
                renderContainer(color: e, index: 1),
            ).toList(),
          ),
        ),
        //ListView와 GridView가 따로 논다 - 이것이 원하는 형태일 수 있음
        Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              children: rainbowColors.map((e) =>
                  renderContainer(color: e, index: 1),
              ).toList(),
            )
        ),
      ],
    );
  }

}

class _SliverFixedHeaderDelegate extends SliverPersistentHeaderDelegate {

  final Widget child;
  final double maxHeight;
  final double minHeight;

  _SliverFixedHeaderDelegate({
    required this.child,
    required this.maxHeight,
    required this.minHeight,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(
      child: child,
    );
  }

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  //covariant - 상속된 클래스도 사용가능
  //oldDelegate - 빌드 시 기존에 존재하던 delegate
  //this - 새로운 delegate
  //새로 빌드를 해야할지 말지
  bool shouldRebuild(_SliverFixedHeaderDelegate oldDelegate) {
    return oldDelegate.minHeight != minHeight
        || oldDelegate.maxHeight != maxHeight
        || oldDelegate.child != child;
  }
}
