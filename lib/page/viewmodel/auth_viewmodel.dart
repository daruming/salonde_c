import 'dart:io';

// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
// import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import 'package:salondec/core/define.dart';
import 'package:salondec/core/viewState.dart';
import 'package:salondec/data/model/gender_model.dart';
import 'package:salondec/data/model/user_model.dart';
import 'package:salondec/data/repositories/auth_repository_impl.dart';

// enum ErrorState { network, fail, none }

class AuthViewModel extends GetxController {
  late AuthRepositoryImpl _authRepository;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  // AuthViewModel({required AuthRepositoryImpl authRepository}) {
  //   _authRepository = authRepository;
  // }

  //Firebase통해서 들어오는 유저 데이터
  final Rxn<User?> _user = Rxn(null);
  User? get user => _user.value;

  RxBool userSignUpState = false.obs;

  final Rxn<ViewState> _homeViewState = Rxn(Initial());
  ViewState get homeViewState => _homeViewState.value!;

//test 후 삭제
  final Rxn<ViewState> _signUpViewState = Rxn(Initial());
  ViewState get signUpViewState => _signUpViewState.value!;
  final Rxn<ViewState> _signInViewState = Rxn(Initial());
  ViewState get signInViewState => _signInViewState.value!;

  final Rxn<ViewState> _discoveryViewState = Rxn(Initial());
  ViewState get discoveryViewState => _discoveryViewState.value!;

  Rxn<UserModel> userModel = Rxn();

  ErrorState _errorState = ErrorState.none;
  ErrorState get errorState => _errorState;
  // UserModel? get userModel => _userModel.value;
  // set userModel(UserModel? user) => _userModel.value = user;
  // RxList<UserModel> userModelList = <UserModel>[].obs;
  // final Rxn<UserModel> _user = Rxn<UserModel>();
  // UserModel? get user => _user.value;
  String gender = '남';
  String imageUrl = '';
  // final GetStorage _storage = GetStorage();
  // final storage = FlutterSecureStorage();
  Map<String, File> photoMap = {};
  Map<String, String> downloadUrlMap = {};
  Map<String, Reference> referenceMap = {};
  RxList<GenderModel> genderModelList = <GenderModel>[].obs;
  RxList<GenderModel> genderModelListUnderFivePeople = <GenderModel>[].obs;
  // RxList<UserModel> userModelListUnderFivePeople = <UserModel>[].obs;
  Rxn<UserModel> userModelUnderFivePeople = Rxn(null);

  RxInt _initNum = 0.obs;
  int get initNum => _initNum.value;

  _currentUser() {
    if (_firebaseAuth.currentUser != null) {
      _user.value = _firebaseAuth.currentUser!;
      return;
    }
  }

  _deleteAll() {
    photoMap.clear();
    downloadUrlMap.clear();
    referenceMap.clear();
    genderModelList.clear();
    _user.value = null;
    // userModel.value = null;
    userModel = Rxn();
    _setState(_homeViewState, Initial());
    _errorState = ErrorState.none;
  }

  Future<void> init() async {
    _initNum.value = 1;
    genderModelList.value = [];
    userSignUpState.value = false;
    print(userModel);
    _currentUser();
    await getUserInfo();
    await getMainPageInfo(uid: user!.uid, gender: userModel.value!.gender);
  }

