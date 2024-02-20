import 'package:flutter/material.dart';
import 'package:navigation/layout/main_layout.dart';
import 'package:navigation/screen/route_one_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope( //Deprecated -> PopScope
      onWillPop: () async { //Deprecated -> canPop
        final canPop = Navigator.of(context).canPop();
        return canPop; //시스템에서 더이상 뒤로갈 수 없게
      },
      child: MainLayout(
          title: 'HomeScreen',
          children: [
            ElevatedButton(
              onPressed: () {
                //첫 스택에서 팝을 하면 검은스크린
                Navigator.of(context).pop();
              },
              child: Text('Pop'),
            ),
            ElevatedButton(
                onPressed: () {
                  //maybePop - 더이상 뒤로갈 페이지가 없으면 뒤로가기가 안됨(실수 방지)
                  Navigator.of(context).maybePop();
                },
                child: Text('Maybe Pop'),
            ),
            ElevatedButton(
              onPressed: () {
                //canPop - 팝을 할 수 있는지 없는지 확인 가능
                //애초에 ios에서는 뒤로갈 수 없으면 기본 뒤로가기 버튼이 표시되지 않는다
                //하지만 안드로이드는 뒤로가기 버튼이 있다
                print(Navigator.of(context).canPop());
              },
              child: Text('Can Pop'),
            ),
            ElevatedButton(
              onPressed: () async {
                final result = await Navigator.of(context).push(
                  MaterialPageRoute(
                    //스크린은 이미 존재하는 스크린 위에 하나씩 쌓인다 - Stack
                    builder: (BuildContext context) => RouteOneScreen(number: 1,),
                  ),
                );
                print(result);
              },
              child: Text('Push'),
            )
          ],
      ),
    );
  }
}
