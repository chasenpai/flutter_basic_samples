import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_call/const/agora.dart';

class CamScreen extends StatefulWidget {
  const CamScreen({super.key});

  @override
  State<CamScreen> createState() => _CamScreenState();
}

class _CamScreenState extends State<CamScreen> {

  //Agora
  RtcEngine? engine;
  //내 ID
  int? uid = 0;
  //상대방 ID
  int? otherUid;

  // @override
  // void dispose() async {
  //   if (engine != null) {
  //     await engine!.leaveChannel(
  //       options: LeaveChannelOptions(),
  //     );
  //     engine!.release();
  //   }
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text(
          '간단 영상 통화',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: FutureBuilder<bool>(
        future: init(),
        builder: (context, snapshot) {
          //권한이 없음
          if(snapshot.hasError){
            return Center(
              child: Text(
                snapshot.error.toString(),
              ),
            );
          }
          //아직 로딩 중
          if(!snapshot.hasData){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    renderMainView(),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        color: Colors.grey,
                        height: 160,
                        width: 120,
                        child: renderSubView(),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    if(engine != null){
                      await engine!.leaveChannel(); //채널 나가기
                      engine = null;
                    }
                    Navigator.of(context).pop();
                  },
                  child: Text('나가기'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      )
                  )
                ),
              )
            ],
          );
        }
      ),
    );
  }

  renderMainView() {
    if(uid == null) {
      return Center(
        child: Text('채널에 참여해주세요.'),
      );
    }else{
      return AgoraVideoView(
          controller: VideoViewController( //내 화면
            rtcEngine: engine!,
            canvas: VideoCanvas(
              uid: 0,
            ),
          ),
      );
    }
  }

  renderSubView() {
    if(otherUid == null) {
      return Center(
        child: Text('채널에 유저가 없습니다.'),
      );
    }else{
      return AgoraVideoView(
        controller: VideoViewController.remote( //상대방 화면
          rtcEngine: engine!,
          canvas: VideoCanvas(
              uid: otherUid
          ),
          connection: RtcConnection(
              channelId: CHANNEL_NAME,
          ),
        ),
      );
    }
  }

  //카메라, 마이크 권한 요청 - Permission Handler Plugin
  Future<bool> init() async {
    final response = await [Permission.camera, Permission.microphone].request();
    final cameraPermission = response[Permission.camera];
    final microPhonePermission = response[Permission.microphone];
    //denied - 권한 없음(물어보기 전)
    //granted - 권한 있음
    //restricted - 아이들 휴대폰에서 부모들의 어쩌고 저쩌고(ios만)
    //limited - 사용자가 몇가지 권한만 허가
    //permanentlyDenied - 권한을 주지 않음
    if(cameraPermission != PermissionStatus.granted || microPhonePermission != PermissionStatus.granted){
      throw '카메라 또는 마이크 권한이 없습니다.';
    }

    if(engine == null){
      engine = createAgoraRtcEngine(); //엔진 생성
      await engine!.initialize(
        RtcEngineContext( //앱 ID를 기반으로 초기화
          appId: APP_ID,
        ),
      );
      engine!.registerEventHandler(
        RtcEngineEventHandler(
          //내가 채널에 입장할 때
          //connection - 연결 정보
          //elapsed - 연결된 시간
          onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
             print('채널에 입장했습니다. uid: ${connection.localUid}');
             setState(() {
               uid = connection.localUid;
             });
          },
          //내가 채널에서 나갔을 때
          //stats - 내 통화에 대한 통계
          onLeaveChannel: (RtcConnection connection, RtcStats stats) {
             print('채널 퇴장');
             setState(() {
               uid == null;
             });
          },
          //상대방 유저가 들어왔을 때
          //remoteUid - 상대방 유저 아이디
          onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
             print('상대가 채널에 입장했습니다. other uid: ${remoteUid}');
             setState(() {
               otherUid = remoteUid;
             });
          },
          //상대방 유저가 나갔을 때
          onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
             print('상대가 채널에서 나갔습니다. other uid: ${remoteUid}');
             setState(() {
               otherUid = null;
             });
          },
        ),
      );
      await engine!.enableVideo(); //비디오 활성화
      await engine!.startPreview(); //영상 송출
      ChannelMediaOptions options = ChannelMediaOptions();
      await engine!.joinChannel(
          token: TEMP_TOKEN,
          channelId: CHANNEL_NAME,
          uid: 0,
          options: options
      );
    }
    return true;
  }
}
