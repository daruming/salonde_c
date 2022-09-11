import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salondec/core/viewState.dart';
import 'package:salondec/data/model/chat.dart';
import 'package:salondec/data/model/text_chat_model.dart';
import 'package:salondec/page/viewmodel/auth_viewmodel.dart';
import 'package:salondec/page/viewmodel/text_chat_viewmodel.dart';
import 'package:salondec/page/widgets/progress_widget.dart';
import 'package:timeago/timeago.dart' as timeago;

// ignore: must_be_immutable
class TextchatDetail extends StatefulWidget {
  // final Chat chat;
  // final TextChatModel chat;
  final TextChatModel model;
  TextchatDetail(this.model, {Key? key}) : super(key: key);

  List<String> images = ["assets/image/profile_detail1.png"];
  @override
  _TextchatDetailState createState() => _TextchatDetailState();
}

class _TextchatDetailState extends State<TextchatDetail> {
  AuthViewModel _authViewModel = Get.find<AuthViewModel>();
  TextChatViewModel _textChatViewModel = Get.find<TextChatViewModel>();

  TextEditingController _replyFieldController = TextEditingController();
  final Map<String, List<String>> _seniorMember = {};
  final Map<String, int> _replyList = {};
  String myreply = '';

  @override
  void initState() {
    _textChatViewModel.getChatCommentList(widget.model.docId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final model = widget.model;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        backgroundColor: Color(0xff365859),
        foregroundColor: Colors.white,
        title:
            Text("문자살롱", style: TextStyle(fontSize: 20.0, color: Colors.white)),
      ),
      body:
          // Obx(() {
          //   var viewState = _textChatViewModel.textChatDetailViewState;
          //   if (viewState is Loading) {
          //     return const ProgressWidget();
          //   }

          //   return
          SingleChildScrollView(
              child: Column(children: <Widget>[
        Container(
            child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 30.0, vertical: 15.0),
                title: Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: Text(model.title,
                        style: const TextStyle(
                            color: Color(0xff365859),
                            fontWeight: FontWeight.w800))),
                subtitle: Text(model.contents))),
        Obx(() {
          var commentViewState = _textChatViewModel.textChatDetailViewState;

          return Stack(
            children: <Widget>[
              ListView.builder(
                shrinkWrap: true,
                // itemCount: _replyList.length,
                itemCount: _textChatViewModel.commentList.length,
                itemBuilder: (context, index) {
                  return Card(
                      color: Colors.transparent,
                      margin: const EdgeInsets.fromLTRB(30, 5, 10, 5),
                      elevation: 0.0,
                      child: ListTile(
                        title: Text(
                            _textChatViewModel.commentList[index].name ?? "",
                            style: const TextStyle(
                                color: Color(0xff459B99),
                                fontWeight: FontWeight.w800)),
                        subtitle: Text(
                          // _replyList.keys.toList()[index],
                          _textChatViewModel.commentList[index].contents,
                        ),
                        trailing:
                            Text(timeago.format(DateTime.now()).toString()),
                      ));
                },
              ),
              if (commentViewState is Loading) const ProgressWidget(),
            ],
          );
        }),
        Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Row(children: [
              Expanded(
                  child: TextField(
                      controller: _replyFieldController,
                      decoration: const InputDecoration(
                        hintText: '당신의 생각은 어떤가요?',
                      ))),
              const SizedBox(width: 15),
              Container(
                padding: const EdgeInsets.all(15.0),
                decoration: const BoxDecoration(
                    color: Color(0xff365859), shape: BoxShape.circle),
                child: InkWell(
                  child: const Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                  onTap: () {
                    // _createReply(_replyFieldController.text);
                    FocusScope.of(context).unfocus();
                    leaveComment();
                  },
                ),
              )
            ]))
      ])),
      // })
    );
  }

  leaveComment() async {
    if (_replyFieldController.text != '') {
      await _textChatViewModel.leaveConmment(
        uid: _authViewModel.userModel.value!.uid,
        textChatModel: widget.model,
        name: _authViewModel.userModel.value!.name ?? "",
        contents: _replyFieldController.text,
      );
      await _textChatViewModel.getChatCommentList(widget.model.docId);
      await _textChatViewModel.getTextChatList();
      _replyFieldController.clear();
    } else {
      //alert
    }
  }

  Future<void> _createReply(String replyName) async {
    setState(() {
      _replyList.putIfAbsent(replyName, () => 1);
      _seniorMember.putIfAbsent(replyName, () => []);
      myreply = replyName;
    });
    _replyFieldController.clear();
  }
}
