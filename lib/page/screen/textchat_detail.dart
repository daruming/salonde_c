import 'package:flutter/material.dart';
import 'package:salondec/data/model/chat.dart';

// ignore: must_be_immutable
class TextchatDetail extends StatefulWidget {
  final Chat chat;
  TextchatDetail(this.chat, {Key? key}) : super(key: key);

  List<String> images = ["assets/image/profile_detail1.png"];
  @override
  _TextchatDetailState createState() => _TextchatDetailState();
}

class _TextchatDetailState extends State<TextchatDetail> {
  @override
  Widget build(BuildContext context) {
    final chat = widget.chat;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor:Color(0xff365859),
        title: Text("음성살롱 내용"),
      ),
        body:SingleChildScrollView(
        child: Column(children: <Widget>[
         Container(
              child: ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
                  title: Padding(
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: Text(chat.titles,
                          style: TextStyle(
                              color: Color(0xff365859),
                              fontWeight: FontWeight.w800))),
                  subtitle: Text(chat.contents))
          ),
          const ListTile(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0),
            title: Padding(
                padding: EdgeInsets.only(bottom: 5.0),
                child: Text("못말리는상어",
                    style: TextStyle(
                        color: Color(0xff459B99),
                        fontWeight: FontWeight.w800))),
            subtitle: Text("어렵지 않아요. 꼭 편지가 들어가야 선물은 아니잖아요."),
          ),
          const ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 40.0, vertical: 0),
                  title: Padding(
                      padding: EdgeInsets.only(bottom: 5.0),
                      child: Text("요리가 취미",
                          style: TextStyle(
                              color: Color(0xff459B99),
                              fontWeight: FontWeight.w800))),
                  subtitle: Text("내용에 의미가 없어도 괜찮아요.")),
          Container(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: TextField(
            decoration: InputDecoration(
              hintText: '당신의 생각은 어떤가요?',
              suffixIcon: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Color(0xff365859)),
                padding: EdgeInsets.all(14),
                child: Icon(
                  Icons.send_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              filled: true,
              fillColor: Colors.blueGrey[50],
              labelStyle: TextStyle(fontSize: 12),
              contentPadding: EdgeInsets.all(20),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(25),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),),
        ])

        /*
      ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
      title: Padding(padding: const EdgeInsets.only(bottom: 15.0),
        child: Text(chat.titles, style: TextStyle(color: Color(0xff365859), fontWeight : FontWeight.w800))),
      subtitle: Text(chat.contents)
      ),
      */

     ) );
  }
}
