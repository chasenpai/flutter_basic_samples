import 'package:fine_dust/component/category_card.dart';
import 'package:fine_dust/component/hourly_card.dart';
import 'package:fine_dust/component/main_app_bar.dart';
import 'package:fine_dust/component/main_drawer.dart';
import 'package:fine_dust/const/colors.dart';
import 'package:fine_dust/const/regions.dart';
import 'package:fine_dust/model/stat_model.dart';
import 'package:fine_dust/repository/stat_repository.dart';
import 'package:fine_dust/utils/data_utils.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  String region = regions[0];

  Future<Map<ItemCode, List<StatModel>>> fetchData() async {

    Map<ItemCode, List<StatModel>> stats = {};
    //다수의 비동기 요청 병렬로 처리
    List<Future> futures = [];
    for(ItemCode itemCode in ItemCode.values) {
      futures.add(
        StatRepository.fetchData(
        itemCode: itemCode
        ),
      );
    }
    //리스트 안에 들어있는 Future들의 작업이 모두 끝날 때 까지 기다림
    //리스트에 넣은 순서대로 리턴 값이 들어온다
    final results = await Future.wait(futures);
    for(int i = 0; i < results.length; i++) {
      final key = ItemCode.values[i];
      final value = results[i];
      stats.addAll({
        key: value,
      });
    }

    return stats;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      drawer: MainDrawer(
        onRegionTap: (String region) {
          setState(() {
            this.region = region;
          });
          Navigator.of(context).pop(); //drawer도 하나의 화면으로 인식하기 때문에 뒤로가기 가능
        },
        selectedRegion: region,
      ),
      body: FutureBuilder<Map<ItemCode, List<StatModel>>>(
        future: fetchData(),
        builder: (context, snapshot) {
          //오류
          if(snapshot.hasError) {
            return Center(
              child: Text('오류가 있습니다.',),
            );
          }
          //로딩 중
          if(!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          Map<ItemCode, List<StatModel>> stats = snapshot.data!;
          StatModel pm10RecentStat = stats[ItemCode.PM10]![0];
          final status = DataUtils.getStatusFromItemCodeAndValue(
            value: pm10RecentStat.seoul,
            itemCode: ItemCode.PM10,
          );
          return CustomScrollView(
            slivers: [
              MainAppBar(
                region: region,
                stat: pm10RecentStat,
                status: status,
              ),
              SliverToBoxAdapter( //Sliver안에 일반 위젯을 넣을 수 있음
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CategoryCard(),
                    const SizedBox(height: 16.0,),
                    HourlyCard(),
                  ],
                ),
              ),
            ],
          );
        }
      ),
    );
  }
}
