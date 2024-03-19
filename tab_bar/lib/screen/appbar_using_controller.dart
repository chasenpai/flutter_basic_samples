import 'package:flutter/material.dart';
import 'package:tab_bar/const/tabs.dart';

class AppBarUsingController extends StatefulWidget {
  const AppBarUsingController({super.key});

  @override
  State<AppBarUsingController> createState() => _AppBarUsingControllerState();
}
//TickerProviderStateMixin - 실제 한 프레임당 틱을 효율적으로 컨트롤할 수 있게 해줌
class _AppBarUsingControllerState extends State<AppBarUsingController> with TickerProviderStateMixin {
  //late - 값을 나중에 정해주겠다
  late final TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      length: TABS.length,
      vsync: this,
    );
    //탭 컨트롤러의 값이 변경될 떄 마다 함수 실행
    tabController.addListener(() {
      setState(() {

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appbar Using Controller'),
        bottom: TabBar(
          controller: tabController,
          labelStyle: TextStyle(
            fontSize: 12.0,
          ),
          tabs: TABS.map((e) =>
            Tab(
              icon: Icon(e.icon),
              child: Text(e.label),
            )
          ).toList(),
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: TABS.map((e) =>
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(e.icon),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if(tabController.index != 0)
                    ElevatedButton(
                      onPressed: () {
                        tabController.animateTo(
                          tabController.index - 1,
                        );
                      },
                      child: Text('이전',),
                    ),
                  const SizedBox(width: 16.0,),
                  if(tabController.index != TABS.length -1)
                    ElevatedButton(
                      onPressed: () {
                        tabController.animateTo(
                          tabController.index + 1,
                        );
                      },
                      child: Text('다음',),
                    ),
                ],
              )
            ],
          )
        ).toList(),
      ),
    );
  }
}
