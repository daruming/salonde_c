// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salondec/data/model/gender_model.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:salondec/component/custom_love_letter.dart';
import 'package:salondec/component/custom_alert_dialog.dart';
import 'package:salondec/page/viewmodel/auth_viewmodel.dart';
import 'package:salondec/page/viewmodel/rating_viewmodel.dart';

class Todaydetail extends StatefulWidget {
  // final Note note;
  final GenderModel genderModel;
  Todaydetail(this.genderModel);

  List<String> images = ["assets/image/profile_detail1.png"];
  @override
  _TodaydetailState createState() => _TodaydetailState();
}

class _TodaydetailState extends State<Todaydetail> {
  final AuthViewModel _authViewModel = Get.find<AuthViewModel>();
  final RatingViewModel _ratingViewModel = Get.find<RatingViewModel>();

  double update_rating = 0.0;

  @override
  void dispose() {
    _ratingViewModel.delete();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final genderModel = widget.genderModel;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: CustomScrollView(
        slivers: <Widget>[
          //# SliverAppBar #1
          SliverAppBar(
            floating: false,
            pinned: false,
            elevation: 0,
            centerTitle: true,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            expandedHeight: 260.0,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background:
                  // Card(
                  // child:
                  Container(
                height: 160,
                color: Color(0xffF1F1F1),
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      (widget.genderModel.profileImageUrl != null &&
                              widget.genderModel.profileImageUrl != '')
                          ? ClipOval(
                              child: Image.network(
                                widget.genderModel.profileImageUrl!,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(50)),
                              width: 100,
                              height: 100,
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.grey[800],
                              ),
                            ),
                      const Padding(
                        padding: EdgeInsets.all(4.0),
                      ),
                      Text(
                        widget.genderModel.name ?? "",
                        style: const TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w800),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(2.0),
                      ),
                      RaisedButton(
                        onPressed: () {
                          if (_ratingViewModel.targetDetail.value != null) {
                            showDialog(
                              barrierColor: Color(0xff365859).withOpacity(0.5),
                              context: context,
                              builder: (context) {
                                return CustomLoveLetter(
                                  func: sendFavoriteMessage,
                                  genderModel: widget.genderModel,
                                  title:
                                      "호감을 보내고 상대방이 수락하면 바로 연락처를 알 수 있습니다.[부분무료]",
                                  hint: "설레는 마음을 담아 메세지를 작성해보아요 :)",
                                );
                              },
                            );
                          } else {
                            showDialog(
                              barrierColor: Colors.black26,
                              context: context,
                              builder: (context) {
                                return const CustomAlertDialog(
                                  title: "별점 평가를 먼저 해주세요.",
                                  //description: "Custom Popup dialog Description.",
                                );
                              },
                            );
                          }
                        },
                        padding: EdgeInsets.symmetric(
                            horizontal: 30.0), //adds padding inside the button
                        child: Text("호감 보내기"),
                        color: Color(0xFF365859),
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                      ),
                      RaisedButton(
                        onPressed: () {
                          showDialog(
                            barrierColor: Color(0xff365859).withOpacity(0.5),
                            context: context,
                            builder: (context) {
                              return CustomLoveLetter(
                                func: sendFavoriteMessage,
                                genderModel: widget.genderModel,
                                title: "당신의 마음을 담아 러브레터 보냅니다.[유료버전]",
                                hint: "설레는 마음을 담아 메세지를 작성해보아요 :)",
                              );
                            },
                          );
                        },
                        child: Text("러브레터 보내기"),
                        color: Color(0xFF365859),
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                      ),
                    ]),
              ),
              // )
            ),
          ),

          SliverGrid(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200.0,
              childAspectRatio: 4.0,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Container(
                  alignment: Alignment.center,
                  color: Colors.white,
                  child: Text('질문 $index'),
                );
              },
              childCount: 6,
            ),
          ),

          SliverList(
            delegate: SliverChildListDelegate([
              Column(
                children: <Widget>[
                  (widget.genderModel.imgUrl1 != null &&
                          widget.genderModel.imgUrl1 != '')
                      ? Container(
                          child: Image.network(
                          widget.genderModel.imgUrl1!,
                          height: 400,
                          fit: BoxFit.fitHeight,
                        ))
                      : Container(
                          height: 10,
                        ),
                ],
              ),
              Container(
                child: (widget.genderModel.introduction != null &&
                        widget.genderModel.introduction != '')
                    ? ListTile(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 15.0),
                        title: Padding(
                            padding: const EdgeInsets.only(bottom: 15.0),
                            child: Text('Q 자기소개')),
                        subtitle: Text(widget.genderModel.introduction ?? ""))
                    : null,
              ),
              Column(
                children: <Widget>[
                  (widget.genderModel.imgUrl2 != null &&
                          widget.genderModel.imgUrl2 != '')
                      ? Container(
                          child: Image.network(
                          widget.genderModel.imgUrl2!,
                          height: 400,
                          fit: BoxFit.fitHeight,
                        ))
                      : Container(
                          height: 10,
                        ),
                ],
              ),
              Container(
                child: (widget.genderModel.character != null &&
                        widget.genderModel.character != '')
                    ? ListTile(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 15.0),
                        title: Padding(
                            padding: const EdgeInsets.only(bottom: 15.0),
                            child: Text('Q 당신은 어떤 성격인가요?')),
                        subtitle: Text(widget.genderModel.character ?? ""))
                    : null,
              ),
              Column(
                children: <Widget>[
                  (widget.genderModel.imgUrl3 != null &&
                          widget.genderModel.imgUrl3 != '')
                      ? Container(
                          child: Image.network(
                          widget.genderModel.imgUrl3!,
                          height: 400,
                          fit: BoxFit.fitHeight,
                        ))
                      : Container(
                          height: 10,
                        ),
                ],
              ),
              Container(
                child: (widget.genderModel.interest != null &&
                        widget.genderModel.interest != '')
                    ? ListTile(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 15.0),
                        title: Padding(
                            padding: const EdgeInsets.only(bottom: 15.0),
                            child: Text('Q 요즘 어떤 것에 관심이 있나요?')),
                        subtitle: Text(widget.genderModel.interest ?? ""))
                    : null,
              ),
            ]),
          ),

          SliverList(
            delegate: SliverChildListDelegate([
              Container(
                color: Color(0xffF1F1F1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 10),
                    RaisedButton(
                      padding: EdgeInsets.symmetric(
                          horizontal: 30.0), //adds padding inside the button
                      onPressed: () {
                        if (update_rating > 0.0) {
                          showDialog(
                            barrierColor: Color(0xff365859).withOpacity(0.5),
                            context: context,
                            builder: (context) {
                              return CustomLoveLetter(
                                func: sendFavoriteMessage,
                                genderModel: widget.genderModel,
                                title:
                                    "호감을 보내고(20코인) 상대방이 수락하면 바로 연락처를 알 수 있습니다.",
                                hint: "설레는 마음을 담아 메세지를 작성해보아요 :)",
                              );
                            },
                          );
                        } else {
                          showDialog(
                            barrierColor: Colors.black26,
                            context: context,
                            builder: (context) {
                              return const CustomAlertDialog(
                                title: "별점 평가를 먼저 해주세요.",
                              );
                            },
                          );
                        }
                      },
                      elevation: 0,
                      child: Text("호감 보내기"),
                      color: Color(0xFF365859),
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0),
                      ),
                    ),
                    RaisedButton(
                      onPressed: () {},
                      elevation: 0,
                      child: Text("러브레터 보내기"),
                      color: Color(0xFF365859),
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                    ),
                    Container(
                      padding: EdgeInsets.all(20.0),
                      child: Text("평가하지 않으면 상대방이 나를 볼 수 없어요"),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
      //obx
      bottomNavigationBar: Obx(() {
        return _ratingViewModel.targetDetail.value == null
            // update_rating == 0.0
            ? Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RatingBar.builder(
                      initialRating: 0,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(horizontal: 8.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Color(0xffFAE291),
                      ),
                      onRatingUpdate: (rating) {
                        setState(() {
                          update_rating = rating;
                        });
                        _ratingViewModel.rating(
                          uid: _authViewModel.userModel.value!.uid,
                          targetUid: widget.genderModel.uid,
                          rating: rating,
                          user: _authViewModel.userModel.value!,
                          genderList: _authViewModel.genderModelList,
                        );
                      },
                    ),
                  ],
                ),
              )
            : Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  // "$update_rating으로 평가하셨습니다.",
                  _ratingViewModel.targetDetail.value == null
                      ? "$update_rating으로 평가하셨습니다."
                      : "${_ratingViewModel.targetDetail.value!.rating}으로 평가하셨습니다.",
                  style: const TextStyle(
                      fontSize: 16.0, fontWeight: FontWeight.w800),
                  textAlign: TextAlign.center,
                ),
              );
      }),
    );
  }

  void sendFavoriteMessage(BuildContext context, String message) async {
    var checkAleadySend = await _ratingViewModel.checkAleadySendFavoirteMessage(
      uid: _authViewModel.userModel.value!.uid,
      targetUid: widget.genderModel.uid,
    );
    if (!checkAleadySend) {
      await _ratingViewModel.sendFavoirteMessage(
          userModel: _authViewModel.userModel.value!,
          genderModel: widget.genderModel,
          rating: _ratingViewModel.targetDetail.value!.rating,
          message: message);
      Get.back();
    } else {
      showDialog(
        barrierColor: Colors.black26,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("이미 호감을 보내셨습니다."),
            content: InkWell(
                onTap: () {
                  Get.back();
                  Get.back();
                },
                child: Text("확인")),
          );
        },
      );
    }
  }
}
