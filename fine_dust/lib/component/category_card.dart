import 'package:fine_dust/component/card_title.dart';
import 'package:fine_dust/component/main_card.dart';
import 'package:fine_dust/component/main_stat.dart';
import 'package:fine_dust/const/colors.dart';
import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: MainCard(
        child: LayoutBuilder( //너비의 공간 전체 크기를 찾고 싶은 위젯 바로 위에다 쓰는게 중요
          //constraint - LayoutBuilder가 차지하고 있는 공간 기준으로 최대 높이 너비 최소 높이 너비 제공
          builder: (context, constraint) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CardTitle(title: '종류별 통계',),
                Expanded( //스크롤 가능한 위젯은 Column 안에서 쓸 때 무조건 Expanded
                  child: ListView(
                    //스크롤 방향 지정
                    scrollDirection: Axis.horizontal,
                    physics: PageScrollPhysics(), //약간만 스크롤해도 다음 페이지로
                    children: List.generate(20, (index) =>
                      MainStat(
                          category: '미세먼지$index',
                          imgPath: 'asset/img/best.png',
                          level: '최고',
                          stat: '0㎍/㎥',
                          width: constraint.maxWidth / 3,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        ),
      ),
    );
  }
}
