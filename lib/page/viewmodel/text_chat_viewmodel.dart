import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:salondec/core/define.dart';
import 'package:salondec/core/viewState.dart';
import 'package:salondec/data/model/text_chat_model.dart';

class TextChatViewModel extends GetxController {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  // 게시판 글 리스트 변수
  RxList<TextChatModel> textChatList = <TextChatModel>[].obs;
  // 게시판 댓글 리스트 변수
  RxList<CommentModel> commentList = <CommentModel>[].obs;

  Rxn<ViewState> _textChatLobbyViewState = Rxn(Initial());
  ViewState get textChatLobbyViewState => _textChatLobbyViewState.value!;

  Rxn<ViewState> _textRoomMakerViewState = Rxn(Initial());
  ViewState get textRoomMakerViewState => _textRoomMakerViewState.value!;

  Rxn<ViewState> _textChatDetailViewState = Rxn(Initial());
  ViewState get textChatDetailViewState => _textChatDetailViewState.value!;

  // Rxn<ViewState> _textChatDetailCommentViewState = Rxn(Initial());
  // ViewState get textChatDetailCommentViewState =>
  //     _textChatDetailCommentViewState.value!;

  // 게시판 글 받아오기
  Future<void> getTextChatList() async {
    // 현재 코인 컬렉션 없으면 만들어주고 잇으면 갯수 가져오기. 코인 컬렉션은 유저 아이디 안에.
    // 받아오고 널 체크
    try {
      _setState(_textChatLobbyViewState, Loading());

      QuerySnapshot<Map<String, dynamic>> textChatListQuerySnapshot =
          await _firebaseFirestore
              .collection(FireStoreCollection.textChatCollection)
              .get();

      var tempTextChatList = textChatListQuerySnapshot.docs
          .map((e) => TextChatModel.fromFirebase(e))
          .toList();

      if (tempTextChatList.isNotEmpty) {
        textChatList.value = tempTextChatList;
        _setState(_textChatLobbyViewState, Loaded());
      } else {
        _setState(_textChatLobbyViewState, Empty());
      }
    } catch (e) {
      _catchError(e);
    }
  }

  // 해당 게시판 댓글 불러오기
  Future<void> getChatCommentList(String docId) async {
    _setState(_textChatDetailViewState, Loading());
    commentList.clear();
    QuerySnapshot<Map<String, dynamic>> commentListQuerySnapshot =
        await _firebaseFirestore
            .collection(FireStoreCollection.textChatCollection)
            .doc(docId)
            .collection(FireStoreCollection.commentTextChatSubCollection)
            .get();

    var tempCommentList = commentListQuerySnapshot.docs
        .map((e) => CommentModel.fromFirebase(e))
        .toList();

    if (tempCommentList.isNotEmpty) {
      commentList.value = tempCommentList;
    }

    if (tempCommentList.isEmpty) {
      _setState(_textChatDetailViewState, Empty());
    } else {
      _setState(_textChatDetailViewState, Loaded());
    }
  }

  //? 게시판 글쓰기
  // 1. 글 작성 하는 유저 콜렉션 - textChat 콜렉션 안에 저장 ; textchat model
  // 2. text chat collection에 저장
  Future<void> writeTextChatList({
    required String uid,
    required TextChatModel textChatModel,
  }) async {
    try {
      _setState(_textRoomMakerViewState, Loading());

      textChatModel.commentCount = 0;
      textChatModel.docId = _firebaseFirestore
          .collection(FireStoreCollection.textChatCollection)
          .doc()
          .id;

      await _firebaseFirestore
          .collection(FireStoreCollection.textChatCollection)
          .doc(textChatModel.docId)
          .set(textChatModel.toJson());

      await _firebaseFirestore
          .collection(FireStoreCollection.userCollection)
          .doc(uid)
          .collection(FireStoreCollection.userTextChatSubCollection)
          .doc(textChatModel.docId)
          .set(textChatModel.toJson());
      _setState(_textRoomMakerViewState, Loaded());
    } catch (e) {
      _catchError(e);
    }
  }

  //? 게시판 댓글달기
  // 1. 댓글 다는 유저 콜렉션 - textChat 콜렉션 - comment collection에 저장 ; comment model
  // 2. text chat collection - comment collection에 저장
  Future<void> leaveConmment({
    required String uid,
    required TextChatModel textChatModel,
    required String name,
    required String contents,
    // required CommentModel commentModel,
  }) async {
    try {
      // _setState(_textChatDetailCommentViewState, Loading());
      _setState(_textChatDetailViewState, Loading());

      CommentModel commentModel =
          CommentModel(uid: uid, name: name, contents: contents);
      var commentId = _firebaseFirestore
          .collection(FireStoreCollection.textChatCollection)
          .doc(textChatModel.docId)
          .collection(FireStoreCollection.commentTextChatSubCollection)
          .doc()
          .id;

      await _firebaseFirestore
          .collection(FireStoreCollection.userCollection)
          .doc(uid)
          .collection(FireStoreCollection.userTextChatSubCollection)
          .doc(textChatModel.docId)
          .collection(FireStoreCollection.userCommentSubCollection)
          .doc(commentId)
          .set(commentModel.toJson());

      await _firebaseFirestore
          .collection(FireStoreCollection.textChatCollection)
          .doc(textChatModel.docId)
          .collection(FireStoreCollection.commentTextChatSubCollection)
          .doc(commentId)
          .set(commentModel.toJson());

      var model = textChatModel.copyWith();
      model.commentCount += 1;
      await _firebaseFirestore
          .collection(FireStoreCollection.textChatCollection)
          .doc(textChatModel.docId)
          .update(model.toJson(textChatModel: textChatModel));

      // _setState(_textChatDetailCommentViewState, Loaded());
    } catch (e) {
      _catchError(e);
    }
  }

  _catchError(Object e) {
    if (e is Error) {
      var logger = Logger();
      logger.d("error code : ${e.toString()}, ${e.stackTrace}");
    }
    var logger = Logger();
    logger.d("error code : ${e.toString()}");
  }

  void _setState(Rxn<ViewState> state, ViewState nextState) =>
      state.value = nextState;
}
