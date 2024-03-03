import 'package:calendar/component/custom_text_field.dart';
import 'package:calendar/const/colors.dart';
import 'package:calendar/database/drift_database.dart';
import 'package:drift/drift.dart' show LazyDatabase, Value; //특정 클래스만 불러오기
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ScheduleBottomSheet extends StatefulWidget {

  final DateTime selectedDate;
  final int? scheduleId;

  const ScheduleBottomSheet({
    required this.selectedDate,
    this.scheduleId,
    super.key
  });

  @override
  State<ScheduleBottomSheet> createState() => _ScheduleBottomSheetState();
}

class _ScheduleBottomSheetState extends State<ScheduleBottomSheet> {

  final GlobalKey<FormState> formKey = GlobalKey(); //일종의 컨트롤러

  int? startTime;
  int? endTime;
  String? content;
  int? selectedColorId;

  @override
  Widget build(BuildContext context) {

    //시스템 만큼 가려진(키보드) 사이즈를 가져온다
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return GestureDetector(
      onTap: () {
        //FocusNode() - 현재 포커스 제거 -> 키보드 닫힘
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: FutureBuilder<Schedule>(
        future: widget.scheduleId == null ? null :
          GetIt.I<LocalDatabase>().findScheduleById(widget.scheduleId!),
        builder: (context, snapshot) {
          if(snapshot.hasError) {
            return Center(
              child: Text('스케줄을 불러올 수 없습니다.'),
            );
          }
          //처음 실행됐고, 로딩중일 때
          if(snapshot.connectionState != ConnectionState.none && !snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          //Future가 실행되고 값이 있는데 단 한번도 startTime이 셋팅되지 않았을 때
          if(snapshot.hasData && startTime == null) {
            startTime = snapshot.data!.startTime;
            endTime = snapshot.data!.endTime;
            content = snapshot.data!.content;
            selectedColorId = snapshot.data!.colorId;
          }
          return SafeArea(
            child: Container(
              height: MediaQuery.of(context).size.height / 2 + bottomInset,
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.only(bottom: bottomInset), //키보드 높이 만큼 패딩
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 8.0,
                    right: 8.0,
                    top: 16.0,
                  ),
                  child: Form( //폼으로 관리하고 싶은 텍스트 필드를 묶어준다
                    key: formKey,
                    autovalidateMode: AutovalidateMode.always, //라이브로 검
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _Time(
                          onStartSaved: (String? value) {
                            startTime = int.parse(value!);
                          },
                          onEndSaved: (String? value) {
                            endTime = int.parse(value!);
                          },
                          startInitialValue: startTime?.toString() ?? '',
                          endInitialValue: endTime?.toString() ?? '',
                        ),
                        SizedBox(height: 16.0,),
                        _Content(
                          onSaved: (String? value) {
                            content = value;
                          },
                          initialValue: content ?? '',
                        ),
                        SizedBox(height: 16.0,),
                        FutureBuilder<List<CategoryColor>>(
                          //Get It 플러그인을 사용한 의존성 주입
                          future: GetIt.I<LocalDatabase>().getCategoryColors(),
                          builder: (context, snapshot) {
                            if(snapshot.hasData && selectedColorId == null && snapshot.data!.isNotEmpty) {
                              //선택된 색상이 없을 때 디폴트 색상 선택
                              selectedColorId = snapshot.data![0].id;
                            }
                            return _ColorPicker(
                              colors: snapshot.hasData ? snapshot.data! : [],
                              //절대로 null이 될 수 없을 때만 느낌표를 붙여야 한다
                              //Null check operator used on a null value
                              //위의 snapshot 조건이 하나도 맞지 않을 땐 null이 될 수 있다 !를 붙이면 에러가 날 수 있음
                              selectedColorId: selectedColorId,
                              colorIdSetter: (int id) {
                                setState(() {
                                  selectedColorId = id;
                                });
                              },
                            );
                          }
                        ),
                        SizedBox(height: 8.0,),
                        _SaveBtn(onPressed: onSavePressed,),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      ),
    );
  }

  void onSavePressed() async {
    //formKey는 생성되었지만 form 위젯과 결합하지 않았을 때
    if(formKey.currentState == null) {
      return;
    }
    if(formKey.currentState!.validate()) {
      formKey.currentState!.save();
      if(widget.scheduleId == null) {
        await GetIt.I<LocalDatabase>().createSchedule(
            SchedulesCompanion(
              content: Value(content!),
              date: Value(widget.selectedDate),
              startTime: Value(startTime!),
              endTime: Value(endTime!),
              colorId: Value(selectedColorId!),
            ),
        );
      }else{
        await GetIt.I<LocalDatabase>().updateScheduleById(
          widget.scheduleId!,
          SchedulesCompanion(
            content: Value(content!),
            date: Value(widget.selectedDate),
            startTime: Value(startTime!),
            endTime: Value(endTime!),
            colorId: Value(selectedColorId!),
          ),
        );
      }
      Navigator.of(context).pop(); //바텀시트 닫기
    }else{
      print('에러 발생');
    }
  }
}

class _Time extends StatelessWidget {

  final FormFieldSetter<String> onStartSaved;
  final FormFieldSetter<String> onEndSaved;
  final String startInitialValue;
  final String endInitialValue;

  const _Time({
    required this.onStartSaved,
    required this.onEndSaved,
    required this.startInitialValue,
    required this.endInitialValue,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: CustomTextField(
              label: '시작 시간',
              isTime: true,
              onSaved: onStartSaved,
              initialValue: startInitialValue,
            )
        ),
        SizedBox(width: 16.0,),
        Expanded(
            child: CustomTextField(
              label: '마감 시간',
              isTime: true,
              onSaved: onEndSaved,
              initialValue: endInitialValue,
            )
        ),
      ],
    );
  }
}

class _Content extends StatelessWidget {

  final FormFieldSetter<String> onSaved;
  final String initialValue;

  const _Content({
    required this.onSaved,
    required this.initialValue,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CustomTextField(
        label: '내용',
        isTime: false,
        onSaved: onSaved,
        initialValue: initialValue,
      ),
    );
  }
}

typedef ColorIdSetter = void Function(int id);

class _ColorPicker extends StatelessWidget {

  final List<CategoryColor> colors;
  final int? selectedColorId;
  final ColorIdSetter colorIdSetter;

  const _ColorPicker({
    required this.colors,
    required this.selectedColorId,
    required this.colorIdSetter,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Wrap( //자동 줄바꿈
      spacing: 8.0, //각각 자식의 간격
      runSpacing: 10.0, //위아래(로우)별 간격
      children: colors.map((color) => GestureDetector(
        onTap: () {
          colorIdSetter(color.id);
        },
        child: renderColor(
            color,
            selectedColorId == color.id,
          ),
      )
      ).toList(),
    );
  }

  Widget renderColor(CategoryColor color, bool isSelected) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color(
            int.parse('FF${color.hexCode}', radix: 16) //16진수 변경
        ),
        border: isSelected ? Border.all(
          color: Colors.black,
          width: 4.0,
        ) : null,
      ),
      width: 32.0,
      height: 32.0,
    );
  }
}

class _SaveBtn extends StatelessWidget {

  final VoidCallback onPressed;

  const _SaveBtn({
    required this.onPressed,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: PRIMARY_COLOR,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
            ),
            child: Text(
              '저장',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}



