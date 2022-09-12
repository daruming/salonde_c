import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salondec/core/viewState.dart';
import 'package:salondec/page/viewmodel/auth_viewmodel.dart';
import 'package:salondec/page/viewmodel/text_chat_viewmodel.dart';
import 'package:salondec/page/widgets/progress_widget.dart';
import 'textchat_detail.dart';
import 'package:salondec/data/model/chat.dart';
import 'package:salondec/component/custom_form_buttom.dart';
import 'package:salondec/page/screen/textChatRoomMaker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class textChatLobbyScreen extends StatefulWidget {
  final String username;
  const textChatLobbyScreen({Key? key, required this.username})
      : super(key: key);

  @override
  _textChatLobbyScreenState createState() => _textChatLobbyScreenState();
}

class _textChatLobbyScreenState extends State<textChatLobbyScreen>
    with SingleTickerProviderStateMixin {
  AuthViewModel _authViewModel = Get.find<AuthViewModel>();
  TextChatViewModel textChatViewModel = Get.find<TextChatViewModel>();

  final _channelFieldController = TextEditingController();
  late TabController _tabController;

  DateTime _now = DateTime.now();
  final DateTime time1 = DateTime.parse("2022-04-20 20:18:04Z");
  final DateTime time2 = DateTime.now();

  var tabList = <Widget>[
    Text('베스트'),
    Text('연애'),
    Text('자랑'),
    Text('재태크'),
    Text('유머'),
  ];

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
    textChatViewModel.getTextChatList();
    _tabController = TabController(length: 5, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffF4F4F4),
        body: Column(children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            child: TabBar(
              controller: _tabController,
              labelColor: Color(0xff365859),
              isScrollable: true,
              indicatorColor: Colors.transparent,
              unselectedLabelColor: Color(0xffD2D2D2),
              unselectedLabelStyle: TextStyle(
                fontSize: 15,
                color: Colors.grey,
                fontWeight: FontWeight.w400,
              ),
              labelStyle: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
              tabs: tabList,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          CustomFormButton(
              innerText: '글쓰기',
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          Textchat_making_room(username: widget.username),
                    ));
              }),
          const SizedBox(
            height: 18,
          ),
          Obx(() {
            var viewState = textChatViewModel.textChatLobbyViewState;
            if (viewState is Loading) {
              return const ProgressWidget();
            }
            if (viewState is Empty) {
              return const Center(child: Text("게시글이 없습니다."));
            }
            return Expanded(
              child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  ListView.builder(
                      itemCount: textChatViewModel.textChatList.length,
                      itemBuilder: (BuildContext context, int index) {
                        // DocumentSnapshot doc = snapshot.data!.docs[index];

                        return GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TextchatDetail(
                                      textChatViewModel.textChatList[index]),
                                )),
                            child: Card(
                                margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                elevation: 0.0,
                                child: ListTile(
                                  title: Text(
                                      textChatViewModel
                                          .textChatList[index].title,
                                      style: TextStyle(
                                          color: Color(0xff365859),
                                          fontWeight: FontWeight.w800)),
                                  subtitle: Text(
                                      textChatViewModel.textChatList[index]
                                                  .commentCount ==
                                              0
                                          ? "댓글이 없습니다"
                                          : "댓글이 ${textChatViewModel.textChatList[index].commentCount}개 있습니다",
                                      style:
                                          TextStyle(color: Color(0xffC4C4C4))),
                                  //trailing: Text(timeago.format(time2)),
                                )));
                      }),
                  const Center(
                    child: Text(
                      '연애게시판을 준비중입니다',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const Center(
                    child: Text(
                      '자랑게시판을 준비중입니다',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const Center(
                    child: Text(
                      '재태크게시판을 준비중입니다',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const Center(
                    child: Text(
                      '유머게시판을 준비중입니다',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            );
          }),
        ]));

    // return Text(snapshot.error.toString());
  }
}
