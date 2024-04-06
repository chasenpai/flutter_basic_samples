import 'package:flutter/material.dart';

//stless
class RowWidget extends StatelessWidget {
  const RowWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //SafeArea -상태바, 홈버튼과 같은 시스템 영역을 벗어나게 해준다
        body: SafeArea(
          bottom: false,
          //Container - 위젯들을 넣는 역할
          child: Container(
            color: Colors.black,
            // height: MediaQuery.of(context).size.height, //현재 핸드폰의 사이즈
            child: Row(
              //MainAxisAlignment - 주축 정렬
              //start - 시작
              //end - 끝
              //center - 가운대
              //spaceBetween - 끝과 끝, 위젯과 사이의 간격이 동일하게
              //spaceEvenly - 끝과 끝이 빈 간격으로 시작
              //spaceAround - 끝과 끝이 빈 간격으로 시작하고 간격이 1/2
              mainAxisAlignment: MainAxisAlignment.start,
              //CrossAxisAlignment - 반대축 정렬
              //start - 시작
              //end - 끝
              //center - 가운대(기본값)
              //stretch - 최대로 늘림
              crossAxisAlignment: CrossAxisAlignment.start,
              //MainAxisSize - 주축 크기
              //max - 최대
              //min - 최소
              mainAxisSize: MainAxisSize.max,
              children: [
                //Expanded & Flexible - 로우와 컬럼의 자식에게만 사용 가능
                //Expanded - 최대한으로 남은 사이즈를 모두 나눠서 차지
                Expanded(
                  //flex - 나머지 공간을 나눠서 차지하는 비율
                  flex: 2,
                  child: Container(
                    color: Colors.red,
                    width: 50,
                    height: 50,
                  ),
                ),
                //Flexible - 비율 만큼의 공간을 차지하고 남는 공간은 버림
                Flexible(
                  flex: 3,
                  child: Container(
                    color: Colors.blue,
                    width: 50,
                    height: 50,
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.green,
                    width: 50,
                    height: 50,
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.yellow,
                    width: 50,
                    height: 50,
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}

class ColumnWidget extends StatelessWidget {
  const ColumnWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //SafeArea -상태바, 홈버튼과 같은 시스템 영역을 벗어나게 해준다
      body: SafeArea(
        bottom: false,
        //Container - 위젯들을 넣는 역할
        child: Container(
          color: Colors.black,
          width: MediaQuery.of(context).size.width, //현재 핸드폰의 사이즈
          child: Column(
            //MainAxisAlignment - 주축 정렬
            //start - 시작
            //end - 끝
            //center - 가운대
            //spaceBetween - 끝과 끝, 위젯과 사이의 간격이 동일하게
            //spaceEvenly - 끝과 끝이 빈 간격으로 시작
            //spaceAround - 끝과 끝이 빈 간격으로 시작하고 간격이 1/2
            mainAxisAlignment: MainAxisAlignment.start,
            //CrossAxisAlignment - 반대축 정렬
            //start - 시작
            //end - 끝
            //center - 가운대(기본값)
            //stretch - 최대로 늘림
            crossAxisAlignment: CrossAxisAlignment.stretch,
            //MainAxisSize - 주축 크기
            //max - 최대
            //min - 최소
            mainAxisSize: MainAxisSize.min,
            children: [
              //Expanded & Flexible - 로우와 컬럼의 자식에게만 사용 가능
              //Expanded - 최대한으로 남은 사이즈를 모두 나눠서 차지
              Expanded(
                //flex - 나머지 공간을 나눠서 차지하는 비율
                flex: 2,
                child: Container(
                  color: Colors.red,
                  width: 50,
                  height: 50,
                ),
              ),
              //Flexible - 비율 만큼의 공간을 차지하고 남는 공간은 버림
              Flexible(
                flex: 3,
                child: Container(
                  color: Colors.blue,
                  width: 50,
                  height: 50,
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.green,
                  width: 50,
                  height: 50,
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.yellow,
                  width: 50,
                  height: 50,
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}

