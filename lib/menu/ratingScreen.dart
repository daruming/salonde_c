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
    return SafeArea(
    child: Scaffold(
      body: Container(
        height: 200,
        child: SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            primaryYAxis: NumericAxis(minimum: 0, maximum: 30, interval: 1),
            series: <ChartSeries<_ChartData, String>>[
              BarSeries<_ChartData, String>(
                  dataSource: data,
                  xValueMapper: (_ChartData data, _) => data.x,
                  yValueMapper: (_ChartData data, _) => data.y,
                  color: Color.fromRGBO(8, 142, 255, 1))
            ]
            )
      )
    ));
  }
}


class _ChartData {
  _ChartData(this.x, this.y);
 
  final String x;
  final double y;
}