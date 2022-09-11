import 'package:flutter/material.dart';
import 'textchat_detail.dart';
import 'package:salondec/data/model/chat.dart';

class TextchatScreen extends StatelessWidget {
  TextchatScreen({Key? key}) : super(key: key);

  final List<Chat> _chatList = [
    Chat(
      titles: '넷플릭스와 사는 집돌이',
      subtitles: "3명이 댓글을 달았어요",
      times: "1분전",
      contents:
          "주제에 대한 생각을 적습니다. 내용에 의미가 없어도 괜찮아요. 내가 보고 듣고 읽은 것들을 요약하며 논리적으로 적으면 됩니다. 글쓰는게 뭐 어려운가요?",
    ),
    Chat(
      titles: '꿈은 많고 놀고 싶습니다',
      subtitles: "2명이 댓글을 달았어요",
      times: "2분전",
      contents:
          "주제에 대한 생각을 적습니다. 내용에 의미가 없어도 괜찮아요. 내가 보고 듣고 읽은 것들을 요약하며 논리적으로 적으면 됩니다. 글쓰는게 뭐 어려운가요?",
    ),
    Chat(
      titles: '요리가 취미인 남자에 관하여',
      subtitles: "3명이 댓글을 달았어요",
      times: "4분전",
      contents:
          "주제에 대한 생각을 적습니다. 내용에 의미가 없어도 괜찮아요. 내가 보고 듣고 읽은 것들을 요약하며 논리적으로 적으면 됩니다. 글쓰는게 뭐 어려운가요?",
    ),
    Chat(
      titles: '넷플릭스와 사는 집돌이',
      subtitles: "명이 댓글을 달았어요",
      times: "10분전",
      contents:
          "주제에 대한 생각을 적습니다. 내용에 의미가 없어도 괜찮아요. 내가 보고 듣고 읽은 것들을 요약하며 논리적으로 적으면 됩니다. 글쓰는게 뭐 어려운가요?",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: new ThemeData(accentColor: Color(0xff365859)),
        debugShowCheckedModeBanner: false,
        home: DefaultTabController(
            length: 6,
            child: Scaffold(
                appBar: const TabBar(
                  labelColor: Color(0xff365859),
                  unselectedLabelColor: Color(0xffD2D2D2),
                  isScrollable: true,
                  tabs: <Widget>[
                    Tab(text: "전체"),
                    Tab(text: "베스트"),
                    Tab(text: "연애"),
                    Tab(text: "자랑"),
                    Tab(text: "재태크"),
                    Tab(text: "유머"),
                  ],
                ),
                body: ListView.builder(
                    itemCount: _chatList.length,
                    itemBuilder: (BuildContext context, int index) =>
                        GestureDetector(
                            // onTap: () => Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //       builder: (context) =>
                            //           TextchatDetail(_chatList[index]),
                            //     )),
                            child: Card(
                                margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                elevation: 0.0,
                                child: ListTile(
                                    title: Text(_chatList[index].titles,
                                        style: TextStyle(
                                            color: Color(0xff365859),
                                            fontWeight: FontWeight.w800)),
                                    subtitle: Text(_chatList[index].subtitles,
                                        style: TextStyle(
                                            color: Color(0xffC4C4C4))),
                                    trailing:
                                        Text(_chatList[index].times))))))));
  }
}
