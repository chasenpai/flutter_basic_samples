import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  bool choolCheckDone = false;
  GoogleMapController? mapController;

  //지도를 띄울 위치
  static final LatLng companyLatLng = LatLng(
    37.5233273, //위도
    126.921252 //경도
  );
  //지도의 확대 정도
  static final CameraPosition initialPosition = CameraPosition(
    target: companyLatLng,
    zoom: 15,
  );
  //위치 원을 생성
  static final double okDistance = 100;
  static final Circle withinDistanceCircle = Circle(
    circleId: CircleId('withinDistanceCircle'), //여러 개의 그렸을 때 식별하기 위함
    center: companyLatLng,
    fillColor: Colors.blue.withOpacity(0.5), //원 내부 색
    radius: okDistance, //위치 반경
    strokeColor: Colors.blue,//둘레 색
    strokeWidth: 1, //둘레 두께
  );
  static final Circle notWithinDistanceCircle = Circle(
    circleId: CircleId('notWithinDistanceCircle'),
    center: companyLatLng,
    fillColor: Colors.red.withOpacity(0.5),
    radius: okDistance,
    strokeColor: Colors.red,
    strokeWidth: 1,
  );
  static final Circle checkDoneCircle = Circle(
    circleId: CircleId('checkDoneCircle'),
    center: companyLatLng,
    fillColor: Colors.green.withOpacity(0.5),
    radius: okDistance,
    strokeColor: Colors.green,
    strokeWidth: 1,
  );
  //마커 생성
  static final Marker marker = Marker(
    markerId: MarkerId('marker'),
    position: companyLatLng,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: renderAppBar(),
      //FutureBuilder - Future 함수의 상태가 변경될 때 마다 재실행 해준다
      body: FutureBuilder<String>( //snapshot의 타입을 제네릭으로
        builder: (BuildContext context, AsyncSnapshot snapshot) { //snapshot - 상태를 알 수 있음

          if(snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if(snapshot.data == '위치 권한을 허가 되었습니다.') {
            //StreamBuilder - 데이터를 지속적으로 받아서 빌드
            return StreamBuilder<Position>(
              stream: Geolocator.getPositionStream(), //yield - 위치가 변경될 때
              builder: (context, snapshot) {

                bool isWithinRange = false;
                if(snapshot.hasData) { //데이터가 있으면 true 리턴
                  final start = snapshot.data!;
                  final end = companyLatLng;
                  final distance = Geolocator.distanceBetween(
                      start.latitude,
                      start.longitude,
                      end.latitude,
                      end.longitude,
                  );
                  if(distance < okDistance) { //반경 내에 있다면
                    isWithinRange = true;
                  }
                }

                return Column(
                  children: [
                    _CustomGoogleMap(
                      initialPosition: initialPosition,
                      //좋지 않은 습관
                      circle: choolCheckDone ? checkDoneCircle :
                              isWithinRange ? withinDistanceCircle : notWithinDistanceCircle,
                      marker: marker,
                      onMapCreated: onMapCreated,
                    ),
                    _ChoolCheckButton(
                      isWithinRange: isWithinRange,
                      onPressed: onChoolCheckPressed,
                      choolCheckDone: choolCheckDone,
                    ),
                  ],
                );
              }
            );
          }
          return Center(
            child: Text(snapshot.data),
          );
        }, future: checkPermission(),
      )
    );
  }

  Future<String> checkPermission() async {
    //앱과 상관이 없고 기기별로 위치 서비스에 대한 권한이 있는지 없는지
    final isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if(!isLocationEnabled) {
      return '위치 서비스를 활성화해 주세요.';
    }

    //현재 지금 앱이 가지고있는 위치 서비스에 대한 권한
    //denied - 처음 앱을 실행했을 때(다시 앱에서 요청 가능)
    //deniedForever - 요청이 떴을 때 허용을 안함(다시 앱에서 권한 요청 불가능)
    //whileInUse - 앱을 사용하는 동안
    //always - 항상
    //unableToDetermine - 알 수 없음(휴대폰은 이 상태가 없음)
    LocationPermission checkedPermission = await Geolocator.checkPermission();

    if(checkedPermission == LocationPermission.denied) {
      checkedPermission = await Geolocator.requestPermission(); //요청을 띄움
      if(checkedPermission == LocationPermission.denied) {
        return '위치 권한을 허가해 주세요.';
      }
    }

    if(checkedPermission == LocationPermission.deniedForever) {
      return '앱의 위치 권한을 설정에서 허가해 주세요.';
    }

    return '위치 권한을 허가 되었습니다.';
  }

  onChoolCheckPressed() async {
    final result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        //간단한 Material 다이알로그
        return AlertDialog(
          title: Text('출근하기'),
          content: Text('출근을 하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); //팝 - 다이알로그도 하나의 스크린이라 생각하면 된다
              },
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text('출근'),
            ),
          ],
        );
      }
    );
    if(result){
      setState(() {
        choolCheckDone = true;
      });
    }
  }

  //위치로 이동
  onMapCreated(GoogleMapController controller) {
    //컨트롤러의 값에 따라 화면 UI를 변경해야 한다면 setStatus
    mapController = controller;
  }

  AppBar renderAppBar() {
    return AppBar(
      title: Text(
        '출근하기 싫어',
        style: TextStyle(
            color: Colors.blue[500],
            fontWeight: FontWeight.w700
        ),
      ),
      backgroundColor: Colors.white,
      actions: [
        IconButton(
          onPressed: () async {
            if(mapController == null) {
              return;
            }
            final location = await Geolocator.getCurrentPosition(); //한번만
            mapController!.animateCamera(CameraUpdate.newLatLng(
                LatLng(
                  location.latitude,
                  location.longitude
                )
            ));
          },
          color: Colors.blue,
          icon: Icon(Icons.my_location),
        )
      ],
    );
  }
}

class _CustomGoogleMap extends StatelessWidget {

  final CameraPosition initialPosition;
  final Circle circle;
  final Marker marker;
  final MapCreatedCallback onMapCreated;

  const _CustomGoogleMap({
    required this.initialPosition,
    required this.circle,
    required this.marker,
    required this.onMapCreated,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: initialPosition,
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        circles: Set.from([circle]),
        markers: Set.from([marker]),
        onMapCreated: onMapCreated, //구글맵 컨트롤러를 받고 함수 실행
      ),
    );
  }
}

class _ChoolCheckButton extends StatelessWidget {

  final bool isWithinRange;
  final VoidCallback onPressed;
  final bool choolCheckDone;
  const _ChoolCheckButton({
    required this.isWithinRange,
    required this.onPressed,
    required this.choolCheckDone,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.timelapse_outlined,
              size: 50.0,
              color: choolCheckDone ? Colors.green : isWithinRange ? Colors.blue : Colors.red,
            ),
            const SizedBox(height: 20.0,),
            if(!choolCheckDone && isWithinRange)
              TextButton(
                onPressed: onPressed,
                child: Text('출근하기'),
              ),
          ],
        ),
    );
  }
}


