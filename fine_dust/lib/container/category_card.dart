import 'package:fine_dust/component/card_title.dart';
import 'package:fine_dust/component/main_card.dart';
import 'package:fine_dust/component/main_stat.dart';
import 'package:fine_dust/model/stat_model.dart';
import 'package:fine_dust/utils/data_utils.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CategoryCard extends StatelessWidget {

  final Color darkColor;
  final Color lightColor;
  final String region;

  const CategoryCard({
    super.key,
    required this.region,
    required this.darkColor,
    required this.lightColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: MainCard(
        backgroundColor: lightColor,
        child: LayoutBuilder( //너비의 공간 전체 크기를 찾고 싶은 위젯 바로 위에다 쓰는게 중요
          //constraint - LayoutBuilder가 차지하고 있는 공간 기준으로 최대 높이 너비 최소 높이 너비 제공
          builder: (context, constraint) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CardTitle(
                  title: '종류별 통계',
                  backgroundColor: darkColor,
                ),
                Expanded( //스크롤 가능한 위젯은 Column 안에서 쓸 때 무조건 Expanded
                  child: ListView(
                    //스크롤 방향 지정
                    scrollDirection: Axis.horizontal,
                    physics: PageScrollPhysics(), //약간만 스크롤해도 다음 페이지로
                    children: ItemCode.values.map((ItemCode itemCode) =>
                      //ValueListenableBuilder가 감싸고 있는 부분만 렌더링이 되기 때문에 효율적이게 된다
                      //기존에 상위에서 상태를 한번에 관리할 땐 화면 전체가 다시 렌더링 됐었다
                      ValueListenableBuilder<Box>(
                        valueListenable: Hive.box<StatModel>(itemCode.name).listenable(),
                        //각각 ItemCode에 해당하는 box가 들어온다
                        builder: (context, box, widget) {
                          final stat = (box.values.last as StatModel);
                          final status = DataUtils.getStatusFromItemCodeAndValue(
                            value: stat.getLevelFromRegion(region),
                            itemCode: itemCode
                          );
                          return MainStat(
                            category: DataUtils.getItemCodeKrString(itemCode: itemCode),
                            imgPath: status.imagePath,
                            level: status.label,
                            stat: '${stat.getLevelFromRegion(region)}'
                                '${DataUtils.getUnitFromItemCode(itemCode: itemCode)}',
                            width: constraint.maxWidth / 3,
                          );
                        }
                      )
                    ).toList(),
                    // List.generate(20, (index) =>
                    //   MainStat(
                    //       category: '미세먼지$index',
                    //       imgPath: 'asset/img/best.png',
                    //       level: '최고',
                    //       stat: '0㎍/㎥',
                    //       width: constraint.maxWidth / 3,
                    //   ),
                    // ),
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
