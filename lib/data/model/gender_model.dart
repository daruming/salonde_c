import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
<<<<<<< HEAD
import 'package:equatable/equatable.dart';

import 'package:salondec/data/model/user_model.dart';

class GenderModel extends Equatable {
=======

class GenderModel {
>>>>>>> 8239899606af8655f2c3ae272f42ae6154d99f2b
  late String uid;
  late int? age;
  late String? imgUrl1;
  late String? imgUrl2;
  late String? imgUrl3;
  late String? name;
  late String? mbti;
  late String? job;
<<<<<<< HEAD
  late String? introduction;
  late String? character;
  late String? interest;
  late String? profileImageUrl;

=======
>>>>>>> 8239899606af8655f2c3ae272f42ae6154d99f2b
  GenderModel({
    required this.uid,
    this.age,
    this.imgUrl1,
    this.imgUrl2,
    this.imgUrl3,
    this.name,
    this.mbti,
    this.job,
<<<<<<< HEAD
    this.introduction,
    this.character,
    this.interest,
    this.profileImageUrl,
  });

  Map<String, dynamic> toJson({UserModel? userModel}) {
    if (userModel != null) {
      return {
        'uid': uid,
        'age': (age == null || age == 0) ? userModel.age : age,
        'imgUrl1':
            (imgUrl1 == null || imgUrl1 == '') ? userModel.imgUrl1 : imgUrl1,
        'imgUrl2':
            (imgUrl2 == null || imgUrl2 == '') ? userModel.imgUrl2 : imgUrl2,
        'imgUrl3':
            (imgUrl3 == null || imgUrl3 == '') ? userModel.imgUrl3 : imgUrl3,
        'name': (name == null || name == '') ? userModel.name : name,
        'mbti': (mbti == null || mbti == '') ? userModel.mbti : mbti,
        'job': (job == null || job == '') ? userModel.job : job,
        'introduction': (introduction == null || introduction == '')
            ? userModel.introduction
            : introduction,
        'character': (character == null || character == '')
            ? userModel.character
            : character,
        'interest': (interest == null || interest == '')
            ? userModel.interest
            : interest,
        'profileImageUrl': (profileImageUrl == null || profileImageUrl == '')
            ? userModel.profileImageUrl
            : profileImageUrl,
      };
    }
=======
  });

  Map<String, dynamic> toJson() {
>>>>>>> 8239899606af8655f2c3ae272f42ae6154d99f2b
    return {
      'uid': uid,
      'age': age ?? 0,
      'imgUrl1': imgUrl1 ?? "",
      'imgUrl2': imgUrl2 ?? "",
      'imgUrl3': imgUrl3 ?? "",
      'name': name ?? "",
      'mbti': mbti ?? "",
      'job': job ?? "",
<<<<<<< HEAD
      'introduction': introduction ?? "",
      'character': character ?? "",
      'interest': interest ?? "",
      'profileImageUrl': profileImageUrl ?? "",
    };
  }

  // Map<String, Object?> toUpdateJson() {
  //   Map<String, Object?> result = toJson();
  //   result.removeWhere((key, value) {
  //     return value == null; // 사진, 기본정보 등의 내용들 빈값으로 업뎃못하도록.
  //     // return false;
  //   });
  //   return result;
  // }

=======
    };
  }

>>>>>>> 8239899606af8655f2c3ae272f42ae6154d99f2b
  factory GenderModel.fromFirebase(DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> json = documentSnapshot.data() as Map<String, dynamic>;
    GenderModel genderModel = GenderModel(
      uid: documentSnapshot.id,
<<<<<<< HEAD
      age: json['age'] ?? 0,
      imgUrl1: json['imgUrl1'] ?? "",
      imgUrl2: json['imgUrl2'] ?? "",
      imgUrl3: json['imgUrl3'] ?? "",
      name: json['name'] ?? "",
      mbti: json['mbti'] ?? "",
      job: json['job'] ?? "",
      introduction: json['introduction'] ?? "",
      character: json['character'] ?? "",
      interest: json['interest'] ?? "",
      profileImageUrl: json['profileImageUrl'] ?? "",
    );
    return genderModel;
  }

  @override
  List<Object> get props {
    return [
      uid,
      age!,
      imgUrl1!,
      imgUrl2!,
      imgUrl3!,
      name!,
      mbti!,
      job!,
      introduction!,
      character!,
      interest!,
      profileImageUrl!,
    ];
  }
=======
      age: json['age'],
      imgUrl1: json['imgUrl1'],
      imgUrl2: json['imgUrl2'],
      imgUrl3: json['imgUrl3'],
      name: json['name'],
      mbti: json['mbti'],
      job: json['job'],
    );
    return genderModel;
  }
>>>>>>> 8239899606af8655f2c3ae272f42ae6154d99f2b
}
