import 'package:fine_dust/const/regions.dart';
import 'package:flutter/material.dart';

typedef OnRegionTap = void Function(String region);

class MainDrawer extends StatelessWidget {

  final OnRegionTap onRegionTap;
  final String selectedRegion;
  final Color darkColor;
  final Color lightColor;

  const MainDrawer({
    super.key,
    required this.onRegionTap,
    required this.selectedRegion,
    required this.darkColor,
    required this.lightColor,
  });

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
                onRegionTap(e);
              },
              tileColor: Colors.white,
              selectedTileColor: lightColor, //선택된 타일 색상
              selectedColor: Colors.black, //선택된 타일의 글자 색상
              selected: e == selectedRegion, //선택 상태 조절 가능
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
