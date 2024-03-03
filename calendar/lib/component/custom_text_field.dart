import 'package:calendar/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {

  final String label;
  final bool isTime;
  final FormFieldSetter<String> onSaved;
  final String initialValue;

  const CustomTextField({
    required this.label,
    required this.isTime,
    required this.onSaved,
    required this.initialValue,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: PRIMARY_COLOR,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 4.0,),
        if(isTime) renderTextField(),
        if(!isTime)
          Expanded(
            child: renderTextField(),
          ),
      ],
    );
  }

  Widget renderTextField() {
    return TextFormField( //Form
      //에러가 있으면 에러를 String으로 리턴
      //에러가 없으면 null 리턴
      //폼 아래에 있는 모든 텍스트 폼필드에 대해 validator 실행
      validator: (String? value) {
        if(value == null || value.isEmpty) {
          return '값을 입력해주세요.';
        }
        if(isTime) {
          int time = int.parse(value);
          if(time < 0){
            return '0 이상의 숫자를 입력해주세요.';
          }
          if(time > 24){
            return '24 이하의 숫자를 입력해주세요.';
          }
        }else {
          if(value.length > 500) {
            return '500자 이하의 글자를 입력해주세요.';
          }
        }
        return null;
      },
      //상위 폼에서 save 호출 시 하위 모든 폼필드에 대해 실행
      onSaved: onSaved,
      cursorColor: Colors.grey,
      expands: !isTime, //부모의 높이 만큼 늘려줌
      maxLines: isTime ? 1 : null, //줄의 갯수 - null 무한 줄바꿈
      // maxLength: 500,
      //키보드 타입 변경 -> 입력 타입을 제한하는 것은 아님
      keyboardType: isTime ? TextInputType.number : TextInputType.multiline,
      initialValue: initialValue, //필드 채우기
      inputFormatters: isTime ? [
        FilteringTextInputFormatter.digitsOnly, //숫자만 입력 받을 수 있음
      ] : [],
      decoration: InputDecoration(
        border: InputBorder.none,
        filled: true,
        fillColor: Colors.grey[300],
        suffixText: isTime ? '시' : null, //접미사
      ),
    );
  }
}
