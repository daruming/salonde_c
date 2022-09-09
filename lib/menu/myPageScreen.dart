import 'package:flutter/material.dart';
import 'myProfile.dart';


const double _kItemExtent = 32.0;
List<String> imgArray = [
  "assets/image1.png"
];
const title = 'Floating App Bar';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({Key? key}) : super(key: key);
  @override
  _MyPageScreenState createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {

  @override
  void initState() {
    super.initState();
  }
  
  
  @override
  Widget build(BuildContext context) {
    
    final mediaQuery = MediaQuery.of(context);
    double height = mediaQuery.size.height*0.7;
  
    return Scaffold(  
        body: CustomScrollView(
          slivers: <Widget>[
            // Add the app bar to the CustomScrollView.
            SliverAppBar(
              actions: <Widget>[
                IconButton(icon: Icon(Icons.edit), onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyProfileScreen()));
                }),
              ],
                  
              expandedHeight:height,
              flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Container(
              height: 100,
              child: Align(
              alignment: Alignment.bottomCenter,
              child:Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      Text(
                        "4.87", 
                        style: TextStyle(
                          color: Color(0xff365859),
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '남살롱, 30세', 
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Text(
                          "30개", 
                          style: TextStyle(
                            color: Color(0xff365859),
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "보유코인", 
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                  ]
            ),)),
            background: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  "assets/image/image8.png",
                  fit: BoxFit.cover,
                  ),
                  const DecoratedBox(
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
            
            SliverFillRemaining(
              child: ListView(
                padding: EdgeInsets.all(30),
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.home,
                    ),
                    shape: Border(
                    bottom: BorderSide(
                      color: Colors.grey,
                    )),
                    title: const Text('재심사받기'),
                    onTap: () {
                    }
                    ),
                    ListTile(
                    leading: const Icon(
                      Icons.home,
                    ),
                    shape: Border(
                    bottom: BorderSide(
                      color: Colors.grey,
                    )),
                    title: const Text('지인연락처 차단'),
                    onTap: () {
                    }
                    ),
                ]
              )
            ),
          ],
        ),
    );
  }
}
  
  