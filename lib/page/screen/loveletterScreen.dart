import 'package:flutter/material.dart';

class LoveletternewScreen extends StatefulWidget {
  int pageIndex = 0;
  @override
  _LoveletternewScreenState createState() => _LoveletternewScreenState();
}

class _LoveletternewScreenState extends State<LoveletternewScreen> {
  final loveletters = [
    "실은 피드백은 보실 것 같아서 이쪽으로 보내요. 프로필을 봤는데 너무 인상적이네요 :) 취미생활이 같아서 호감이 갔어요. 와인과 맛집을 좋아하는게 좋아요.",
    "진짜 별로예요. 소개글도 그렇고 너무 성의가없어요. 잘생긴걸 아는 사람? 그런느낌?ㅁ",
    "취미생활이 같아서 호감이 갔어요. 와인과 맛집을 좋아하는게 좋아요. 프로필을 봤는데 너무 인상적이네요 :) 미남이세요 !",
    "안녕하세요. 저는 센스 공감 능력 위트 있는 스타일이고 가정교육을 제대로 받고 자신감 있게 사회생활 열심히 하고 있습니다. 결이 비슷하신 분인 것 같아요. 잘 부탁드립니다 !"
  ];

  final points = [
    "4.5",
    "2.5",
    "5.0",
    "5.0",
  ];
  final icons = [
    Icons.ac_unit,
    Icons.access_alarm,
    Icons.access_time,
    Icons.access_time
  ];
  List<String> images = [
    "assets/image/loveletter_1.png",
    "assets/image/loveletter_2.png",
    "assets/image/loveletter_3.png",
    "assets/image/loveletter_4.png",
  ];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: new ThemeData(
          accentColor: Colors.black,
        ),
        debugShowCheckedModeBanner: false,
        home: DefaultTabController(
            length: 6,
            child: Scaffold(
                body: ListView.builder(
                    itemCount: loveletters.length,
                    itemBuilder: (context, index) {
                      return Card(
                          margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                          elevation: 0.0,
                          child: ListTile(
                            leading:
                                Container(child: Image.asset(images[index])),
                            title: Padding(
                                padding: EdgeInsets.fromLTRB(0, 15, 0, 10),
                                child: Text(
                                    ("강살롱님에게" + points[index] + "점을 받았어요!"))),
                            subtitle: Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                                child: Text(loveletters[index],
                                    style:
                                        TextStyle(color: Color(0xffC4C4C4)))),
                            trailing: Icon(Icons.more_vert),
                          ));
                    }))));
  }
}
