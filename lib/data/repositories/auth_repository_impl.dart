import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:logger/logger.dart';
import 'package:salondec/core/define.dart';
import 'package:salondec/data/model/user_model.dart';

// 우선은 분리하지말자..
class AuthRepositoryImpl {
  // final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  // final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  // final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  // // AuthRepositoryImpl({
  // //   required firebaseAuth,
  // //   required firebaseFirestore,
  // //   required firebaseStorage,
  // // }) {
  // //   _firebaseAuth = firebaseAuth;
  // //   _firebaseFirestore = firebaseFirestore;
  // //   _firebaseStorage = firebaseStorage;
  // // }

  // Future<UserModel> signUpWithEmail(
  //     {required String email,
  //     required String password,
  //     required String name,
  //     required String group}) async {
  //   try {
  //     UserCredential _userCredential = await _firebaseAuth
  //         .createUserWithEmailAndPassword(email: email, password: password);

  //     UserModel userModel = UserModel(
  //         id: _userCredential.user?.uid ?? "",
  //         email: _userCredential.user?.email ?? "",
  //         name: name,
  //         group: group);

  //     _firebaseFirestore
  //         .collection(userCollectionName)
  //         .doc(userModel.id)
  //         .set(userModel.toJson());

  //     return userModel;
  //   } on FirebaseAuthException catch (e) {
  //     var logger = Logger();
  //     logger.d("error code : ${e.code}");
  //   } catch (e) {
  //     var logger = Logger();
  //     logger.d("error code : ${e.toString()}");
  //   }

  // }
}
