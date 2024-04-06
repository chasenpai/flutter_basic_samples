import 'package:calendar/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatelessWidget {

  final DateTime? selectedDay;
  final DateTime focusedDay;
  final OnDaySelected onDaySelected;

  const Calendar({
    required this.selectedDay,
    required this.focusedDay,
    required this.onDaySelected,
    super.key
  });

  @override
  Widget build(BuildContext context) {

    final defaultBoxDeco = BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(8.0),
    );
    final defaultTextStyle = TextStyle(
      color: Colors.grey[600],
      fontWeight: FontWeight.w700,
    );

    return TableCalendar(
      locale: 'ko_KR', //다국어
      focusedDay: focusedDay, //지금 화면에서 보고있는 날짜
      firstDay: DateTime(1800), //선택 가능한 가장 첫번째 날짜
      lastDay: DateTime(3000), //선택 가능한 가장 미래의 날짜
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 16.0,
        )
      ),
      calendarStyle: CalendarStyle(
        isTodayHighlighted: false, //오늘 날짜 하이라이팅
        defaultDecoration: defaultBoxDeco, //평일
        weekendDecoration: defaultBoxDeco,
        selectedDecoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: PRIMARY_COLOR,
            width: 1.0
          ),
        ),
        defaultTextStyle: defaultTextStyle,
        weekendTextStyle: defaultTextStyle,
        selectedTextStyle: defaultTextStyle.copyWith(
          color: PRIMARY_COLOR,
        ),
        outsideDecoration: BoxDecoration(
          shape: BoxShape.rectangle, //기본이 원형이기 때문에 애니메이션 오류가 발생한다
        ),
      ),
      onDaySelected: onDaySelected, //날짜 선태
      selectedDayPredicate: (DateTime date) { //특정 날짜가 선택된 날짜로 지정되어야 하는지 - 선택 날짜 표시
        if(selectedDay == null) {
          return false;
        }
        return date.year == selectedDay!.year &&
               date.month == selectedDay!.month &&
               date.day == selectedDay!.day ? true : false;
      },
    );
  }
}