  // sign up 은 우선 이메일, 비번으로 아디 만들고
  // 성별을 넣어놓기. 나머지 데이터들은 프로필페이지에서 수정누르면 작동하도록. 가입할때 All_users에도 같이 들어가야함.
  // 프로필 페이지에서 내용을 입력하면 User, All_users 에도 같이 들어가야함. -> man, woman 으로 수정
  Future<bool> signUpWithEmail({
    required String email,
    required String password,
    required String gender,
  }) async {
    try {
      _setState(_signUpViewState, Loading());

      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      UserModel userModelTemp = UserModel(
        uid: userCredential.user?.uid ?? "",
        email: userCredential.user?.email ?? "",
        gender: gender,
      );
      GenderModel genderModel = GenderModel(
        uid: userCredential.user?.uid ?? "",
      );

      await _firebaseFirestore
          .collection(FireStoreCollection.userCollection)
          .doc(userModelTemp.uid)
          .set(userModelTemp.toJson());
      if (gender == "남") {
        await _firebaseFirestore
            .collection(FireStoreCollection.manCollection)
            .doc(userModelTemp.uid)
            .set(genderModel.toJson());
      } else {
        await _firebaseFirestore
            .collection(FireStoreCollection.womanCollection)
            .doc(userModelTemp.uid)
            .set(genderModel.toJson());
      }
      userModel.value = userModelTemp;
      _user.value = userCredential.user;
      // storage.write(key: "uid", value: userCredential.user!.uid);
      _setState(_signUpViewState, Loaded());

      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == "network-request-failed") {
        _errorState = ErrorState.network;
      }
      var logger = Logger();
      logger.d("error code : ${e.code}");
      return false;
    } catch (e) {
      if (e is Error) {
        var logger = Logger();
        logger.d("error code : ${e.toString()}, ${e.stackTrace}");
        return false;
      }
      var logger = Logger();
      logger.d("error code : ${e.toString()}");
      return false;
    }
  }

  Future<void> signInWithEmail(
      {required String email, required String password}) async {
    try {
      _setState(_signInViewState, Loading());

      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      _user.value = userCredential.user;
      // storage.write(key: "uid", value: userCredential.user!.uid);
      _setState(_signInViewState, Loaded());
    } on FirebaseAuthException catch (e) {
      if (e.code == "network-request-failed") {
        _errorState = ErrorState.network;
      }
      var logger = Logger();
      logger.d("error code : ${e.toString()}, ${e.stackTrace}");
    } catch (e) {
      _catchError(e);
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      _deleteAll();
    } on FirebaseAuthException catch (e) {
      if (e.code == "network-request-failed") {
        _errorState = ErrorState.network;
      }
      _catchError(e);
    } catch (e) {
      _catchError(e);
    }
  }

  Future<void> uploadUpdateImages(
      // {required List<String> urlList, required File photo}) async {
      {required Map<String, File> photoMap}) async {
    try {
      if (photoMap.isNotEmpty) {
        // var piterator = photoMap.keys.iterator;
        // for (var i = 0; i < photoMap.length; piterator., i++) {
        //   print("piterator.current ${piterator.current.toString()}");
        // }
        // List<String> test = [];
        // test.add(photoMap.keys.iterator.current);
        // print("object $test");

        for (var mapKey in photoMap.keys) {
          final firebaseStorageRef = _firebaseStorage
              .ref()
              .child('users')
              .child('${DateTime.now().millisecondsSinceEpoch}.png');
          referenceMap[mapKey] = firebaseStorageRef;
          // var test  = await firebaseStorageRef.putFile(
          await firebaseStorageRef.putFile(
              photoMap[mapKey]!, SettableMetadata(contentType: 'image/png'));
          // photoFile, SettableMetadata(contentType: 'image/png'));
        }
        // photoMap.forEach((key, photoFile) async {
        //     .whenComplete(() async {
        //   downloadUrlMap[key] = await firebaseStorageRef.getDownloadURL();
        // });
        // test.ref.fullPath
        // downloadUrlMap[key] = await firebaseStorageRef.getDownloadURL();
        // });
        // updateImagesInfo(downloadUrlMap: downloadUrlMap);
      }
    } on FirebaseException catch (e) {
      if (e.code == "network-request-failed") {
        _errorState = ErrorState.network;
      }
      _catchError(e);
    } catch (e) {
      _catchError(e);
    }
  }

  Future<void> getDownloadURLs() async {
    for (var mapKey in referenceMap.keys) {
      downloadUrlMap[mapKey] = await referenceMap[mapKey]!.getDownloadURL();
    }
    // referenceMap.forEach((key, e) async {
    //   downloadUrlMap[key] = await e.getDownloadURL();
    // });
    // if (referenceMap.length != referenceMap.length) {
    //   await getDownloadURLs();
    // }
  }

  // Future<void> updateImagesInfo(
  //     {required Map<String, String> downloadUrlMap}) async {
  //   try {
  //     String genderCollection = _checkGender(_userModel.value!);
  //     GenderModel genderModel = GenderModel(
  //       uid: _userModel.value!.uid,
  //       imgUrl1: downloadUrlMap['imgUrl1'],
  //       imgUrl2: downloadUrlMap['imgUrl2'],
  //       imgUrl3: downloadUrlMap['imgUrl3'],
  //     );
  //     UserModel userModel = UserModel(
  //       uid: _userModel.value!.uid,
  //       email: _userModel.value!.email,
  //       gender: _userModel.value!.gender,
  //       imgUrl1: downloadUrlMap['imgUrl1'],
  //       imgUrl2: downloadUrlMap['imgUrl2'],
  //       imgUrl3: downloadUrlMap['imgUrl3'],
  //     );
  //     await _firebaseFirestore
  //         .collection(FireStoreCollection.userCollection)
  //         .doc(userModel.uid)
  //         .set(userModel.toUpdateJson());

  //     await _firebaseFirestore
  //         .collection(genderCollection)
  //         .doc(genderModel.uid)
  //         .set(genderModel.toUpdateJson());
  //   } catch (e) {
  //     _catchError(e);
  //   }
  // }

  Future<void> updateUserInfo({required UserModel userModelTemp}) async {
    // Future<void> updateUserInfo() async {
    String genderCollection = _checkSelfGender(userModel.value!);
    if (downloadUrlMap.isNotEmpty) {
      userModelTemp.imgUrl1 = downloadUrlMap['imgUrl1'];
      userModelTemp.imgUrl2 = downloadUrlMap['imgUrl2'];
      userModelTemp.imgUrl3 = downloadUrlMap['imgUrl3'];
      userModelTemp.profileImageUrl = downloadUrlMap['profileImageUrl'];
    }
    GenderModel genderModel = GenderModel(
      uid: userModel.value!.uid,
      age: userModelTemp.age,
      name: userModelTemp.name,
      mbti: userModelTemp.mbti,
      job: userModelTemp.job,
      imgUrl1: downloadUrlMap['imgUrl1'],
      imgUrl2: downloadUrlMap['imgUrl2'],
      imgUrl3: downloadUrlMap['imgUrl3'],
      introduction: userModelTemp.introduction,
      character: userModelTemp.character,
      interest: userModelTemp.interest,
      profileImageUrl: downloadUrlMap['profileImageUrl'],
      // imgUrl1: userModel.imgUrl1,
      // imgUrl2: userModel.imgUrl2,
      // imgUrl3: userModel.imgUrl3,
    );
    try {
      // UserModel userModel = userModel;
      await _firebaseFirestore
          .collection(FireStoreCollection.userCollection)
          .doc(userModel.value!.uid)
          .update(userModelTemp.toJson(userModel: userModel.value));
      // .update(userModel.value!.toUpdateJson());

      await _firebaseFirestore
          .collection(genderCollection)
          .doc(genderModel.uid)
          .update(genderModel.toJson(userModel: userModel.value));
      // .update(genderModel.toUpdateJson());
      downloadUrlMap.clear();
      photoMap.clear();
    } catch (e) {
      _catchError(e);
    }
  }

  Future<void> getDiscoveryUserInfo({
    required String uid,
  }) async {
    try {
      _setState(_discoveryViewState, Loading());
      DocumentSnapshot documentSnapshot = await _firebaseFirestore
          .collection(FireStoreCollection.userCollection)
          .doc(uid)
          .get();

      if (documentSnapshot.data() != null) {
        UserModel temp = UserModel.fromFirebase(documentSnapshot);
        if (checkImgUrlNum(userModel: temp) > 1) {
          userModelUnderFivePeople.value = temp;
        }
        _setState(_discoveryViewState, Loaded());
      }
    } catch (e) {
      _catchError(e);
    }
  }

  Future<void> getUserInfo(
      // required String uid,
      ) async {
    // currentUser();
    try {
      DocumentSnapshot documentSnapshot = await _firebaseFirestore
          .collection(FireStoreCollection.userCollection)
          .doc(_user.value!.uid)
          .get();

      if (documentSnapshot.data() != null) {
        UserModel tempModel = UserModel.fromFirebase(documentSnapshot);
        _setModel(userModel, tempModel);
        // userModel.value = tempModel;
        gender = userModel.value?.gender ?? "";
      }
    } catch (e) {
      _catchError(e);
    }
  }

  Future<void> getMainPageInfo(
      {required String uid, required String gender}) async {
    String genderCollection = _checkGender(userModel.value!);
    genderModelList.clear();
    _setState(_homeViewState, Loading());
    List<GenderModel> tempList = [];
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firebaseFirestore.collection(genderCollection).get();

      var temp =
          querySnapshot.docs.map((e) => GenderModel.fromFirebase(e)).toList();
      if (temp.isNotEmpty) {
        for (var e in temp) {
          // if (e.imgUrl1 != null && e.imgUrl1 != '') {
          if (checkImgUrlNum(genderModel: e) > 1) {
            // genderModelList.add(e);
            tempList.add(e);
          }
        }
        if (genderModelList.isNotEmpty) {
          for (var model in tempList) {
            if (!genderModelList.contains(model)) {
              genderModelList.add(model);
              if (model.ratedPersonsLength! < 5) {
                genderModelListUnderFivePeople.add(model);
              }
            }
          }
        } else {
          genderModelList.addAll(tempList);
          for (var model in tempList) {
            if (model.ratedPersonsLength! < 5) {
              genderModelListUnderFivePeople.add(model);
            }
          }
        }
      }

      _setState(_homeViewState, Loaded());
      _initNum.value = 0;
    } catch (e) {
      _catchError(e);
    }
  }

  Future<void> setProfileImage(
      {required String uid, required File image}) async {
    try {
      var fileName = "$uid.jpeg";
      TaskSnapshot result = await _firebaseStorage
          .ref()
          .child("profile/$fileName")
          .putFile(image);
      imageUrl = await result.ref.getDownloadURL();

      await _firebaseFirestore
          .collection(FireStoreCollection.userCollection)
          .doc(uid)
          .update({
        'profile_image_url': imageUrl,
      });
      // return imageUrl;
    } catch (e) {
      var logger = Logger();
      logger.d("error code : ${e.toString()}");
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

  String _checkGender(UserModel userModel) => userModel.gender == "남"
      ? FireStoreCollection.womanCollection
      : FireStoreCollection.manCollection;
  String _checkSelfGender(UserModel userModel) => userModel.gender == "남"
      ? FireStoreCollection.manCollection
      : FireStoreCollection.womanCollection;

  void _setModel(Rxn<UserModel> userModel, UserModel model) =>
      userModel.value = model;
  void _setState(Rxn<ViewState> state, ViewState nextState) =>
      state.value = nextState;

  bool checkImgUrl(String? url) {
    return (url != null && url != '') ? true : false;
  }

  int checkImgUrlNum({GenderModel? genderModel, UserModel? userModel}) {
    var model;

    if (genderModel != null) {
      model = genderModel;
    } else {
      model = userModel;
    }

    var num = 0;
    if (checkImgUrl(model.profileImageUrl)) {
      num += 1;
    }
    if (checkImgUrl(model.imgUrl1)) {
      num += 1;
    }
    if (checkImgUrl(model.imgUrl2)) {
      num += 1;
    }
    if (checkImgUrl(model.imgUrl3)) {
      num += 1;
    }
    return num;
  }
}
