import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salondec/component/custom_input_field.dart';
import 'package:salondec/component/custom_input_field_multi.dart';
import 'package:salondec/component/custom_form_buttom.dart';

import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:salondec/core/viewState.dart';
import 'package:salondec/data/agora_setting.dart';
import 'package:salondec/data/model/text_chat_model.dart';
import 'package:salondec/page/viewmodel/auth_viewmodel.dart';
import 'package:salondec/page/viewmodel/text_chat_viewmodel.dart';
import 'package:salondec/page/widgets/progress_widget.dart';

class Textchat_making_room extends StatefulWidget {
  final String username;
  const Textchat_making_room({Key? key, required this.username})
      : super(key: key);

  @override
  _Textchat_making_roomState createState() => _Textchat_making_roomState();
}

class _Textchat_making_roomState extends State<Textchat_making_room> {
  TextEditingController _titleFieldController = TextEditingController();
  TextEditingController _contentFieldController = TextEditingController();

  AuthViewModel _authViewModel = Get.find<AuthViewModel>();
  TextChatViewModel _textChatViewModel = Get.find<TextChatViewModel>();

  final String _chars =
      "AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890";
  final Random _rnd = Random();
  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  // Future uploadTextChat(BuildContext context) async {
  // try {

  //   // 문서 작성
  //   String postKey = getRandomString(16);
  //   FirebaseFirestore firestore = FirebaseFirestore.instance;

  //   await firestore.collection('textChat').doc(postKey).set({
  //     'title': _titleFieldController.text,
  //     'content': _contentFieldController.text,
  //   });
  // } catch (e) {
  //   print(e);
  // }
  // Navigator.pop(context);
  // print("완료");
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          backgroundColor: Color(0xff365859),
          title: Text("글쓰기"),
        ),
        body: SingleChildScrollView(child: Center(
          child: Obx(() {
            var viewState = _textChatViewModel.textRoomMakerViewState;
            if (viewState is Loading) {
              return const ProgressWidget();
            }
            return Column(
              children: <Widget>[
                SizedBox(height: 100),
                CustomInputField(
                  controller: _titleFieldController,
                  labelText: '제목',
                  hintText: '무엇을 이야기하고 싶은가요?',
                  isDense: true,
                  validator: (textValue) {
                    if (textValue == null || textValue.isEmpty) {
                      return '제목을 넣어주세요!';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                CustomInputField_multi(
                  controller: _contentFieldController,
                  labelText: '내용',
                  hintText: '주저리주저리 얘기해도 괜찮아요',
                  isDense: true,
                  validator: (textValue) {
                    if (textValue == null || textValue.isEmpty) {
                      return '내용을 넣어주세요!';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                CustomFormButton(
                    innerText: '게시하기',
                    onPressed: () {
                      // uploadTextChat(context);
                      writeTextChatList();
                    }),
                SizedBox(height: 200),
              ],
            );
          }),
        )));
  }

  writeTextChatList() async {
    await _textChatViewModel.writeTextChatList(
        uid: _authViewModel.userModel.value!.uid,
        textChatModel: makeTexhChatModel());

    await _textChatViewModel.getTextChatList();
    Get.back();
  }

  makeTexhChatModel() {
    return TextChatModel(
        uid: _authViewModel.userModel.value!.uid,
        docId: '',
        title: _titleFieldController.text,
        contents: _contentFieldController.text,
        name: _authViewModel.userModel.value!.name ?? '',
        commentCount: 0);
  }
}
