import 'package:flutter/material.dart';
import 'textchat_detail.dart';
import 'package:salondec/data/model/chat.dart';
import 'package:salondec/component/custom_form_buttom.dart';
import 'package:salondec/page/screen/textChatRoomMaker.dart';

class textChatLobbyScreen extends StatefulWidget {
  final String username;
  textChatLobbyScreen({Key? key, required this.username}) : super(key: key);
  
    @override
  _textChatLobbyScreenState createState() => _textChatLobbyScreenState();
}

class _textChatLobbyScreenState extends State<textChatLobbyScreen> with SingleTickerProviderStateMixin {
  final _channelFieldController = TextEditingController();
  late TabController _tabController;


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
  void initState() {
    // initialise your tab controller here
    _tabController = TabController(length: 5, vsync: this);
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: new ThemeData(accentColor: Color(0xff365859)),
        debugShowCheckedModeBanner: false,
        home: DefaultTabController(
          length: 6,
          child: Scaffold(
            body: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                child: TabBar(
                  controller: _tabController,
                  labelColor: Color(0xff365859),
                  isScrollable: true,
                  indicatorColor: Colors.transparent,
                  unselectedLabelColor: Color(0xffD2D2D2),
                  unselectedLabelStyle: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                  ),
                  labelStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  tabs: <Widget>[
                    Text('베스트'),
                    Text('연애'),
                    Text('자랑'),
                    Text('재태크'),
                    Text('유머'),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,),
              CustomFormButton(
                  innerText: '글쓰기',
                  onPressed: (){
                    Navigator.push(
                    context,MaterialPageRoute(
                    builder: (context) => Textchat_making_room(username: widget.username),
                    )
                  );
                }
              ),
              const SizedBox(
                height: 18,
              ),
            Expanded(
              child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                ListView.builder(
                    itemCount: _chatList.length,
                    itemBuilder: (BuildContext context, int index) =>
                        GestureDetector(              
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TextchatDetail(_chatList[index]),
                                )
                            ),
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
                                    trailing:Text(_chatList[index].times)
                                )
                            )
                        )
                ),
                Center(
                  child: Text(
                    '연애게시판을 준비중입니다',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                  ),
                ),
                Center(
                  child: Text(
                    '자랑게시판을 준비중입니다',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                  ),
                ),
                Center(
                  child: Text(
                    '재태크게시판을 준비중입니다',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                  ),
                ),
                Center(
                  child: Text(
                    '유머게시판을 준비중입니다',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),))
    );
  }
}