import 'package:flutter/material.dart';

import 'package:salondec/page/screen/matchedScreen.dart';
import 'package:salondec/page/screen/matchingScreen.dart';
import 'package:salondec/page/screen/passawayScreen.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen>  with SingleTickerProviderStateMixin {
  int pageIndex = 0;
  late final _tabController;

  final List<Widget> favoriteTabs = <Tab>[
    new Tab(text: "매칭된이성"),
    new Tab(text: "진행중인이성"),
    new Tab(text: "지나간이성"),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: favoriteTabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
          appBar: TabBar(
            controller: _tabController,
            labelColor: Colors.black,
            unselectedLabelColor: Color(0xffD2D2D2),
            indicatorColor: Colors.black,
            tabs: favoriteTabs
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              MatchedScreen(),
              MatchingScreen(),
              PassawayScreen(),
          ]
        ),
    );
  }
}
