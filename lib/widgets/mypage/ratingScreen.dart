import 'package:flutter/material.dart';
import 'package:salondec/core/viewState.dart';
import 'package:salondec/data/model/gender_model.dart';
import 'package:salondec/page/viewmodel/auth_viewmodel.dart';
import 'package:get/get.dart';
import 'package:salondec/page/viewmodel/rating_viewmodel.dart';
import 'package:salondec/page/widgets/progress_widget.dart';
import 'package:salondec/widgets/mypage/myPageScreen.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class RatingScreen extends StatefulWidget {
  const RatingScreen({Key? key}) : super(key: key);

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  AuthViewModel _authViewModel = Get.find<AuthViewModel>();
  RatingViewModel _ratingViewModel = Get.find<RatingViewModel>();

  late List<_ChartData> data;
  void inputRatingToData() {
    data = [
      _ChartData('5', _ratingViewModel.ratingList['5.0']!),
      _ChartData('4', _ratingViewModel.ratingList['4.0']!),
      _ChartData('3', _ratingViewModel.ratingList['3.0']!),
      _ChartData('2', _ratingViewModel.ratingList['2.0']!),
      _ChartData('1', _ratingViewModel.ratingList['1.0']!)
    ];
  }

  @override
  void initState() {
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final List<Color> color = <Color>[];
    color.add(Color(0xff0BE8B6));
    color.add(Color(0xff0BA8D4));

    final List<double> stops = <double>[];
    stops.add(0.0);
    stops.add(1.0);

    final LinearGradient gradientColors =
        LinearGradient(colors: color, stops: stops);

    final mediaQuery = MediaQuery.of(context);
    double height = mediaQuery.size.height * 0.5;

    return Obx(() {
      var viewState = _ratingViewModel.profileViewState;
      if (viewState is Loading) {
        return Scaffold(body: ProgressWidget());
      }
      inputRatingToData();
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: height,
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
                            Text(
                              _authViewModel.userModel.value?.rating
                                      .toString() ??
                                  "" + '점',
                              style: TextStyle(
                                color: Color(0xff365859),
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ])),
            ),
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
        body: ListView(padding: EdgeInsets.all(30), children: [
          Row(
            children: [
              SizedBox(
                  height: 200,
                  child: Column(children: [
                    Spacer(),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          // <-- Icon
                          Icons.star,
                          size: 20.0,
                        ), // <-- Text
                        SizedBox(
                          width: 5,
                        ),
                        Text('1점'),
                      ],
                    ),
                    Spacer(),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          // <-- Icon
                          Icons.star,
                          size: 20.0,
                        ), // <-- Text
                        SizedBox(
                          width: 5,
                        ),
                        Text('2점'),
                      ],
                    ),
                    Spacer(),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          // <-- Icon
                          Icons.star,
                          size: 20.0,
                        ), // <-- Text
                        SizedBox(
                          width: 5,
                        ),
                        Text('3점'),
                      ],
                    ),
                    Spacer(),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          // <-- Icon
                          Icons.star,
                          size: 20.0,
                        ), // <-- Text
                        SizedBox(
                          width: 5,
                        ),
                        Text('4점'),
                      ],
                    ),
                    Spacer(),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          // <-- Icon
                          Icons.star,
                          size: 20.0,
                        ), // <-- Text
                        SizedBox(
                          width: 5,
                        ),
                        Text('5점'),
                      ],
                    ),
                    Spacer(),
                  ])),
              Expanded(
                  child: SizedBox(
                      height: 200,
                      child: SfCartesianChart(
                          plotAreaBorderColor: Colors.transparent,
                          primaryXAxis: CategoryAxis(isVisible: false),
                          primaryYAxis: NumericAxis(isVisible: false),
                          series: <ChartSeries<_ChartData, String>>[
                            BarSeries<_ChartData, String>(
                              animationDuration: 4500,
                              dataSource: data,
                              xValueMapper: (_ChartData data, _) => data.x,
                              yValueMapper: (_ChartData data, _) => data.y,
                              borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(25),
                                  bottomRight: Radius.circular(25)),
                              gradient: gradientColors,
                            )
                          ]))),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          ListTile(
              title: Center(child: Text('돌아가기')),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                  color: Colors.grey,
                ),
              ),
              onTap: () {
                Get.back();
              }),
          SizedBox(
            height: 5,
          ),
          ListTile(
              title: Center(
                  child:
                      Text('새로 측정하기', style: TextStyle(color: Colors.white))),
              tileColor: Color(0xff365859),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                  color: Colors.grey,
                ),
              ),
              onTap: () {
                getRatedPersons();
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => MyPageScreen()));
              }),
        ]),
      );
    });
  }

  void getRatedPersons() async {
    await _authViewModel.geMyGenderListForReRate();
    GenderModel genderModel = _ratingViewModel.getGenderModel(
        _authViewModel.myGenderModelListForReRate,
        _authViewModel.userModel.value!.uid);
    await _ratingViewModel.requestRerating(
        userModel: _authViewModel.userModel.value!, genderModel: genderModel);

    await _ratingViewModel.getRatedPersons(
        uid: _authViewModel.userModel.value!.uid);
  }
}

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}
