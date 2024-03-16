import 'package:fine_dust/component/category_card.dart';
import 'package:fine_dust/component/hourly_card.dart';
import 'package:fine_dust/component/main_app_bar.dart';
import 'package:fine_dust/component/main_drawer.dart';
import 'package:fine_dust/const/colors.dart';
import 'package:fine_dust/const/status_level.dart';
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

  Future<List<StatModel>> fetchData() async {
    final statModels = await StatRepository.fetchData();
    return statModels;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      drawer: MainDrawer(),
      body: FutureBuilder<List<StatModel>>(
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
          List<StatModel> stats = snapshot.data!;
          StatModel recentStat = stats[0];
          final status = DataUtils.getStatusFromItemCodeAndValue(
            value: recentStat.seoul,
            itemCode: ItemCode.PM10,
          );
          return CustomScrollView(
            slivers: [
              MainAppBar(
                stat: recentStat,
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
