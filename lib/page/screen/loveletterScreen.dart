import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salondec/component/custom_alert_dialog.dart';
import 'package:salondec/core/viewState.dart';
import 'package:salondec/page/viewmodel/auth_viewmodel.dart';
import 'package:salondec/page/viewmodel/rating_viewmodel.dart';
import 'package:salondec/page/widgets/progress_widget.dart';

class LoveletternewScreen extends StatefulWidget {
  int pageIndex = 0;
  @override
  _LoveletternewScreenState createState() => _LoveletternewScreenState();
}

class _LoveletternewScreenState extends State<LoveletternewScreen> {
  final AuthViewModel _authViewModel = Get.find<AuthViewModel>();
  final RatingViewModel _ratingViewModel = Get.find<RatingViewModel>();

  @override
  void initState() {
    _ratingViewModel.getFavoirtePersons(uid: _authViewModel.user!.uid);
    super.initState();
  }

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
            child: Scaffold(body: Obx(() {
              var viewState = _ratingViewModel.luvLetterViewState;
              if (viewState is Loading) {
                return ProgressWidget();
              }
              return (_ratingViewModel.myGetFavoritePersons.length - 1) == 0
                  ? ListView.builder(
                      itemCount: _ratingViewModel.myGetFavoritePersons.length,
                      itemBuilder: (context, index) {
                        return _ratingViewModel
                                    .myGetFavoritePersons[index].matchingYn ==
                                false
                            ? InkWell(
                                onTap: () {
                                  showDialog(
                                    barrierColor: Colors.black26,
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text("수락 하시겠습니까?"),
                                        content: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            InkWell(
                                                onTap: () {
                                                  acceptFavoirteMessage(index);
                                                },
                                                child: Text("확인")),
                                            InkWell(
                                                onTap: () => Get.back(),
                                                child: Text("취소")),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Card(
                                    margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                    elevation: 0.0,
                                    child: ListTile(
                                      leading:
                                          // Container(child: Image.asset(images[index])),
                                          (_ratingViewModel
                                                          .myGetFavoritePersons[
                                                              index]
                                                          .profileImageUrl !=
                                                      null &&
                                                  _ratingViewModel
                                                          .myGetFavoritePersons[
                                                              index]
                                                          .profileImageUrl !=
                                                      "")
                                              ? Container(
                                                  width: 40,
                                                  child: Image.network(
                                                      _ratingViewModel
                                                          .myGetFavoritePersons[
                                                              index]
                                                          .profileImageUrl!))
                                              : Container(
                                                  width: 40,
                                                  child: Text("없음"),
                                                ),
                                      title: Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 15, 0, 10),
                                          child: Text(
                                              ("${_ratingViewModel.myGetFavoritePersons[index].name}님에게" +
                                                  _ratingViewModel
                                                      .myGetFavoritePersons[
                                                          index]
                                                      .rating
                                                      .toString() +
                                                  "점을 받았어요!"))),
                                      subtitle: Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 0, 0, 15),
                                          child: Text(
                                              _ratingViewModel
                                                      .myGetFavoritePersons[
                                                          index]
                                                      .message ??
                                                  "",
                                              style: TextStyle(
                                                  color: Color(0xffC4C4C4)))),
                                      trailing: Icon(Icons.more_vert),
                                    )),
                              )
                            : Container();
                      })
                  : Center(
                      child: Text(
                      "도착한 러브레터가 없습니다",
                      style: const TextStyle(
                          fontFamily: 'Abhaya Libre',
                          color: Colors.grey,
                          fontSize: 20.0),
                    ));
            }))));
  }

  void acceptFavoirteMessage(int index) async {
    await _ratingViewModel.acceptFavoirteMessage(
        userModel: _authViewModel.userModel.value!,
        waitFavoriteModels: _ratingViewModel.waitingFavoritePersons,
        getFavoriteModel: _ratingViewModel.myGetFavoritePersons[index]);
    await _ratingViewModel.getFavoirtePersons(
        uid: _authViewModel.userModel.value!.uid);
    Get.back();
  }
}
