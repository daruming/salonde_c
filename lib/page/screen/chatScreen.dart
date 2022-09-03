import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:salondec/page/screen/voiceChatLobbyScreen.dart';
import 'package:salondec/page/screen/textChatLobbyScreen.dart';


class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);
  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> with SingleTickerProviderStateMixin {
  int pageIndex = 0;
  final user = FirebaseAuth.instance.currentUser!;
  late final _tabController;
  final List<Tab> salonTabs = <Tab>[
    new Tab(text: "문자살롱"),
    new Tab(text: "음성살롱"),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: salonTabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
          appBar: TabBar(
            controller: _tabController,
            labelColor: Colors.black,
            unselectedLabelColor: Color(0xffD2D2D2),
            indicatorColor: Colors.transparent,
            tabs: salonTabs,
          ),
          body: TabBarView(
            controller: _tabController,
            children: 
            [
            textChatLobbyScreen(username: user.email!),
            VoiceChatLobbyScreen(username: user.email!),
            ]
          ),    
    );
  }
}
