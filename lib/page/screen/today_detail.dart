// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:salondec/data/model/gender_model.dart';
import 'package:salondec/data/model/person2.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:salondec/component/custom_love_letter.dart';
import 'package:salondec/component/custom_alert_dialog.dart';

class Todaydetail extends StatefulWidget {
  // final Note note;
  final GenderModel genderModel;
  Todaydetail(this.genderModel);

  List<String> images = ["assets/image/profile_detail1.png"];
  @override
  _TodaydetailState createState() => _TodaydetailState();
}

class _TodaydetailState extends State<Todaydetail> {
  // ignore: non_constant_identifier_names
  double update_rating = 0.0;
  // @override
  // void initState() {
  //   widget.genderModel.uid);
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    // final genderModel = widget.genderModel;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: CustomScrollView(
        slivers: <Widget>[
          //# SliverAppBar #1
          SliverAppBar(
            floating: false,
            pinned: false,
            elevation: 0,
            centerTitle: true,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            expandedHeight: 290.0,
            flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,
                background: Card(
                  color: Color(0xffF1F1F1),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: SingleChildScrollView(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            (widget.genderModel.profileImageUrl != null &&
                                    widget.genderModel.profileImageUrl != '')
                                ? ClipOval(
                                    child: Image.network(
                                      widget.genderModel.profileImageUrl!,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    width: 100,
                                    height: 100,
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                            const Padding(
                              padding: EdgeInsets.all(4.0),
                            ),
                            Text(
                              widget.genderModel.name ?? "",
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.w800),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(2.0),
                            ),
                            RaisedButton(
                              onPressed: () {
                                if (update_rating > 0.0) {
                                  showDialog(
                                    barrierColor:
                                        Color(0xff365859).withOpacity(0.5),
                                    context: context,
                                    builder: (context) {
                                      return const CustomLoveLetter(
                                        title:
                                            "????????? ?????????(20??????) ???????????? ???????????? ?????? ???????????? ??? ??? ????????????.",
                                        hint: "????????? ????????? ?????? ???????????? ?????????????????? :)",
                                      );
                                    },
                                  );
                                } else {
                                  showDialog(
                                    barrierColor: Colors.black26,
                                    context: context,
                                    builder: (context) {
                                      return const CustomAlertDialog(
                                        title: "?????? ????????? ?????? ????????????.",
                                        //description: "Custom Popup dialog Description.",
                                      );
                                    },
                                  );
                                }
                              },
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      30.0), //adds padding inside the button
                              child: Text("?????? ?????????"),
                              color: Color(0xFF365859),
                              textColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      new BorderRadius.circular(30.0)),
                            ),
                            RaisedButton(
                              onPressed: () {},
                              child: Text("???????????? ?????????"),
                              color: Color(0xFF365859),
                              textColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      new BorderRadius.circular(30.0)),
                            ),
                          ]),
                    ),
                  ),
                )),
          ),

          SliverGrid(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200.0,
              childAspectRatio: 4.0,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Container(
                  alignment: Alignment.center,
                  color: Colors.white,
                  child: Text('?????? $index'),
                );
              },
              childCount: 6,
            ),
          ),

          SliverList(
            delegate: SliverChildListDelegate([
              Container(
                color: Color(0xffF1F1F1),
                height: 250.0,
                child: Stack(
                  children: <Widget>[
                    (widget.genderModel.imgUrl1 != null &&
                            widget.genderModel.imgUrl1 != '')
                        ? Positioned.fill(
                            //   child: Image.asset(
                            // "assets/image/profile_detail1.png",
                            child: Image.network(
                            widget.genderModel.imgUrl1!,
                            fit: BoxFit.fitHeight,
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
                  ],
                ),
              ),
              Container(
                child: ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
                    title: Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: Text('Q ???????????? ?')),
                    subtitle: Text(widget.genderModel.introduction ?? "")
                    // : Text(
                    // '???????????????. ????????? ????????? ?????? ?????????. ??????????????? ??? ?????? ????????? ????????? ???????????? :) ')),
                    ),
              ),
              Container(
                color: Color(0xffF1F1F1),
                height: 250.0,
                child: Stack(
                  children: <Widget>[
                    (widget.genderModel.imgUrl2 != null &&
                            widget.genderModel.imgUrl2 != '')
                        ? Positioned.fill(
                            child: Image.network(
                            widget.genderModel.imgUrl2!,
                            fit: BoxFit.fitHeight,
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
                  ],
                ),
              ),
              Container(
                child: ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
                    title: Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: Text('Q ??? ????????? ?')),
                    subtitle: Text(widget.genderModel.character ?? "")),
                // :Text('#????????? #???????????? #?????????')),
              ),
              Container(
                child: ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
                    title: Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: Text('Q ????????? ?????? ?????? ?????????????')),
                    subtitle: Text('???????????? ????????? ?????????. ????????? ????????? ????????????.')),
              ),
              Container(
                color: Color(0xffF1F1F1),
                height: 250.0,
                child: Stack(
                  children: <Widget>[
                    (widget.genderModel.imgUrl3 != null &&
                            widget.genderModel.imgUrl3 != '')
                        ? Positioned.fill(
                            child: Image.network(
                            widget.genderModel.imgUrl3!,
                            fit: BoxFit.fitHeight,
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
                  ],
                ),
              ),
              Container(
                child: ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
                    title: Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: Text('Q ?????? ?????? ?????? ????????? ??????????')),
                    subtitle: Text(widget.genderModel.interest ?? "")),
                // :Text('?????? ???????????? ?????????. ????????? ????????? ????????????.')),
              ),
            ]),
          ),

          SliverList(
            delegate: SliverChildListDelegate([
              Container(
                color: Color(0xffF1F1F1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 10),
                    RaisedButton(
                      padding: EdgeInsets.symmetric(
                          horizontal: 30.0), //adds padding inside the button
                      onPressed: () {
                        if (update_rating > 0.0) {
                          showDialog(
                            barrierColor: Color(0xff365859).withOpacity(0.5),
                            context: context,
                            builder: (context) {
                              return const CustomLoveLetter(
                                title:
                                    "????????? ?????????(20??????) ???????????? ???????????? ?????? ???????????? ??? ??? ????????????.",
                                hint: "????????? ????????? ?????? ???????????? ?????????????????? :)",
                              );
                            },
                          );
                        } else {
                          showDialog(
                            barrierColor: Colors.black26,
                            context: context,
                            builder: (context) {
                              return const CustomAlertDialog(
                                title: "?????? ????????? ?????? ????????????.",
                              );
                            },
                          );
                        }
                      },
                      elevation: 0,
                      child: Text("?????? ?????????"),
                      color: Color(0xFF365859),
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0),
                      ),
                    ),
                    RaisedButton(
                      onPressed: () {},
                      elevation: 0,
                      child: Text("???????????? ?????????"),
                      color: Color(0xFF365859),
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                    ),
                    Container(
                      padding: EdgeInsets.all(20.0),
                      child: Text("???????????? ????????? ???????????? ?????? ??? ??? ?????????"),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RatingBar.builder(
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
                setState(() {
                  update_rating = rating;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
