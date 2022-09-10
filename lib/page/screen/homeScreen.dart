import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salondec/core/viewState.dart';
import 'package:salondec/page/viewmodel/auth_viewmodel.dart';
import 'package:salondec/page/viewmodel/rating_viewmodel.dart';
import 'package:salondec/page/widgets/main_drawer.dart';
import 'today_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AuthViewModel _authViewModel = Get.find<AuthViewModel>();

  @override
  void initState() {
    // _authViewModel.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final RatingViewModel _ratingViewModel = Get.find<RatingViewModel>();

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            drawer: MainDrawer(),
            body: Obx(() {
              if (_authViewModel.homeViewState is Loading) {
                return Container();
                // return SizedBox(
                //   width: size.width,
                //   height: size.height,
                //   child: Stack(
                //     alignment: Alignment.center,
                //     children: <Widget>[
                //       CircularProgressIndicator(),
                //     ],
                //   ),
                // );
              }
              // StreamBuilder<QuerySnapshot>(
              //     stream: FirebaseFirestore.instance.collection('woman').snapshots(),
              //     builder: (context, snapshot) {
              //       if (snapshot.hasData) {
              //         return
              return GridView.builder(
                // itemCount: snapshot.data!.docs.length,
                itemCount: _authViewModel.genderModelList.length,
                padding: const EdgeInsets.all(15),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1 / 1.5,
                    crossAxisSpacing: 12.0,
                    mainAxisSpacing: 12.0),
                itemBuilder: (BuildContext context, int index) {
                  // DocumentSnapshot doc = snapshot.data!.docs[index];
                  return GestureDetector(
                    onTap: () {
                      _ratingViewModel.isRatedPersons(
                          targetUid: _authViewModel.genderModelList[index].uid);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                // todaydetail(_noteList[index]),
                                Todaydetail(
                                    _authViewModel.genderModelList[index]),
                          ));
                    },
                    child: Card(
                      shadowColor: Colors.transparent,
                      child: Stack(
                          alignment: FractionalOffset.bottomCenter,
                          children: <Widget>[
                            Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(
                                          // doc['userPhotoUrl'],
                                          _authViewModel.genderModelList[index]
                                              .profileImageUrl!,
                                        ),
                                        fit: BoxFit.fitHeight))),
                            Container(
                              color: Colors.white,
                              alignment: Alignment.center,
                              height: 40.0,
                              child: Row(children: <Widget>[
                                Expanded(
                                    child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 0, 0, 0),
                                        // child: Text(doc['title'],
                                        child: Text(
                                            _authViewModel
                                                    .genderModelList[index]
                                                    .name ??
                                                "",
                                            style: const TextStyle(
                                                fontSize: 16.0,
                                                fontFamily: 'Gothic A1',
                                                fontWeight: FontWeight.w600)))),
                                Expanded(
                                    child: Text(
                                        _eachText(index, "age") +
                                            ' | ' +
                                        _eachText(index, "job") +
                                            ' | ' +
                                        _eachText(index, "mbti"),
                                        style: const TextStyle(
                                            fontSize: 10.0,
                                            fontFamily: 'Gothic A1',
                                            fontWeight: FontWeight.w400))),
                              ]),
                            ),
                          ]),
                    ),
                  );
                },
              );
              //   }
              //   return Text(snapshot.error.toString());
              // }),
            })));
  }

  _eachText(int index, String text) {
    var res = '';
    switch (text) {
      case "age":
        res = (_authViewModel.genderModelList[index].age != null &&
                _authViewModel.genderModelList[index].age != 0)
            ? _authViewModel.genderModelList[index].age.toString()
            : "";
        break;
      case "job":
        res = (_authViewModel.genderModelList[index].job != null &&
                _authViewModel.genderModelList[index].job != '')
            ? _authViewModel.genderModelList[index].job!
            : "";
        break;
      case "mbti":
        res = (_authViewModel.genderModelList[index].mbti != null &&
                _authViewModel.genderModelList[index].mbti != '')
            ? _authViewModel.genderModelList[index].mbti!
            : "";
        break;
      default:
    }
    return res;
  }
}
