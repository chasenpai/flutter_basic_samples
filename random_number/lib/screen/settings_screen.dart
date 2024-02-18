import 'package:flutter/material.dart';
import 'package:random_number/constant/color.dart';

import '../component/number_row.dart';

class SettingsScreen extends StatefulWidget {
  final int maxNumber;
  const SettingsScreen({required this.maxNumber, Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  double maxNumber = 1000;

  @override
  void initState() {
    maxNumber = widget.maxNumber.toDouble(); //빌드가 되기전 값 지정
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PRIMARY_COLOR,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _BodyWidget(maxNumber: maxNumber),
              _FooterWidget(
                maxNumber: maxNumber,
                onSliderChanged: onSliderChanged,
                onButtonPressed: onButtonPressed,
              )
            ],
          ),
        ),
      )
    );
  }

  void onButtonPressed () {
    //뒤로가기 + 파라미터 넘기기
    Navigator.of(context).pop(maxNumber.toInt());
  }

  void onSliderChanged(double value) {
    setState(() {
      maxNumber = value;
    });
  }

}

class _BodyWidget extends StatelessWidget {
  final double maxNumber;
  const _BodyWidget({required this.maxNumber, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: NumberRow(number: maxNumber.toInt()),
    );
  }
}

class _FooterWidget extends StatelessWidget {

  final double maxNumber;
  final ValueChanged<double>? onSliderChanged;
  final VoidCallback onButtonPressed;

  const _FooterWidget(
        {
          required this.maxNumber,
          required this.onSliderChanged,
          required this.onButtonPressed,
          Key? key
        }
      ) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Slider(
          value: maxNumber, //이 값으로 다시 빌드
          min: 1000,
          max: 100000,
          onChanged: onSliderChanged,
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: RED_COLOR,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0)
              )
          ),
          onPressed: onButtonPressed,
          child: Text(
            '저장',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.w700,
            ),
          ),
        )
      ],
    );
  }
}


