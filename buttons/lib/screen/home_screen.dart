import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[300],
        title: Text('Buttons'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //ButtonStyle 사용
            ElevatedButton(
                onPressed: (){}, //이게 null 이면 아무런 효과도 안나옴(비활성화 상태)
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all( //일관되게 적용
                    Colors.black,
                  ),
                  /**
                   * Materal State
                   * 플러터에서 기본적으로 해당되는 상태(버튼만 가리키는게 아님)
                   * hovered - 마우스 커서를 올려놓은 상태
                   * focused - 포커스 됐을 때(주로 텍스트 필드)
                   * pressed - 눌렸을 때
                   * dragged - 드래그 됐을 때
                   * selected - 선택됐을 때(체크박스, 라디오 등)
                   * scrollUnder - 다른 컴포넌트 밑으로 스크롤링 됐을 때(들어갔을 때)
                   * disabled - 비활성화 됐을 때
                   * error - 에러 상태(주로 텍스트)
                   */
                  foregroundColor: MaterialStateProperty.resolveWith( //해당되는 상태 값이 들어온다
                      (Set<MaterialState> states){
                        //null - 기본값
                        if(states.contains(MaterialState.pressed)){
                          return Colors.white;
                        }
                        return null;
                      }
                  ),
                  padding: MaterialStateProperty.resolveWith((states) =>
                    states.contains(MaterialState.pressed) ? EdgeInsets.all(40.0) : EdgeInsets.all(20.0)
                  ),
                ),
                child: Text('ButtonStyle')
            ),
            //ElevatedButton - 3D의 약간 튀어나온 형태
            ElevatedButton(
                onPressed: (){},
                //styleFrom - 간편하게 스타일 지정 가능
                style: ElevatedButton.styleFrom(
                  //메인 색상(primary)
                  //primary: Colors.red,
                  backgroundColor: Colors.red,
                  //onPrimary - 글자 및 애니메이션 색상
                  //onPrimary: Colors.black,
                  foregroundColor: Colors.black,
                  //그림자 색상
                  shadowColor: Colors.green,
                  //3D 입체감의 높이
                  elevation: 10.0,
                  //글자 스타일
                  textStyle: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w700,
                  ),
                  //패딩
                  padding: EdgeInsets.all(20.0),
                  //테두리 속성
                  side: BorderSide(
                    color: Colors.black,
                    width: 4.0,
                  ),
                  //형태
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)
                  )
                ),
                child: Text('ElevatedButton')
            ),
            //OutlinedButton - 테두리 형태
            OutlinedButton(
                onPressed: (){},
                style: OutlinedButton.styleFrom(
                  // primary: Colors.green,
                  //onPrimary는 없음 - 주 색상이 글자랑 애니메이션 효과에 들어감
                  foregroundColor: Colors.green,
                  //배경색 지정 - 하지만 Outlined를 쓰는 이유가 없어진다
                  //사실상 primary가 어떤 색을 변경해주냐의 차이
                  // backgroundColor: Colors.yellow,
                ),
                child: Text('OutlinedButton')
            ),
            //TextButton - 글자만 있고 클릭 시 효과만
            TextButton(
                onPressed: (){},
                style: TextButton.styleFrom(
                  // primary: Colors.brown,
                  //주 색상이 어떤 것을 의미하느냐 외에 다 동일하다
                  foregroundColor: Colors.brown,
                ),
                child: Text('TextButton')
            )
          ],
        ),
      ),
    );
  }
}
