import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:salondec/core/define.dart';
import 'package:salondec/core/viewState.dart';
import 'package:salondec/data/model/favorite_model.dart';
import 'package:salondec/data/model/gender_model.dart';
import 'package:salondec/data/model/rated_model.dart';
import 'package:salondec/data/model/rating_model.dart';
import 'package:salondec/data/model/user_model.dart';

class RatingViewModel extends GetxController {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  ErrorState _errorState = ErrorState.none;
  ErrorState get errorState => _errorState;

  RxList<RatingModel> ratingPersons = <RatingModel>[].obs;
  RxList<RatedModel> ratedPersons = <RatedModel>[].obs;
  int ratedPersonsLength = 0;

  RxList<FavoriteModel> allGetFavoritePersons = <FavoriteModel>[].obs;
  RxList<FavoriteModel> myGetFavoritePersons = <FavoriteModel>[].obs;
  RxList<FavoriteModel> matchingFavoritePersons = <FavoriteModel>[].obs;
  RxList<FavoriteModel> waitingFavoritePersons = <FavoriteModel>[].obs;
  RxList<FavoriteModel> goneFavoritePersons = <FavoriteModel>[].obs;

  final RxBool _checkRating = false.obs;
  bool get checkRating => _checkRating.value;

  Rxn<RatingModel> targetDetail = Rxn(null);
  RxInt currentRating = 0.obs;

  final Rxn<ViewState> _detailViewState = Rxn(Initial());
  ViewState get detailViewState => _detailViewState.value!;

  final Rxn<ViewState> _profileViewState = Rxn(Initial());
  ViewState get profileViewState => _profileViewState.value!;

  final Rxn<ViewState> _luvLetterViewState = Rxn(Initial());
  ViewState get luvLetterViewState => _luvLetterViewState.value!;
  // var doSendFavortieMessage = false;  //! 호감보내기 버튼 -> 먼저 목록을 가져와서 있으면 이미 했다고 알림띄우기

  RxInt _initNum = 0.obs;
  int get initNum => _initNum.value;

  Map<String, double> ratingList = {
    '1.0': 0.0,
    '2.0': 0.0,
    '3.0': 0.0,
    '4.0': 0.0,
    '5.0': 0.0,
  };

  Future<void> rating({
    required String uid,
    required String targetUid,
    required double rating,
    required UserModel user,
    required List<GenderModel> genderList,
  }) async {
    await giveRating(
        uid: uid,
        targetUid: targetUid,
        rating: rating,
        genderList: genderList,
        user: user);
    await getRatingPersons(uid: uid);
    isRatedPersons(targetUid: targetUid);
  }

  Future<void> init({required String uid}) async {
    await getRatingPersons(uid: uid);
    //test
    // await requestRerating(uid: uid);
  }

  delete() {
    _checkRating.value = false;
    _setState(_detailViewState, Initial());
    targetDetail = Rxn(null);
    _errorState = ErrorState.none;
  }

  // 재심사
  // 우선 재심사할 대상의 rated_persons 에 아이디들을 받아와서 all_users에서 해당 uid에서 내 uid 문서 지우기
  // 마지막으로 내 rated_persons 날리기
  Future<void> requestRerating({required String uid}) async {
    List<RatedModel> tempList = [];
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firebaseFirestore
              .collection(FireStoreCollection.userCollection)
              .doc(uid)
              .collection(FireStoreCollection.userRatedMeSubCollection)
              .get();
      var temp =
          querySnapshot.docs.map((e) => RatedModel.fromFirebase(e)).toList();
      if (temp.isNotEmpty) {
        for (var e in temp) {
          tempList.add(e);
        }
      }
      if (tempList.isNotEmpty) {
        for (var model in tempList) {
          await _firebaseFirestore
              .collection(FireStoreCollection.userCollection)
              .doc(model.uid)
              .collection(FireStoreCollection.userRatingSubCollection)
              .doc(uid)
              .delete();
          await _firebaseFirestore
              .collection(FireStoreCollection.userCollection)
              .doc(uid)
              .collection(FireStoreCollection.userRatedMeSubCollection)
              .doc(model.uid)
              .delete();
        }
      }
    } on FirebaseException catch (e) {
      if (e.code == "network-request-failed") {
        _errorState = ErrorState.network;
      }
      var logger = Logger();
      logger.d("error code : ${e.toString()}, ${e.stackTrace}");
    } catch (e) {
      _catchError(e);
    }
  }

  // 디테일 페이지 진입할때 비교, 별점 입력 시
  isRatedPersons({required String targetUid}) {
    _setState(_detailViewState, Loading());
    if (ratingPersons.isNotEmpty) {
      for (var model in ratingPersons) {
        if (model.targetUid == targetUid) {
          _checkRating.value = true; // dispose 할때 다시 false
          targetDetail.value = model;
        }
      }
    }
    _setState(_detailViewState, Loaded());
  }

  //
  // Future<void> updateRatingData({required List<UserModel> userList}) async {}
  // Future<void> updateRatingData() async {}

