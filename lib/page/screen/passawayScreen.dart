import 'package:flutter/material.dart';
import 'package:salondec/page/viewmodel/auth_viewmodel.dart';
import 'package:get/get.dart';
import 'today_detail.dart';
import 'package:flip_card/flip_card.dart';




class PassawayScreen extends StatelessWidget {
  PassawayScreen({Key? key}) : super(key: key);
  AuthViewModel _authViewModel = Get.find<AuthViewModel>();
  
  List<String> images = [
    "assets/image/image1_mask.png",
    "assets/image/image4_mask.png",
  ];

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: GridView.builder(
          //itemCount: images.length,
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
            child: FlipCard(
                      direction: FlipDirection.HORIZONTAL,
                      back: Material(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadiusDirectional.circular(30.0),
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
                      front: Material(
                        borderRadius: BorderRadiusDirectional.circular(30.0),
                        child: Card(
                          semanticContainer: true,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child:  Image.asset('assets/image/cover.jpg',
                                        fit: BoxFit.fitHeight
                                        )
                                      ),
                                    )
                                  )
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
