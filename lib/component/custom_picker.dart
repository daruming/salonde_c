import 'package:flutter/material.dart';

class CustomPicker extends StatefulWidget {
  @override
  _CustomPickerState createState() => _CustomPickerState();
}

class _CustomPickerState extends State<CustomPicker> with SingleTickerProviderStateMixin {

  var selectedYear;
  double age=0.0;
  late Animation animation;
  late AnimationController animationController;

  @override
  void initState() {
    // TODO: implement initState
    animationController=new AnimationController(vsync: this,duration: new Duration(microseconds: 1500));
    animation=animationController;
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    animationController.dispose();
    super.dispose();

  }

  DateTime dt = DateTime.now();
  void _agePicker(){
    showDatePicker(context: context,
        initialDate: new DateTime(2022),
        firstDate: new DateTime(1900),
        lastDate:DateTime.now()).then((dt){
          setState(() {
            selectedYear=dt?.year;
            calculateAge();
          });
          });
  }

  void calculateAge(){
    setState(() {
      age=(2022-selectedYear).toDouble();
      animation=Tween<double>(begin: animation.value,end: age).animate(new CurvedAnimation(parent: animationController, curve: Curves.fastOutSlowIn));
      animation.addListener((){
        setState(() {
        });
      });
      animationController.forward();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Age Calculator"),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // ignore: unnecessary_new
            new OutlinedButton(
                onPressed: _agePicker,
              child: new Text(selectedYear!=null?selectedYear.toString():"Select Year Of Birth"),
            ),
            new Text("${animation.value.toStringAsFixed(0)}")
          ],
        ),
      ),
    );
  }
}
