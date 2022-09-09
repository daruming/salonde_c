import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:salondec/core/viewState.dart';
import 'package:salondec/data/model/gender_model.dart';
import 'package:salondec/data/model/user_model.dart';
import 'package:salondec/page/viewmodel/auth_viewmodel.dart';
import 'package:salondec/page/viewmodel/rating_viewmodel.dart';

class DiscoveryScreen extends StatefulWidget {
  @override
  _DiscoveryScreenState createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends State<DiscoveryScreen> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TwoCardPageView(),
    );
  }
}

class TwoCardPageView extends StatefulWidget {
  const TwoCardPageView({Key? key}) : super(key: key);

  @override
  _TwoCardPageViewState createState() => _TwoCardPageViewState();
}

class _TwoCardPageViewState extends State<TwoCardPageView> {
  //? _authViewModel.genderModelListUnderFivePeople -> 5명 미만에게 평가받은 이성 사람들.
  final AuthViewModel _authViewModel = Get.find<AuthViewModel>();
  final RatingViewModel _ratingViewModel = Get.find<RatingViewModel>();
  double update_rating = 0.0;
  int index = 0;
  final List<String> _images = [
    "assets/image/discovery1.png",
    "assets/image/discovery2.png",
    "assets/image/discovery3.png",
    "assets/image/discovery4.png",
    "assets/image/discovery5.png",
    "assets/image/discovery6.png",
  ];

  final List<String> titles = [
    "Basic info",
    // "Basic info",
    "Introduction",
    // "Character",
    "Character",
    "Q&A"
  ];

  final PageController _pageController =
      PageController(viewportFraction: 0.8, initialPage: 0);
  double _page = 0;

  checkRatingPerson() async {
    List<GenderModel> temp = [];
    bool check = true;
    for (var model in _authViewModel.genderModelListUnderFivePeople) {
      for (var ratingPerson in _ratingViewModel.ratingPersons) {
        if (model.uid == ratingPerson.targetUid) {
          check = false;
        }
      }
      if (check) {
        temp.add(model);
      }
      check = true;
    }
    _authViewModel.genderModelListUnderFivePeople.clear();
    if (temp.isNotEmpty) {
      _authViewModel.genderModelListUnderFivePeople.addAll(temp);
      await _authViewModel.getDiscoveryUserInfo(
          uid: _authViewModel.genderModelListUnderFivePeople[0].uid);
    }
  }

  checkRatingAgain(int index) async {
    if (index < _authViewModel.genderModelListUnderFivePeople.length) {
      await _authViewModel.getDiscoveryUserInfo(
          uid: _authViewModel.genderModelListUnderFivePeople[index].uid);
    } else {
      _authViewModel.userModelUnderFivePeople.value = null;
    }
  }

  // int checkCardLength() {
  //   int length = 0;
  //   _authViewModel.userModelUnderFivePeople.value.
  //   return length;
  // }

