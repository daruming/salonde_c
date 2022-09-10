import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:salondec/core/viewState.dart';
import 'package:salondec/menu/loginScreen.dart';
import 'package:salondec/page/screen/homeScreen.dart';
import 'package:salondec/page/screen/chatScreen.dart';
import 'package:salondec/page/screen/discoveryScreen.dart';
import 'package:salondec/page/screen/favoriteScreen.dart';
import 'package:salondec/page/screen/loveletterScreen.dart';
import 'package:salondec/page/viewmodel/rating_viewmodel.dart';
import 'package:salondec/page/widgets/main_drawer.dart';

import 'package:salondec/page/viewmodel/auth_viewmodel.dart';
import 'package:salondec/page/widgets/progress_widget.dart';

import '../menu/myPageScreen.dart';

String title_string = "Home";

class MainPage extends StatefulWidget {
  static const routeName = "/main_page";

  const MainPage({Key? key}) : super(key: key);
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final AuthViewModel _authViewModel = Get.find<AuthViewModel>();
  final RatingViewModel _ratingViewModel = Get.find<RatingViewModel>();

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

  void init() async {
    if (_authViewModel.initNum == 0) {
      await _authViewModel.init();
    }
    if (_ratingViewModel.initNum == 0) {
      await _ratingViewModel.init(uid: _authViewModel.userModel.value!.uid);
    }
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        GetPlatform.isIOS
            ? await appLogoutDialogForIos(onClose: _authViewModel.signOut)
            : await appExitDialogForAnfroid(onClose: SystemNavigator.pop);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          toolbarHeight: 60,
          title: Text(title_string,
              style: TextStyle(
                  fontFamily: 'Abhaya Libre',
                  fontWeight: FontWeight.w700,
                  fontSize: 36.0)),
          elevation: 0.5,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.person,
              ),
              onPressed: () {
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MyPageScreen()));
              },
            )
          ],
        ),
        drawer: MainDrawer(),
        
        body: Obx(() {
          Size size = MediaQuery.of(context).size;
          if (_authViewModel.homeViewState is Loaded) {
            return pageList[pageIndex];
          }
          return ProgressWidget();
        }),
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
      ),
    );
  }

  Future<void> appExitDialogForAnfroid({required Function? onClose}) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("앱을 종료하시겠습니까?",
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  ?.copyWith(color: Colors.black)),
          actions: <Widget>[
            TextButton(
              child: Text("예, 종료합니다",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      ?.copyWith(color: Colors.black45)),
              onPressed: () {
                if (onClose != null) onClose();
              },
            ),
            TextButton(
              child: Text("아니오",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      ?.copyWith(color: Colors.amber)),
              onPressed: () {
                Navigator.pop(context, "아니오");
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> appLogoutDialogForIos({required Function? onClose}) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("로그아웃 하시겠습니까?",
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  ?.copyWith(color: Colors.black)),
          actions: <Widget>[
            TextButton(
              child: Text("예",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      ?.copyWith(color: Colors.black45)),
              onPressed: () {
                if (onClose != null) {
                  Get.back();
                  onClose();
                  Get.until(
                      (route) => Get.currentRoute == LoginScreen.routeName);
                }
                ;
              },
            ),
            TextButton(
              child: Text("아니오",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      ?.copyWith(color: Colors.amber)),
              onPressed: () {
                Navigator.pop(context, "아니오");
              },
            ),
          ],
        );
      },
    );
  }
}