// user 전체 데이터 로드된 곳에서
// 호감을 보낸 콜렉션따로.
  Future<void> sendFavoirteMessage({
    // required String uid,

    required UserModel userModel,
    required double rating,
    required String message,
    required GenderModel genderModel,
  }) async {
    try {
      FavoriteModel favoriteModel = FavoriteModel(
        uid: genderModel.uid,
        name: genderModel.name,
        rating: rating,
        message: message,
        profileImageUrl: genderModel.profileImageUrl,
        matchingYn: false,
      );
      FavoriteModel theOtherSidefavoriteModel = FavoriteModel(
        uid: userModel.uid,
        name: userModel.name,
        rating: rating,
        message: message,
        profileImageUrl: userModel.profileImageUrl,
        matchingYn: false,
      );
      await _firebaseFirestore
          .collection(FireStoreCollection.userCollection)
          .doc(userModel.uid)
          .collection(FireStoreCollection.userFavoritePersonCollection)
          .doc(genderModel.uid)
          .set(favoriteModel.toJson());

      await _firebaseFirestore
          .collection(FireStoreCollection.userCollection)
          .doc(genderModel.uid)
          .collection(FireStoreCollection.userGetFavoritePersonCollection)
          .doc(userModel.uid)
          .set(theOtherSidefavoriteModel.toJson());
    } on FirebaseException catch (e) {
      if (e.code == "network-request-failed") {
        _errorState = ErrorState.network;
      }
      var logger = Logger();
      logger.d("error code : ${e.toString()}, ${e.stackTrace}");
    } catch (e) {
      _catchError(e);
    }
  }

