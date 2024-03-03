import 'package:calendar/component/schedule_card.dart';
import 'package:calendar/const/colors.dart';
import 'package:calendar/database/drift_database.dart';
import 'package:calendar/model/schedule_with_color.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../component/calendar.dart';
import '../component/schedule_bottom_sheet.dart';
import '../component/today_banner.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  DateTime selectedDay = DateTime.utc( //UTC 기준 시간을 넣어야 시차에 따른 오류 발생을 방지할 수 있음
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  DateTime focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: renderFloatingActionBtn(),
      body: SafeArea(
        child: Column(
          children: [
            Calendar(
              selectedDay: selectedDay,
              focusedDay: focusedDay,
              onDaySelected: onDaySelected,
            ),
            SizedBox(height: 8.0,),
            TodayBanner(
              selectedDay: selectedDay,
            ),
            SizedBox(height: 8.0,),
            _ScheduleList(
              seletedDate: selectedDay,
            ),
          ],
        ),
      )
    );
  }

  onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      this.selectedDay = selectedDay;
      this.focusedDay = selectedDay;
    });
  }

  //플로팅 버튼
  FloatingActionButton renderFloatingActionBtn() {
    return FloatingActionButton(
      onPressed: () {
        //Bottom Sheet - 밑에서 올라오는 머터리얼 모달
        showModalBottomSheet(
          context: context,
          isScrollControlled: true, //기본값으로 최대 화면의 반만큼 차지
          builder: (_) {
            return ScheduleBottomSheet(
              selectedDate: selectedDay,
            );
          }
        );
      },
      backgroundColor: PRIMARY_COLOR,
      child: Icon(
        Icons.add,
      ),
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(8.0),
      // ),
    );
  }

}

class _ScheduleList extends StatelessWidget {

  final DateTime seletedDate;

  const _ScheduleList({
    required this.seletedDate,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        //ListView
        child: StreamBuilder<List<ScheduleWithColor>>(
          stream: GetIt.I<LocalDatabase>().watchSchedules(seletedDate),
          builder: (context, snapshot) {
            if(!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if(snapshot.hasData && snapshot.data!.isEmpty) {
              return Center(
                child: Text('스케줄이 없습니다.'),
              );
            }
            return ListView.separated(
                itemCount: snapshot.data!.length, //갯수만큼 화면에 한번에 렌더링 되는게 아니고 필요한 현재 보이는 만큼 실행
                separatorBuilder: (context, index) { //각각의 위젯들 사이에 그려질 위젯
                  return SizedBox(height: 8.0,);
                },
                itemBuilder: (context, index) { //위젯이 그려질 때 마다 빌더가 실행
                  final scheduleWithColor = snapshot.data![index];
                  //Dismissible - 위젯을 스와이프해서 삭제할 수 있는 액션
                  return Dismissible(
                    key: ObjectKey(scheduleWithColor.schedule.id), //각자 유니크한 키를 넣어줘야 한다
                    direction: DismissDirection.endToStart, //스와이프 방향 지정
                    onDismissed: (DismissDirection direction) {
                      GetIt.I<LocalDatabase>().removeScheduleById(scheduleWithColor.schedule.id);
                    },
                    child: GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (_) {
                            return ScheduleBottomSheet(
                              selectedDate: seletedDate,
                              scheduleId: scheduleWithColor.schedule.id,
                            );
                          }
                        );
                      },
                      child: ScheduleCard(
                        startTime: scheduleWithColor.schedule.startTime,
                        endTime: scheduleWithColor.schedule.endTime,
                        content: scheduleWithColor.schedule.content,
                        color: Color(int.parse('FF${scheduleWithColor.categoryColor.hexCode}', radix: 16),),
                      ),
                    ),
                  );
                }
            );
          }
        ),
      ),
    );
  }
}

