import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import 'package:salondec/core/core.dart';

class UserModel extends Core with EquatableMixin {
  late String uid;
  late String email;
  late String gender;
  late String? name;
  late int? age;
  late int? height;
  late int? ratedPersonsLength;
  late double? rating;
  late String? job;
  late String? religion;
  late String? mbti;
  late String? bodytype;
  late String? introduction;
  late String? profileImageUrl;
  late String? character;
  late String? interest;
  late String? imgUrl1;
  late String? imgUrl2;
  late String? imgUrl3;

  UserModel({
    required this.uid,
    required this.email,
    // this.isActivate = true,
    required this.gender,
    this.name,
    this.age,
    this.height,
    this.ratedPersonsLength,
    this.rating,
    this.job,
    this.religion,
    this.mbti,
    this.bodytype,
    this.introduction,
    this.profileImageUrl,
    this.character,
    this.interest,
    this.imgUrl1,
    this.imgUrl2,
    this.imgUrl3,
  }) : super(DateTime.now(), DateTime.now());

  // Map<String, dynamic> toJson() {
  //   return {
  //     'id': id,
  //     'email': email,
  //     'name': name,
  //     'job': job,
  //     'profileImageUrl': profileImageUrl,
  //   };
  // }
  Map<String, dynamic> toJson({UserModel? userModel}) {
    if (userModel != null) {
      return {
        'id': uid,
        'email': email,
        'gender': gender,
        'name': (name == null || name == '') ? userModel.name : name,
        'age': (age == null || age == 0) ? userModel.age : age,
        'height': (height == null || height == 0) ? userModel.height : height,
        'ratedPersonsLength': (ratedPersonsLength == null)
            ? userModel.ratedPersonsLength
            : (ratedPersonsLength!),
        'rating': (rating == null) ? userModel.rating : rating,
        'job': (job == null || job == '') ? userModel.job : job,
        'religion': (religion == null || religion == '')
            ? userModel.religion
            : religion,
        'mbti': (mbti == null || mbti == '') ? userModel.mbti : mbti,
        'bodytype': (bodytype == null || bodytype == '')
            ? userModel.bodytype
            : bodytype,
        'introduction': (introduction == null || introduction == '')
            ? userModel.introduction
            : introduction,
        'profileImageUrl': (profileImageUrl == null || profileImageUrl == '')
            ? userModel.profileImageUrl
            : profileImageUrl,
        'character': (character == null || character == '')
            ? userModel.character
            : character,
        'interest': (interest == null || interest == '')
            ? userModel.interest
            : interest,
        'imgUrl1':
            (imgUrl1 == null || imgUrl1 == '') ? userModel.imgUrl1 : imgUrl1,
        'imgUrl2':
            (imgUrl2 == null || imgUrl2 == '') ? userModel.imgUrl2 : imgUrl2,
        'imgUrl3':
            (imgUrl3 == null || imgUrl3 == '') ? userModel.imgUrl3 : imgUrl3,
        'created_at': userModel.createdAt,
        'updated_at': updatedAt,
      };
    }
    return {
      'id': uid,
      'email': email,
      'gender': gender,
      'name': name ?? "",
      'age': age ?? 0,
      'height': height ?? 0,
      'ratedPersonsLength': ratedPersonsLength ?? 0,
      'rating': rating ?? 0.0,
      'job': job ?? "",
      'religion': religion ?? "",
      'mbti': mbti ?? "",
      'bodytype': bodytype ?? "",
      'introduction': introduction ?? "",
      'profileImageUrl': profileImageUrl ?? "",
      'character': character ?? "",
      'interest': interest ?? "",
      'imgUrl1': imgUrl1 ?? "",
      'imgUrl2': imgUrl2 ?? "",
      'imgUrl3': imgUrl3 ?? "",
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  // Map<String, Object?> toUpdateJson() {
  //   Map<String, Object?> result = toJson();
  //   result.removeWhere((key, value) {
  //     // if (key == "created_at") {
  //     //   return true;
  //     // }
  //     return value == null; // 사진, 기본정보 등의 내용들 빈값으로 업뎃못하도록.
  //     // return false;
  //   });
  //   return result;
  // }

// rating 계산
  static double resultRating(double rating, int num) =>
      num != 0 ? double.parse((rating / num).toStringAsFixed(1)) : rating;

  factory UserModel.fromFirebase(DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> json = documentSnapshot.data() as Map<String, dynamic>;
    double temp = 0;
    if (json['rating'] is int) {
      int rating = json['rating'];
      temp = rating.toDouble();
    }
    UserModel userModel = UserModel(
      uid: documentSnapshot.id,
      email: json['email'],
      gender: json['gender'],
      name: json['name'],
      age: json['age'],
      height: json['height'],
      ratedPersonsLength: json['ratedPersonsLength'] ?? 0,
      // rating: json['rating'] is int ? temp : json['rating'],
      rating: resultRating(
          json['rating'] is int ? temp : (json['rating'] ?? 0.0),
          (json['ratedPersonsLength'] ?? 0)),
      job: json['job'],
      religion: json['religion'],
      mbti: json['mbti'],
      bodytype: json['bodytype'],
      introduction: json['introduction'],
      profileImageUrl: json['profileImageUrl'],
      character: json['character'],
      interest: json['interest'],
      imgUrl1: json['imgUrl1'],
      imgUrl2: json['imgUrl2'],
      imgUrl3: json['imgUrl3'],
    );
    userModel.createdAt = (json['created_at'] as Timestamp).toDate();
    userModel.updatedAt = (json['updated_at'] as Timestamp).toDate();

    return userModel;
  }

  @override
  List<Object> get props {
    return [
      uid,
      email,
      gender,
      name ?? "",
      age ?? 0,
      height ?? 0,
      ratedPersonsLength ?? 0,
      rating ?? 0.0,
      job ?? "",
      religion ?? "",
      mbti ?? "",
      bodytype ?? "",
      introduction ?? "",
      profileImageUrl ?? "",
      character ?? "",
      interest ?? "",
      imgUrl1 ?? "",
      imgUrl2 ?? "",
      imgUrl3 ?? "",
    ];
  }

  UserModel copyWith({
    String? uid,
    String? email,
    String? gender,
    String? name,
    int? age,
    int? height,
    int? ratedPersonsLength,
    double? rating,
    String? job,
    String? religion,
    String? mbti,
    String? bodytype,
    String? introduction,
    String? profileImageUrl,
    String? character,
    String? interest,
    String? imgUrl1,
    String? imgUrl2,
    String? imgUrl3,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      name: name ?? this.name,
      age: age ?? this.age,
      height: height ?? this.height,
      ratedPersonsLength: ratedPersonsLength ?? this.ratedPersonsLength,
      rating: rating ?? this.rating,
      job: job ?? this.job,
      religion: religion ?? this.religion,
      mbti: mbti ?? this.mbti,
      bodytype: bodytype ?? this.bodytype,
      introduction: introduction ?? this.introduction,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      character: character ?? this.character,
      interest: interest ?? this.interest,
      imgUrl1: imgUrl1 ?? this.imgUrl1,
      imgUrl2: imgUrl2 ?? this.imgUrl2,
      imgUrl3: imgUrl3 ?? this.imgUrl3,
    );
  }
}

class CoinModel extends Core {
  String uid;
  int coins;
  CoinModel({
    required this.uid,
    required this.coins,
  }) : super(DateTime.now(), DateTime.now());

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'coins': coins,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  factory CoinModel.fromFirebase(DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> json = documentSnapshot.data() as Map<String, dynamic>;

    CoinModel coinModel = CoinModel(
      uid: json['uid'] ?? '',
      coins: json['coins']?.toInt() ?? 0,
    );

    coinModel.createdAt = (json['created_at'] as Timestamp).toDate();
    coinModel.updatedAt = (json['updated_at'] as Timestamp).toDate();

    return coinModel;
  }

  // String toJson() => json.encode(toMap());
  // factory CoinModel.fromJson(String source) => CoinModel.fromMap(json.decode(source));
}
