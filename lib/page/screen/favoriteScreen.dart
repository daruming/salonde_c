import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salondec/core/viewState.dart';

import 'package:salondec/page/screen/matchedScreen.dart';
import 'package:salondec/page/screen/matchingScreen.dart';
import 'package:salondec/page/screen/passawayScreen.dart';
import 'package:salondec/page/viewmodel/auth_viewmodel.dart';
import 'package:salondec/page/viewmodel/rating_viewmodel.dart';
import 'package:salondec/page/widgets/progress_widget.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen>
    with SingleTickerProviderStateMixin {
  final AuthViewModel _authViewModel = Get.find<AuthViewModel>();
  final RatingViewModel _ratingViewModel = Get.find<RatingViewModel>();
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
    _ratingViewModel.getFavoirtePersons(uid: _authViewModel.user!.uid);

    _tabController =
        new TabController(vsync: this, length: favoriteTabs.length);
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
          tabs: favoriteTabs),
      body: Obx(() {
        var viewState = _ratingViewModel.luvLetterViewState;
        if (viewState is Loading) {
          return ProgressWidget();
        }
        return TabBarView(controller: _tabController, children: [
          MatchedScreen(),
          MatchingScreen(),
          PassawayScreen(),
        ]);
      }),
    );
  }
}
