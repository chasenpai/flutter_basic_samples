import 'package:fine_dust/const/colors.dart';
import 'package:flutter/material.dart';

const regions = [
  '서울',
  '경기',
  '대구',
  '서울',
  '경기',
  '대구',
  '서울',
  '경기',
  '대구',
  '서울',
  '경기',
  '대구',
  '서울',
  '경기',
  '대구',
];

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: darkColor,
      child: ListView(
        children: [
          DrawerHeader(
            // decoration: BoxDecoration(
            //   border: Border.all(color: Colors.black),
            // ),
            child: Text(
              '지역 선택',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              ),
            ),
          ),
          //...Cascading Operation - 리스트를 풀어놓는다
          ...regions.map((e) =>
            ListTile( //꼭 ListView안에 써야하는건 아니지만 ListView안에서 써야 예쁘게 나오도록 설계되어있음
              onTap: () {

              },
              tileColor: Colors.white,
              selectedTileColor: lightColor, //선택된 타일 색상
              selectedColor: Colors.black, //선택된 타일의 글자 색상
              selected: e == '서울', //선택 상태 조절 가능
              title: Text(
                e,
              ),
            ),
          ).toList(),
        ],
      ),
    );
  }
}
