import 'package:flutter/material.dart';
import 'package:salondec/core/viewState.dart';
import 'package:salondec/data/model/gender_model.dart';
import 'package:salondec/page/viewmodel/auth_viewmodel.dart';
import 'package:get/get.dart';
import 'package:salondec/page/viewmodel/rating_viewmodel.dart';
import 'package:salondec/page/widgets/progress_widget.dart';
import 'today_detail.dart';

// ignore: must_be_immutable
class MatchingScreen extends StatefulWidget {
  MatchingScreen({Key? key}) : super(key: key);

  @override
  State<MatchingScreen> createState() => _MatchingScreenState();
}

class _MatchingScreenState extends State<MatchingScreen> {
  final AuthViewModel _authViewModel = Get.find<AuthViewModel>();
  final RatingViewModel _ratingViewModel = Get.find<RatingViewModel>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        var viewState = _ratingViewModel.luvLetterViewState;
        if (viewState is Loading) {
          return const ProgressWidget();
        }
        return (_ratingViewModel.waitingFavoritePersons.length - 1 == 0)
            ? GridView.builder(
                //itemCount: _matchedList.length,
                itemCount: _ratingViewModel.waitingFavoritePersons.length,
                padding: const EdgeInsets.all(15),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1 / 1.73,
                    crossAxisSpacing: 12.0,
                    mainAxisSpacing: 12.0),
                itemBuilder: (BuildContext context, int index) {
                  var model = _findGenderModelwithWaitingFavoritePersons(index);

                  return GestureDetector(
                    onTap: () {
                      _ratingViewModel.isRatedPersons(targetUid: model.uid);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                Todaydetail(false, genderModel: model),
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
                                          model.profileImageUrl!,
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
                                        child: Text(model.name ?? "",
                                            style: const TextStyle(
                                                fontSize: 16.0,
                                                fontFamily: 'Gothic A1',
                                                fontWeight: FontWeight.w600)))),
                                Expanded(
                                    child: Text(
                                        _eachText(model, "age") +
                                            ' | ' +
                                            _eachText(model, "job") +
                                            ' | ' +
                                            _eachText(model, "mbti"),
                                        style: const TextStyle(
                                            fontSize: 10.0,
                                            fontFamily: 'Gothic A1',
                                            fontWeight: FontWeight.w400))),
                              ]),
                            ),
                          ]),
                    ),
                  );
                })
            : Center(
                child: Text(
                "진행중인 이성이 없습니다",
                style: const TextStyle(
                    fontFamily: 'Abhaya Libre',
                    color: Colors.grey,
                    fontSize: 20.0),
              ));
      }),
    );
  }

  _eachText(GenderModel model, String text) {
    var res = '';
    switch (text) {
      case "age":
        res = (model.age != null && model.age != 0) ? model.age.toString() : "";
        break;
      case "job":
        res = (model.job != null && model.job != '') ? model.job! : "";
        break;
      case "mbti":
        res = (model.mbti != null && model.mbti != '') ? model.mbti! : "";
        break;
      default:
    }
    return res;
  }

  _findGenderModelwithWaitingFavoritePersons(int index) {
    for (var model in _authViewModel.genderModelList) {
      if (model.uid == _ratingViewModel.waitingFavoritePersons[index].uid) {
        return model;
      }
    }
  }
}
