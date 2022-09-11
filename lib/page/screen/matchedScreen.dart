import 'package:flutter/material.dart';
import 'package:salondec/page/viewmodel/auth_viewmodel.dart';
import 'package:get/get.dart';
import 'today_detail.dart';



class MatchedScreen extends StatelessWidget {
  MatchedScreen({Key? key}) : super(key: key);
  AuthViewModel _authViewModel = Get.find<AuthViewModel>();


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: GridView.builder(
          //itemCount: _matchedList.length,
          itemCount: _authViewModel.genderModelList.length,
          padding: EdgeInsets.all(15),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1 / 1.73,
              crossAxisSpacing: 12.0,
              mainAxisSpacing: 12.0),
          itemBuilder: (BuildContext context, int index) => GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Todaydetail(_authViewModel.genderModelList[index]),
                )
              );
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

          ),
        ),
      ),
    );
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