  @override
  void initState() {
    super.initState();
    checkRatingPerson();

    _pageController.addListener(() {
      if (_pageController.page != null) {
        _page = _pageController.page!;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (_authViewModel.discoveryViewState is Loading) {
          return Center(
            child: Container(
              height: 50,
              width: 50,
              child: const CircularProgressIndicator(color: Colors.amber),
            ),
          );
        }
        var length = 4;
        if (_authViewModel.userModelUnderFivePeople.value == null) {
          return Container(
            child: Center(
                child: Text(
              "평가할 사람이 없습니다.",
              style: const TextStyle(
                  fontFamily: 'Abhaya Libre',
                  color: Colors.grey,
                  fontSize: 20.0),
            )),
          );
        } else {
          UserModel model = _authViewModel.userModelUnderFivePeople.value!;
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // for (int i = 0; i < _images.length; i++)
                      for (int i = 0; i < length; i++)
                        Container(
                          margin: EdgeInsets.fromLTRB(5, 20, 5, 20),
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(color: Colors.grey, width: 1.5),
                              color: _page - i > 1 || _page - i < -1
                                  ? Colors.transparent
                                  : _page - i > 0
                                      ? Colors.grey.withOpacity(1 - (_page - i))
                                      : Colors.grey
                                          .withOpacity(1 - (i - _page))),
                        )
                    ],
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 400,
                    child: PageView.builder(
                        controller: _pageController,
                        // itemCount: _images.length,
                        itemCount: length,
                        itemBuilder: (context, index) {
                          // UserModel model =
                          //     _authViewModel.userModelUnderFivePeople.value!;
                          var title = [
                            "Q 자기소개 ?",
                            "Q 제 성격은 ?",
                            "Q 요즘 어떤 것에 관심이 있나요?"
                          ];
                          var contents = [
                            _authViewModel.userModelUnderFivePeople.value
                                    ?.introduction ??
                                "",
                            _authViewModel.userModelUnderFivePeople.value
                                    ?.character ??
                                "",
                            _authViewModel
                                    .userModelUnderFivePeople.value?.interest ??
                                "",
                          ];
                          var urlList = [
                            _authViewModel
                                    .userModelUnderFivePeople.value?.imgUrl1 ??
                                "",
                            _authViewModel
                                    .userModelUnderFivePeople.value?.imgUrl2 ??
                                "",
                            _authViewModel
                                    .userModelUnderFivePeople.value?.imgUrl3 ??
                                "",
                          ];
                          return index == 0
                              ? _userCard(index, model)
                              : _userCard2(index, model, title[index - 1],
                                  contents[index - 1], urlList[index - 1]);
                        }),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(bottom: 80),
                child: RatingBar.builder(
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
                    // if (rating == 0) {
                    setState(() {
                      update_rating = rating;
                    });
                    _ratingViewModel.rating(
                      uid: _authViewModel.userModel.value!.uid,
                      targetUid:
                          _authViewModel.userModelUnderFivePeople.value!.uid,
                      rating: rating,
                      user: _authViewModel.userModel.value!,
                      genderList: _authViewModel.genderModelList,
                    );
                    index += 1;
                    checkRatingAgain(index);
                    // }
                  },
                ),
              ),
            ],
          );
        }
      }),
    );
  }

  SizedBox _userCard(int index, UserModel model) {
    return SizedBox(
      child: Column(
        children: [
          Expanded(
              child:
                  (model.profileImageUrl != null && model.profileImageUrl != '')
                      ? Image.network(model.profileImageUrl!)
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
                        )),
          Container(
              margin: const EdgeInsets.fromLTRB(0, 15, 0, 10),
              child: Text(titles[index],
                  style: const TextStyle(
                      fontFamily: 'Abhaya Libre',
                      fontWeight: FontWeight.w700,
                      fontSize: 30.0))),
          Card(
              elevation: 0.0,
              child: ListTile(
                title: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 10),
                    // child: Text("강살롱, 24살",
                    child: Text(model.name ?? "설정안함",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Color(0xff365859),
                            fontWeight: FontWeight.w800))),
                subtitle: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                    // child: Text("배우 | 164cm |  마름",
                    child: Text(
                        "${model.job ?? "x"} | ${model.height ?? "x"}cm |  ${model.name ?? "x"}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Color(0xffC4C4C4)))),
              )),
        ],
      ),
    );
  }

  SizedBox _userCard2(
      int index, UserModel model, String title, String contents, String? url) {
    return SizedBox(
      child: Column(
        children: [
          Expanded(
              child: (url != null && url != '')
                  ? Image.network(url)
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
                    )),
          Container(
              margin: const EdgeInsets.fromLTRB(0, 15, 0, 10),
              child: Text(titles[index],
                  style: const TextStyle(
                      fontFamily: 'Abhaya Libre',
                      fontWeight: FontWeight.w700,
                      fontSize: 30.0))),
          Card(
              elevation: 0.0,
              child: ListTile(
                title: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 10),
                    // child: Text("강살롱, 24살",
                    child: Text(title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Color(0xff365859),
                            fontWeight: FontWeight.w800))),
                subtitle: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                    // child: Text("배우 | 164cm |  마름",
                    child: Text(contents,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Color(0xffC4C4C4)))),
              )),
        ],
      ),
    );
  }
}

class ItemBuilder extends StatelessWidget {
  const ItemBuilder({
    Key? key,
    required List<String> images,
    required this.index,
  })  : _images = images,
        super(key: key);

  final List<String> _images;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      height: 200,
      child: Center(child: Text("")),
    );
  }
}

class Item {
  final String title;
  final Color color;

  Item(this.title, this.color);
}