// waiting~ 에 있는지 체크
  Future<void> acceptFavoirteMessage({
    required UserModel userModel,
    required List<FavoriteModel> waitFavoriteModels,
    required FavoriteModel getFavoriteModel,
  }) async {
    try {
      _setState(_luvLetterViewState, Loading());
      FavoriteModel? tempFavoriteModel;

      FavoriteModel mySelfFavoriteModel = FavoriteModel(
        uid: userModel.uid,
        rating: 0.0,
        name: userModel.name ?? "",
        message: "",
        profileImageUrl: userModel.profileImageUrl,
        matchingYn: true,
      );
      if (waitFavoriteModels.isNotEmpty) {
        for (var model in waitFavoriteModels) {
          if (model.uid == getFavoriteModel.uid) {
            tempFavoriteModel = model;
            break;
          } else {
            tempFavoriteModel = null;
          }
        }
      }
      getFavoriteModel.matchingYn = true;

      FavoriteModel theOtherSideFavoriteModelForMe =
          getFavoriteModel.copyWith();
      theOtherSideFavoriteModelForMe.rating = 0.0;
      theOtherSideFavoriteModelForMe.message = "";
      theOtherSideFavoriteModelForMe.matchingYn = true;

      FavoriteModel theOtherSideFavoriteModelForTheOther =
          getFavoriteModel.copyWith();
      theOtherSideFavoriteModelForTheOther.uid = userModel.uid;
      theOtherSideFavoriteModelForTheOther.name = userModel.name;
      theOtherSideFavoriteModelForTheOther.profileImageUrl =
          userModel.profileImageUrl;

// 본인의 favorite_person
      await _firebaseFirestore
          .collection(FireStoreCollection.userCollection)
          .doc(userModel.uid)
          .collection(FireStoreCollection.userFavoritePersonCollection)
          .doc(getFavoriteModel.uid)
          .set(theOtherSideFavoriteModelForMe.toJson());

// 본인의 get_favorite_person , for true
      await _firebaseFirestore
          .collection(FireStoreCollection.userCollection)
          .doc(userModel.uid)
          .collection(FireStoreCollection.userGetFavoritePersonCollection)
          .doc(getFavoriteModel.uid)
          .update(getFavoriteModel.toJson());

// 상대의 get_favorite_person
      await _firebaseFirestore
          .collection(FireStoreCollection.userCollection)
          .doc(getFavoriteModel.uid)
          .collection(FireStoreCollection.userGetFavoritePersonCollection)
          .doc(mySelfFavoriteModel.uid)
          .set(mySelfFavoriteModel.toJson(favoriteModel: tempFavoriteModel));

// 상대의 favorite_person , for true
      await _firebaseFirestore
          .collection(FireStoreCollection.userCollection)
          .doc(getFavoriteModel.uid)
          .collection(FireStoreCollection.userFavoritePersonCollection)
          .doc(theOtherSideFavoriteModelForTheOther.uid)
          .update(theOtherSideFavoriteModelForTheOther.toJson());

      _setState(_luvLetterViewState, Loaded());
    } on FirebaseException catch (e) {
      if (e.code == "network-request-failed") {
        _errorState = ErrorState.network;
      }
      var logger = Logger();
      logger.d("error code : ${e.toString()}, ${e.stackTrace}");
    } catch (e) {
      _catchError(e);
    }
  }

  //러브레터에 목록, 매칭된 이성, 진행중인 이성 까지 포함
  Future<void> getFavoirtePersons({
    required String uid,
    // required String targetUid,
  }) async {
    try {
      var now = DateTime.now();
      List<FavoriteModel> tempList = [];
      matchingFavoritePersons.clear();
      waitingFavoritePersons.clear();

      _setState(_luvLetterViewState, Loading());
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firebaseFirestore
              .collection(FireStoreCollection.userCollection)
              .doc(uid)
              .collection(FireStoreCollection.userGetFavoritePersonCollection)
              .get();

      QuerySnapshot<Map<String, dynamic>> querySnapshot2 =
          await _firebaseFirestore
              .collection(FireStoreCollection.userCollection)
              .doc(uid)
              .collection(FireStoreCollection.userFavoritePersonCollection)
              .get();

      var temp =
          querySnapshot.docs.map((e) => FavoriteModel.fromFirebase(e)).toList();
      // 전체 get_favorite_person
      _compareAndAddQuerySnapshotData(temp, allGetFavoritePersons);

      var temp2 = querySnapshot2.docs
          .map((e) => FavoriteModel.fromFirebase(e))
          .toList();

      for (var model in temp) {
        if (!model.matchingYn) {
          tempList.add(model);
        }
      }
      // 아직 매칭 안된 get_favorite_person
      _compareAndAddQuerySnapshotData(tempList, myGetFavoritePersons);

      // 매칭된 것들
      for (var model in allGetFavoritePersons) {
        if (model.matchingYn) {
          matchingFavoritePersons.add(model);
        }
      }
      // 내가 호감 보낸 것들
      for (var model in temp2) {
        if (!model.matchingYn) {
          waitingFavoritePersons.add(model);
        }
      }
      // gone 유저들
      for (var model in allGetFavoritePersons) {
        var user = _over3daysFavoriteUser(model, now);
        if (!model.matchingYn && user != null) {
          goneFavoritePersons.add(user);
        }
      }

      _setState(_luvLetterViewState, Loaded());
    } on FirebaseException catch (e) {
      if (e.code == "network-request-failed") {
        _errorState = ErrorState.network;
      }
      var logger = Logger();
      logger.d("error code : ${e.toString()}, ${e.stackTrace}");
    } catch (e) {
      _catchError(e);
    }
  }

  FavoriteModel? _over3daysFavoriteUser(FavoriteModel model, DateTime today) {
    if (model.createdAt!.year - today.year > 0 ||
        model.createdAt!.month - today.month > 0 ||
        model.createdAt!.day - today.day > 3) {
      return model;
    }
    return null;
  }

  Future<bool> checkAleadySendFavoirteMessage({
    required String uid,
    required String targetUid,
  }) async {
    try {
      // _setState(_luvLetterViewState, Loading());
      // DocumentSnapshot documentSnapshot
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firebaseFirestore
              .collection(FireStoreCollection.userCollection)
              .doc(uid)
              .collection(FireStoreCollection.userFavoritePersonCollection)
              // .doc(targetUid)
              .get();
      var temp =
          querySnapshot.docs.map((e) => FavoriteModel.fromFirebase(e)).toList();
      if (temp.isNotEmpty) {
        for (var model in temp) {
          if (model.uid == targetUid) {
            // _setState(_luvLetterViewState, Loaded());
            return true;
          }
        }
        // _setState(_luvLetterViewState, Loaded());
        return false;
      }
      return false;
    } catch (e) {
      _catchError(e);
      return false;
    }
  }

  // 디스커버리 페이지
  Future<void> getRatedPersonsLength({required String uid}) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firebaseFirestore
              .collection(FireStoreCollection.userCollection)
              //.orderby
              .doc(uid)
              .collection(FireStoreCollection.userRatedMeSubCollection)
              .get();
      var temp =
          querySnapshot.docs.map((e) => RatedModel.fromFirebase(e)).toList();
      ratedPersonsLength = temp.length;
    } on FirebaseException catch (e) {
      if (e.code == "network-request-failed") {
        _errorState = ErrorState.network;
      }
      var logger = Logger();
      logger.d("error code : ${e.toString()}, ${e.stackTrace}");
    } catch (e) {
      _catchError(e);
    }
  }

  // 디스커버리 페이지
  Future<void> getRatedPersons({required String uid}) async {
    List<RatedModel> tempList = [];
    ratedPersons.clear();
    try {
      _setState(_profileViewState, Loading());
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firebaseFirestore
              .collection(FireStoreCollection.userCollection)
              .doc(uid)
              .collection(FireStoreCollection.userRatedMeSubCollection)
              .get();
      var temp =
          querySnapshot.docs.map((e) => RatedModel.fromFirebase(e)).toList();
      if (temp.isNotEmpty) {
        for (var e in temp) {
          tempList.add(e);
        }
      }
      ratedPersons.addAll(tempList);
      // if (ratedPersons.isNotEmpty) {
      //   for (var i = 0; i < tempList.length; i++) {
      //     if (!ratingPersons.contains(tempList[i])) {
      //       ratedPersons.add(tempList[i]);
      //     }
      //   }
      // } else {
      //   ratedPersons.addAll(tempList);
      // }
      classifyRatingPoints();
      _setState(_profileViewState, Loaded());
    } on FirebaseException catch (e) {
      if (e.code == "network-request-failed") {
        _errorState = ErrorState.network;
      }
      var logger = Logger();
      logger.d("error code : ${e.toString()}, ${e.stackTrace}");
    } catch (e) {
      _catchError(e);
    }
  }

  void classifyRatingPoints() {
    ratingList['1.0'] = 0.0;
    ratingList['2.0'] = 0.0;
    ratingList['3.0'] = 0.0;
    ratingList['4.0'] = 0.0;
    ratingList['5.0'] = 0.0;
    for (var model in ratedPersons) {
      var num = model.rating;
      switch (num.toInt()) {
        case 1:
          double num = ratingList['1.0']!;
          ratingList['1.0'] = num + 1;
          break;
        case 2:
          double num = ratingList['2.0']!;
          ratingList['2.0'] = num + 1;
          break;
        case 3:
          double num = ratingList['3.0']!;
          ratingList['3.0'] = num + 1;
          break;
        case 4:
          double num = ratingList['4.0']!;
          ratingList['4.0'] = num + 1;
          break;
        case 5:
          double num = ratingList['5.0']!;
          ratingList['5.0'] = num + 1;
          break;
        default:
      }
    }
  }

  // 메인 페이지 진입할 때.
  Future<void> getRatingPersons({
    required String uid,
  }) async {
    _initNum.value = 1;
    List<RatingModel> tempList = [];
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firebaseFirestore
              .collection(FireStoreCollection.userCollection)
              .doc(uid)
              .collection(FireStoreCollection.userRatingSubCollection)
              .get();
      var temp =
          querySnapshot.docs.map((e) => RatingModel.fromFirebase(e)).toList();
      if (temp.isNotEmpty) {
        for (var e in temp) {
          tempList.add(e);
        }
      }
      if (ratingPersons.isNotEmpty) {
        for (var i = 0; i < tempList.length; i++) {
          if (!ratingPersons.contains(tempList[i])) {
            ratingPersons.add(tempList[i]);
          }
        }
      } else {
        ratingPersons.addAll(tempList);
      }
      _initNum.value = 0;
    } on FirebaseException catch (e) {
      if (e.code == "network-request-failed") {
        _errorState = ErrorState.network;
      }
      var logger = Logger();
      logger.d("error code : ${e.toString()}, ${e.stackTrace}");
    } catch (e) {
      _catchError(e);
    }
  }

