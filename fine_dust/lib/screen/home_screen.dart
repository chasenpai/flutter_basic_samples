import 'package:dio/dio.dart';
import 'package:fine_dust/component/category_card.dart';
import 'package:fine_dust/component/hourly_card.dart';
import 'package:fine_dust/component/main_app_bar.dart';
import 'package:fine_dust/component/main_drawer.dart';
import 'package:fine_dust/const/colors.dart';
import 'package:fine_dust/const/data.dart';
import 'package:fine_dust/model/stat_model.dart';
import 'package:fine_dust/repository/stat_repository.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    final statModels = await StatRepository.fetchData();
    print(statModels);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      drawer: MainDrawer(),
      body: CustomScrollView(
        slivers: [
          MainAppBar(),
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
      ),
    );
  }
}
