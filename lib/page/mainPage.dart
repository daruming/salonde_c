import 'package:dartz/dartz_unsafe.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salondec/menu/Test.dart';
import 'package:salondec/menu/lobby.dart';
import 'package:salondec/menu/myProfile.dart';
import 'package:salondec/page/screen/homeScreen.dart';
import 'package:salondec/page/screen/chatScreen.dart';
import 'package:salondec/page/screen/discoveryScreen.dart';
import 'package:salondec/page/screen/favoriteScreen.dart';
import 'package:salondec/page/screen/loveletterScreen.dart';
import 'package:salondec/menu/lobby_list.dart';

import 'package:salondec/widgets/agora-group-calling/GroupCallPage.dart';

import 'package:salondec/page/viewmodel/auth_viewmodel.dart';
// import 'package:salondec/widgets/agora-group-calling/GroupCall_Screen.dart';

import 'package:salondec/widgets/broadcast_audio/broadAudioScreen.dart';
import 'package:salondec/widgets/broadcast_video/broadVideoScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:salondec/widgets/join_channel_video.dart';

String title_string = "Home";

class MainPage extends StatefulWidget {
  static const routeName = "/main_page";

  const MainPage({Key? key}) : super(key: key);
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  AuthViewModel _authViewModel = Get.find<AuthViewModel>();

  int pageIndex = 0;
  List<Widget> pageList = <Widget>[
    HomeScreen(),
    FavoriteScreen(),
    ChatScreen(),
    LoveletternewScreen(),
    DiscoveryScreen()
  ];

  final TextEditingController _username = TextEditingController();
  // final user = FirebaseAuth.instance.currentUser!;
  Future<void> _init() async {
    // String? uid = await _authViewModel.storage.read(key: "uid");
    // await Future.wait([
    // _authViewModel.currentUser();
    await _authViewModel.getUserInfo();
    await _authViewModel.getMainPageInfo(
        uid: _authViewModel.user!.uid,
        // uid: user.uid,
        gender: _authViewModel.userModel.value!.gender);
    // if (_authViewModel.genderModelList.value != null) {
    //   _authViewModel.genderModelList.value!.forEach((e) {
    //     print("object $e");
    //   });
    // }

    // ]);
  }

  @override
  void initState() {
    // _init();
    _authViewModel.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 60,
        title: Text(("Home"),
            style: const TextStyle(
                fontFamily: 'Abhaya Libre',
                fontWeight: FontWeight.w700,
                fontSize: 36.0)),
        elevation: 0.5,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text("header"),
            ),
            ListTile(
              leading: const Icon(
                Icons.home,
              ),
              title: const Text('나의 프로필'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MyProfileScreen()));
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.home,
              ),
              title: const Text('음성채팅리스트'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            LobbyList(username: _username.text)));
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.home,
              ),
              title: const Text('테스트'),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Test()));
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.home,
              ),
              title: const Text('브로드캐스트'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BroadcastVideo(
                            username: _authViewModel.user!.email!)));
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.home,
              ),
              title: const Text('오디오브로드캐스트'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => BroadcastAudio()));
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.home,
              ),
              title: const Text('그룹콜'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AgoraGroupCalling()));
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.home,
              ),
              title: const Text('아고라정식그룹콜'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RtmpStreaming()));
              },
            ),
          ],
        ),
      ),
      body: pageList[pageIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: pageIndex,
        onTap: (value) {
          setState(() {
            pageIndex = value;
            switch (pageIndex) {
              case 0:
                {
                  title_string = 'Home';
                }
                break;
              case 1:
                {
                  title_string = 'Favorite';
                }
                break;
              case 2:
                {
                  title_string = 'Salon';
                }
                break;
              case 3:
                {
                  title_string = 'Love letter';
                }
                break;
              case 4:
                {
                  title_string = 'Discovery';
                }
                break;
            }
          });
        },
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'favorite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.forum),
            label: 'forum',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.reviews),
            label: 'reviews',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.public),
            label: 'public',
          ),
        ],
        selectedItemColor: Colors.amber[200],
      ),
    );
  }
}
