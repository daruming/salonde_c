import 'package:flutter/material.dart';
import 'package:salondec/data/model/chat.dart';
import 'package:timeago/timeago.dart' as timeago;

// ignore: must_be_immutable
class TextchatDetail extends StatefulWidget {
  final Chat chat;
  TextchatDetail(this.chat, {Key? key}) : super(key: key);

  List<String> images = ["assets/image/profile_detail1.png"];
  @override
  _TextchatDetailState createState() => _TextchatDetailState();
}

class _TextchatDetailState extends State<TextchatDetail> {
  TextEditingController _replyFieldController = TextEditingController();
  final Map<String, List<String>> _seniorMember = {}; 
  final Map<String, int> _replyList = {};
  String myreply = '';

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
          Container(
            child: ListView.builder(
            shrinkWrap: true,
            itemCount: _replyList.length,
            itemBuilder: (context, index) {
              return Card(
                  color: Colors.transparent,
                  margin: EdgeInsets.fromLTRB(30, 5, 10, 5),
                  elevation: 0.0,
                  child: ListTile(
                    title: Text("유저아이디", style: TextStyle(
                        color: Color(0xff459B99),
                        fontWeight: FontWeight.w800)),
                    subtitle: Text(_replyList.keys.toList()[index],),
                    trailing: Text(timeago.format(DateTime.now()).toString()),
                  )
                );
            },
          ),
        ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Row(
              children: [
              Expanded(
                child: TextField(
                  controller: _replyFieldController,
                  decoration: InputDecoration(
                    hintText: '당신의 생각은 어떤가요?',
                  )
                )
              ),
              const SizedBox(width: 15),
              Container(
                padding: const EdgeInsets.all(15.0),
                decoration: const BoxDecoration(
                    color: Color(0xff365859), shape: BoxShape.circle),
                child: InkWell(
                  child: const Icon(
                    Icons.send, color: Colors.white,
                  ),
                  onTap: (){
                    _createReply(_replyFieldController.text);
                  },
                ),
              )
            ]
          )
        )
    ]
     ) ));
  }
  Future<void> _createReply(String replyName) async {
    setState(() {
      _replyList.putIfAbsent(replyName, () => 1);
      _seniorMember.putIfAbsent(replyName, () => []);
      myreply = replyName;
    });
    _replyFieldController.clear();

    print('List of channels : $_replyList');
  }
}
