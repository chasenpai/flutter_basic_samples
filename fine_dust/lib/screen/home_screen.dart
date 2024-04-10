import 'package:dio/dio.dart';
import 'package:fine_dust/container/category_card.dart';
import 'package:fine_dust/container/hourly_card.dart';
import 'package:fine_dust/component/main_app_bar.dart';
import 'package:fine_dust/component/main_drawer.dart';
import 'package:fine_dust/const/regions.dart';
import 'package:fine_dust/model/stat_and_status_model.dart';
import 'package:fine_dust/model/stat_model.dart';
import 'package:fine_dust/repository/stat_repository.dart';
import 'package:fine_dust/utils/data_utils.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  String region = regions[0];
  bool isExpanded = true;
  ScrollController scrollController = ScrollController();

  @override
  initState() {
    super.initState();
    scrollController.addListener(scrollListener);
    fetchData();
  }

  @override
  dispose() {
    scrollController.removeListener(scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchData() async {
    try{
      //중복 요청 제거
      final now = DateTime.now();
      final fetchTime = DateTime( //StatModel의 dataTime과 같음
        now.year,
        now.month,
        now.day,
        now.hour,
      );
      final box = Hive.box<StatModel>(ItemCode.PM10.name);
      //새로 설치 시 box안에 값이 하나도 없어서 .last 사용 시 NoElement 예외가 발생
      if(box.values.isNotEmpty && (box.values.last as StatModel).dataTime.isAtSameMomentAs(fetchTime)) {
        print('이미 최신 데이터가 있습니다.');
        return;
      }

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
        //ItemCode
        final key = ItemCode.values[i];
        //List<StatModel>
        final value = results[i];
        final box = Hive.box<StatModel>(key.name);
        for(StatModel stat in value) {
          //box안에서 dataTime이 절대로 중복될 수 없다
          box.put(stat.dataTime.toString(), stat);
        }
        final allKeys = box.keys.toList();
        //중복 데이터 제거
        if(allKeys.length > 24) {
          //start - 시작 index
          //end - 끝 index
          //['red','orange','yellow','green','blue']
          //.sublist(1, 3)
          //['orange, 'yellow']
          final deleteKeys = allKeys.sublist(0, allKeys.length - 24);
          box.deleteAll(deleteKeys);
        }
      }
    } on DioException catch(e) {
      //스낵바
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('인터넷 연결이 원활하지 않습니다.'))
      );
    }
  }

  scrollListener() {
    //offset - 제일 위에서부터 스크롤을 얼마나 했는지 알 수 있음
    //kToolbarHeight - 앱바의 높이
    bool isExpanded = scrollController.offset < 500 - kToolbarHeight;
    if(isExpanded != this.isExpanded) {
      setState(() {
        this.isExpanded = isExpanded;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box>(
      valueListenable: Hive.box<StatModel>(ItemCode.PM10.name).listenable(),
      builder: (context, box, widget) {
        if(box.values.isEmpty) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        //현재 box는 미세먼지
        final recentStat = box.values.toList().last as StatModel;
        final status = DataUtils.getStatusFromItemCodeAndValue(
          value: recentStat.getLevelFromRegion(region),
          itemCode: ItemCode.PM10,
        );
        return Scaffold(
          drawer: MainDrawer(
            darkColor: status.darkColor,
            lightColor: status.lightColor,
            onRegionTap: (String region) {
              setState(() {
                this.region = region;
              });
              Navigator.of(context).pop(); //drawer도 하나의 화면으로 인식하기 때문에 뒤로가기 가능
            },
            selectedRegion: region,
          ),
          body: Container(
            //Scaffold에 배경을 주지 않고 상태가 변경될 때 마다 배경 색이 바뀌도록
            color: status.primaryColor,
            child: RefreshIndicator( //당기면 새로 고침
              onRefresh: () async {
                await fetchData();
              },
              child: CustomScrollView(
                controller: scrollController, //컨트롤러를 넣어주고 작동시킬 수 있다
                slivers: [
                  MainAppBar(
                    isExpanded: isExpanded,
                    region: region,
                    stat: recentStat,
                    status: status,
                  ),
                  SliverToBoxAdapter( //Sliver안에 일반 위젯을 넣을 수 있음
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CategoryCard(
                          region: region,
                          darkColor: status.darkColor,
                          lightColor: status.lightColor,
                        ),
                        const SizedBox(height: 16.0,),
                        ...ItemCode.values.map((itemCode) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: HourlyCard(
                              region: region,
                              darkColor: status.darkColor,
                              lightColor: status.lightColor,
                              itemCode: itemCode,
                            ),
                          );
                        }),
                        const SizedBox(height: 32.0,),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
