import 'package:flutter/material.dart';
import 'package:salondec/page/viewmodel/rating_viewmodel.dart';
import 'package:salondec/widgets/mypage/ratingScreen.dart';
import 'myProfile.dart';
import 'package:salondec/page/viewmodel/auth_viewmodel.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:salondec/data/model/user_model.dart';

const double _kItemExtent = 32.0;

const title = 'Floating App Bar';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({Key? key}) : super(key: key);
  @override
  _MyPageScreenState createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  AuthViewModel _authViewModel = Get.find<AuthViewModel>();
  RatingViewModel _ratingViewModel = Get.find<RatingViewModel>();

  @override
  void initState() {
    _ratingViewModel.getRatedPersons(uid: _authViewModel.userModel.value!.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    double height = mediaQuery.size.height * 0.7;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: CustomScrollView(
        slivers: <Widget>[
          // Add the app bar to the CustomScrollView.
          SliverAppBar(
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyProfileScreen()));
                  }),
            ],
            expandedHeight: height,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Container(
                  height: 100,
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text("${_authViewModel.userModel.value?.rating}점",
                                  style: TextStyle(
                                    color: Color(0xff365859),
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  _authViewModel.userModel.value?.name ?? "",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "${_authViewModel.userCoin.coins}개",
                                  style: TextStyle(
                                    color: Color(0xff365859),
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "보유코인",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ]))),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    child: (_authViewModel.userModel.value != null &&
                            _authViewModel.userModel.value?.profileImageUrl !=
                                null &&
                            _authViewModel.userModel.value?.profileImageUrl !=
                                '' &&
                            _authViewModel.photoMap["profileImageUrl"] == null)
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              _authViewModel.userModel.value!.profileImageUrl!,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          )
                        : _authViewModel.photoMap["profileImageUrl"] != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.file(
                                  _authViewModel.photoMap["profileImageUrl"]!,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ))
                            : Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(20)),
                                width: 100,
                                height: 100,
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.grey[800],
                                ),
                              ),
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment(0.0, 0.5),
                            end: Alignment(0.0, 0.0),
                            colors: [
                          Colors.white,
                          Color(0x00ffffff),
                        ])),
                  ),
                ],
              ),
            ),
          ),

          SliverFillRemaining(
              child: ListView(padding: EdgeInsets.all(30), children: [
            ListTile(
                shape: Border(
                    bottom: BorderSide(
                  color: Colors.grey,
                )),
                title: Center(child: const Text('재심사받기')),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => RatingScreen()));
                }),
            ListTile(
                title: Center(
                    child: Text('로그아웃', style: TextStyle(color: Colors.white))),
                tileColor: Color(0xff365859),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                    color: Colors.grey,
                  ),
                ),
                onTap: () {
                  _handleLogoutUser();
                }),
          ])),
        ],
      ),
    );
  }

  Future _handleLogoutUser() async {
    try {
      // await FirebaseAuth.instance.signOut();
      _authViewModel.signOut();
      if (_authViewModel.user == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('로그아웃 되었습니다.')),
          );
        }
      }
      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }
}