// 디테일 페이지, 디스커버리에서 평점 남길때
  Future<void> giveRating({
    required String uid,
    required String targetUid,
    required double rating,
    required UserModel user,
    required List<GenderModel> genderList,
  }) async {
    RatingModel ratingModel = RatingModel(targetUid: targetUid, rating: rating);
    RatedModel ratedModel = RatedModel(uid: uid, rating: rating);
    Map<String, Object?> field = {};

    try {
      // user sub collection1
      await _firebaseFirestore
          .collection(FireStoreCollection.userCollection)
          .doc(uid)
          .collection(FireStoreCollection.userRatingSubCollection)
          .doc(targetUid)
          .set(ratingModel.toJson());

      // user sub collection2
      await _firebaseFirestore
          .collection(FireStoreCollection.userCollection)
          .doc(targetUid)
          .collection(FireStoreCollection.userRatedMeSubCollection)
          .doc(uid)
          .set(ratedModel.toJson());

      // user collection
      // gender collection
      String genderCollection = _checkGender(user);
      for (var model in genderList) {
        if (model.uid == targetUid) {
          var tempInt = (model.ratedPersonsLength ?? 0) + 1;
          field['ratedPersonsLength'] = tempInt;
          field['rating'] = model.rating! + rating;
          await _firebaseFirestore
              .collection(genderCollection)
              .doc(targetUid)
              .update(field);

          await _firebaseFirestore
              .collection(FireStoreCollection.userCollection)
              .doc(targetUid)
              .update(field);
          break;
        }
      }
    } on FirebaseException catch (e) {
      if (e.code == "network-request-failed") {
        _errorState = ErrorState.network;
      }
      var logger = Logger();
      logger.d("error code : ${e.toString()}, ${e.stackTrace}");
    } catch (e) {
      _catchError(e);
    }
  }

  void _compareAndAddQuerySnapshotData(
      List<dynamic> temp, RxList<dynamic> rxList) {
    List<FavoriteModel> tempList = [];
    if (temp.isNotEmpty) {
      for (var model in temp) {
        tempList.add(model);
      }
    }
    if (rxList.isNotEmpty) {
      for (var model in tempList) {
        if (!rxList.contains(model)) {
          rxList.add(model);
        }
      }
    } else {
      rxList.addAll(tempList);
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
  //? 유저들이 평가한 평점은 특정타이밍에 한번에 반영하기

  String _checkGender(UserModel userModel) => userModel.gender == "남"
      ? FireStoreCollection.womanCollection
      : FireStoreCollection.manCollection;
}
