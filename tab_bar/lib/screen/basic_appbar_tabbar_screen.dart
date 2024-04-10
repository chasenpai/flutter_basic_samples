import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tab_bar/const/tabs.dart';

class BasicAppbarTabbarScreen extends StatelessWidget {
  const BasicAppbarTabbarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController( //자동으로 컨트롤러 주입
      length: TABS.length, //탭의 전체 길이
      child: Scaffold(
        appBar: AppBar(
          title: Text('BasicAppBarScreen'),
          //앱바 타이틀 아래
          bottom: PreferredSize( //child가 Widget이기 때문에 Row에도 넣을 수 있다
            preferredSize: Size.fromHeight(80),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TabBar(
                  //인디케이터 스타일링
                  indicatorColor: Colors.red,
                  indicatorWeight: 4.0,
                  indicatorSize: TabBarIndicatorSize.tab,
                  isScrollable: true, //true - 탭이 길어지면 스크롤할 수 있게, 탭의 사이즈만큼 차지
                  //레이블 스타일링
                  labelColor: Colors.orange,
                  unselectedLabelColor: Colors.green,
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                  unselectedLabelStyle: TextStyle(
                      fontWeight: FontWeight.w100,
                  ),
                  tabs: TABS.map((e) =>
                      Tab(
                        icon: Icon(e.icon),
                        child: Text(e.label),
                      )
                  ).toList(),
                ),
              ],
            ),
          ),
        ),
        body: TabBarView( //컨트롤러로 자동 연동
          //physics: NeverScrollableScrollPhysics(),
          children: TABS.map((e) =>
            Center(
              child: Icon(e.icon),
            ),
          ).toList(),
        ),
      ),
    );
  }
}
