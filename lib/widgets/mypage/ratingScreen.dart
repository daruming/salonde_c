import 'package:flutter/material.dart';
import 'package:salondec/page/viewmodel/auth_viewmodel.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class RatingScreen extends StatefulWidget {
  const RatingScreen({Key? key}) : super(key: key);

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}


class _RatingScreenState extends State<RatingScreen> {
  AuthViewModel _authViewModel = Get.find<AuthViewModel>();

  late List<_ChartData> data;

  @override
  void initState() {
    data = [
      _ChartData('5', 5),
      _ChartData('4', 15),
      _ChartData('3', 5),
      _ChartData('2', 4),
      _ChartData('1', 1)
    ];

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
    double height = mediaQuery.size.height*0.6;

    return Scaffold(
      appBar: AppBar(
              toolbarHeight: height,
              flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Container(
              height: 100,
              child: Align(
              alignment: Alignment.bottomCenter,
              )
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
                          borderRadius: BorderRadius.circular(50),
                          child: Image.network(
                            _authViewModel.userModel.value!.profileImageUrl!,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        )
                      : _authViewModel.photoMap["profileImageUrl"] != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.file(
                                _authViewModel.photoMap["profileImageUrl"]!,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ))
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
                ),const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment(0.0, 0.5),
                        end: Alignment(0.0, 0.0),
                        colors: [
                           Colors.white,
                           Color(0x00ffffff),
                           ]
                          )
                        ),
                      ),
                    ],
                  ),
              ),
            ),
      body: Container(
        padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
        child: Row(
        children: [
          SizedBox(
            height: 200,
            child: Column(
            children: const [
              Spacer(), 
              Icon(Icons.star, color: Colors.grey,size: 20.0,),
              Spacer(), 
              Icon(Icons.star, color: Colors.grey,size: 20.0,),
              Spacer(), 
              Icon(Icons.star, color: Colors.grey,size: 20.0,),
              Spacer(), 
              Icon(Icons.star, color: Colors.grey,size: 20.0,),
              Spacer(), 
              Icon(Icons.star, color: Colors.grey,size: 20.0,),
              Spacer(), 
            ]
            )
          ),
          Expanded(
            child: SizedBox(
              height: 200,
              child: SfCartesianChart(
                plotAreaBorderColor: Colors.transparent,
                primaryXAxis: CategoryAxis(),
                primaryYAxis: NumericAxis(isVisible: false),
                series: <ChartSeries<_ChartData, String>>[
                  BarSeries<_ChartData, String>(
                      animationDuration: 4500,
                      dataSource: data,
                      xValueMapper: (_ChartData data, _) => data.x,
                      yValueMapper: (_ChartData data, _) => data.y,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(25),
                        bottomRight: Radius.circular(25)
                      ),
                      gradient: gradientColors,
                      
                  )
                ]
              )
            )
          ),
          
        ]
      )
      )
    );
  }
}


class _ChartData {
  _ChartData(this.x, this.y);
 
  final String x;
  final double y;
}