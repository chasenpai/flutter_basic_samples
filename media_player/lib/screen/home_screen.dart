import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../component/custom_video_player.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  //ImagePicker가 제공하는 클래스로, 모든 이미지와 비디오를 리턴받을 수 있음
  XFile? video;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //조건에 따라 위젯을 렌더링할 수 있다
      body: video == null ? renderEmpty() : renderVideo(),
    );
  }

  Widget renderEmpty() {
    return Container(
      //Stateful 위젯은 언제 어디서나 context를 가져올 수 있다
      width: MediaQuery.of(context).size.width, //화면 전체 차지
      decoration: getBoxDecoration(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _Logo(onTap: onNewVideoPressed,),
          SizedBox(height: 30.0), //Padding 대신 사용하기 안성맞춤
          _AppName(),
        ],
      ),
    );
  }

  Widget renderVideo() {
    return Center(
      child: CustomVideoPlayer(
        video: video!,
        onNewVideoPressed: onNewVideoPressed,
      ),
    );
  }

  void onNewVideoPressed() async {
    //ImagePicker plugin
    final video = await ImagePicker().pickVideo(
      //camera - 카메라가 열리고 찍은 영상이 바로 선택
      //gallery - 갤러리에서 영상을 선택
      source: ImageSource.gallery,
    );
    if(video != null) {
      setState(() {
        this.video = video;
      });
    }
  }

  BoxDecoration getBoxDecoration() {
    return BoxDecoration( //BoxDecoration 안에 배경색을 넣는게 정석
      gradient: LinearGradient( //시작부터 끝지점까지 색이 천천히 점차 바뀜
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF2A3A7C), //begin 색상
          Color(0xFF000118), //end 색상
        ],
      ),
    );
  }
}

class _Logo extends StatelessWidget {

  final VoidCallback onTap;
  const _Logo({required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //child 위젯을 누르면 실행
      onTap: onTap,
      child: Image.asset('asset/image/logo.png')
    );
  }
}

class _AppName extends StatelessWidget {

  //중복되는 스타일을 변수로
  const _AppName({super.key});

  @override
  Widget build(BuildContext context) {

    final textStyle = TextStyle(
      color: Colors.white,
      fontSize: 30.0,
      fontWeight: FontWeight.w300,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'VIDEO',
          style: textStyle,
        ),
        Text(
          'PLAYER',
          //이미 들어간 스타일은 유지하고 속성을 추가
          style: textStyle.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}


