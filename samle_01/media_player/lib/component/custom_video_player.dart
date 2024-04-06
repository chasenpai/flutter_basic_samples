import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class CustomVideoPlayer extends StatefulWidget {

  final XFile video;
  final VoidCallback onNewVideoPressed;

  const CustomVideoPlayer({
    required this.video,
    required this.onNewVideoPressed,
    super.key
  });

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {

  VideoPlayerController? videoController;
  Duration currentPosition = Duration();
  bool showControllers = false;

  @override
  void initState() { //iniState는 async로 만들 수 없다
    super.initState();
    initializeController();
  }

  //부모 위젯이 다시 빌드될 때 실행
  @override
  void didUpdateWidget(covariant CustomVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(oldWidget.video.path != widget.video.path){
      initializeController();
    }
  }

  initializeController() async {
    currentPosition = Duration(); //동영상이 선택될 때 값 리셋
    //asset - asset 폴더
    //network - 스트리밍(url)
    videoController = VideoPlayerController.file(
        File(widget.video.path) //XFile을 플러터의 File로 변환
    );
    await videoController!.initialize();
    
    videoController!.addListener(() { //비디오 컨트롤러 값이 변경될 때 마다 실행
      final currentPosition = videoController!.value.position;
      setState(() {
        this.currentPosition = currentPosition;
      });
    });

    setState(() { //비디오 컨트롤러 생성을 했으니 새로 빌드
      
    });
  }

  @override
  Widget build(BuildContext context) {
    if(videoController == null) {
      return CircularProgressIndicator(); //로딩바
    }
    return AspectRatio(
      aspectRatio: videoController!.value.aspectRatio, //동영상의 원래 비율
        child: GestureDetector( //탭하면 컨트롤이 사라지고 나타나게
          onTap: () {
            setState(() {
              showControllers = !showControllers;
            });
          },
          child: Stack( //위젯 위에 위젯 쌓기
            children: [
              VideoPlayer(videoController!),
              if(showControllers)
                _Controls(
                  onReversePressed: onReversePressed,
                  onPlayPressed: onPlayPressed,
                  onForwardPressed: onForwardPressed,
                  isPlaying: videoController!.value.isPlaying,
                ),
              if(showControllers)
                _NewVideo(
                  onPressed: widget.onNewVideoPressed,
                ),
              _SliderBottom(
                currentPosition: currentPosition,
                maxPosition: videoController!.value.duration,
                onChanged: onSliderChanged,
              ),
            ],
          ),
        ),
    );
  }

  void onReversePressed() {
    final currentPosition = videoController!.value.position; //Duration
    Duration position = Duration(); //기본 0초
    if(currentPosition.inSeconds > 3) {
      position = currentPosition - Duration(seconds: 3);
    }
    videoController!.seekTo(position);
  }

  void onPlayPressed() {
    setState(() {
      if(videoController!.value.isPlaying) { //실행 중인지
        videoController!.pause();
      }else{
        videoController!.play();
      }
    });
  }

  void onForwardPressed() {
    final maxPosition = videoController!.value.duration; //전체 길이
    final currentPosition = videoController!.value.position; //Duration
    Duration position = maxPosition; //기본 0초
    if((currentPosition - Duration(seconds: 3)).inSeconds < currentPosition.inSeconds) {
      position = currentPosition + Duration(seconds: 3);
    }
    videoController!.seekTo(position);
  }

  void onSliderChanged(double value) {
    videoController!.seekTo(
      Duration(seconds: value.toInt()),
    );
  }

}

class _Controls extends StatelessWidget {

  final VoidCallback onReversePressed;
  final VoidCallback onPlayPressed;
  final VoidCallback onForwardPressed;
  final bool isPlaying;

  const _Controls({
    required this.onReversePressed,
    required this.onPlayPressed,
    required this. onForwardPressed,
    required this. isPlaying,
    key
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.5), //투명도 추가
      height: MediaQuery.of(context).size.height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          renderIconButton(
              onPressed: onReversePressed,
              iconData: Icons.rotate_left,
          ),
          renderIconButton(
              onPressed: onPlayPressed,
              iconData: isPlaying ? Icons.pause : Icons.play_arrow,
          ),
          renderIconButton(
              onPressed: onForwardPressed,
              iconData: Icons.rotate_right,
          ),
        ],
      ),
    );
  }

  Widget renderIconButton({
    required VoidCallback onPressed,
    required IconData iconData
  }){
    return IconButton(
        onPressed: onPressed,
        iconSize: 30.0,
        color: Colors.white,
        icon: Icon(
          iconData,
        )
    );
  }
}

class _NewVideo extends StatelessWidget {

  final VoidCallback onPressed;
  const _NewVideo({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned( //Positioned - 위치를 정할 수 있는 위젯
      right: 0, //오른쪽에서 0픽셀 만큼
      child: IconButton(
          onPressed: onPressed,
          color: Colors.white,
          iconSize: 30.0,
          icon: Icon(Icons.photo_camera_back,)
      ),
    );
  }
}

class _SliderBottom extends StatelessWidget {

  final Duration currentPosition;
  final Duration maxPosition;
  final ValueChanged<double> onChanged;

  const _SliderBottom({
    required this.currentPosition,
    required this.maxPosition,
    required this.onChanged,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      right: 0,
      left: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
            children: [
              Text(
                //padLeft - 글자의 패딩, 최소한으로 보여줄 값 - 최소 2개의 글자, 모자라면 0으로 출력
                '${currentPosition.inMinutes}:${(currentPosition.inSeconds % 60).toString().padLeft(2, '0')}',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              Expanded( //남은 공간 전부차지
                child: Slider(
                  max: maxPosition.inSeconds.toDouble(),
                  min: 0,
                  value: currentPosition.inSeconds.toDouble(),
                  onChanged: onChanged,
                ),
              ),
              Text(
                '${maxPosition.inMinutes}:${(maxPosition.inSeconds % 60).toString().padLeft(2, '0')}',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ]
        ),
      ),
    );
  }
}

