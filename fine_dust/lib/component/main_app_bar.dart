import 'package:fine_dust/const/colors.dart';
import 'package:fine_dust/model/stat_model.dart';
import 'package:fine_dust/model/status_dat.dart';
import 'package:fine_dust/utils/data_utils.dart';
import 'package:flutter/material.dart';

class MainAppBar extends StatelessWidget {

  final StatusModel status; //StatModel을 기준으로 단계를 나누는 것을 정의
  final StatModel stat;

  const MainAppBar({
    super.key,
    required this.status,
    required this.stat
  });

  @override
  Widget build(BuildContext context) {

    final textStyle = TextStyle(
        color: Colors.white,
        fontSize: 30.0
    );

    return SliverAppBar(
      backgroundColor: status.primaryColor,
      expandedHeight: 500,
      flexibleSpace: FlexibleSpaceBar(
        background: SafeArea(
          child: Container(
            margin: EdgeInsets.only(top: kToolbarHeight), //앱바의 높이를 받을 수 있음
            child: Column(
              children: [
                Text(
                  '서울',
                  style: textStyle.copyWith(
                    fontSize: 40.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  DataUtils.getTimeFromDateTime(dateTime: stat.dataTime),
                  style: textStyle.copyWith(
                    fontSize: 20.0,
                  ),
                ),
                const SizedBox(height: 20.0,),
                Image.asset(
                  status.imagePath,
                  width: MediaQuery.of(context).size.width / 2,
                ),
                const SizedBox(height: 20.0,),
                Text(
                  status.label,
                  style: textStyle.copyWith(
                    fontSize: 40.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8.0,),
                Text(
                  status.comment,
                  style: textStyle.copyWith(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }



}



