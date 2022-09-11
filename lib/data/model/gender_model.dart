import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import 'package:salondec/data/model/user_model.dart';

// ignore: must_be_immutable
class GenderModel extends Equatable {
  late String uid;
  late int? age;
  late int? height;
  late int? ratedPersonsLength;
  late double? rating;
  late String? imgUrl1;
  late String? imgUrl2;
  late String? imgUrl3;
  late String? name;
  late String? job;
  late String? religion;
  late String? mbti;
  late String? bodytype;
  late String? introduction;
  late String? character;
  late String? interest;
  late String? profileImageUrl;

  GenderModel({
    required this.uid,
    this.age,
    this.height,
    this.ratedPersonsLength,
    this.rating,
    this.imgUrl1,
    this.imgUrl2,
    this.imgUrl3,
    this.name,
    this.job,
    this.religion,
    this.mbti,
    this.bodytype,
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
        'height': (height == null || height == 0) ? userModel.height : height,
        'ratedPersonsLength': (ratedPersonsLength == null)
            // ? userModel.ratedPersonsLength
            ? 1
            : (ratedPersonsLength!),
        'rating': (rating == null) ? userModel.rating : rating,
        'imgUrl1':
            (imgUrl1 == null || imgUrl1 == '') ? userModel.imgUrl1 : imgUrl1,
        'imgUrl2':
            (imgUrl2 == null || imgUrl2 == '') ? userModel.imgUrl2 : imgUrl2,
        'imgUrl3':
            (imgUrl3 == null || imgUrl3 == '') ? userModel.imgUrl3 : imgUrl3,
        'name': (name == null || name == '') ? userModel.name : name,
        'religion': (religion == null || religion == '')
            ? userModel.religion
            : religion,
        'mbti': (mbti == null || mbti == '') ? userModel.mbti : mbti,
        'bodytype': (bodytype == null || bodytype == '')
            ? userModel.bodytype
            : bodytype,
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
    return {
      'uid': uid,
      'age': age ?? 0,
      'height': height ?? 0,
      'ratedPersonsLength': ratedPersonsLength ?? 0,
      'rating': rating ?? 0.0,
      'imgUrl1': imgUrl1 ?? "",
      'imgUrl2': imgUrl2 ?? "",
      'imgUrl3': imgUrl3 ?? "",
      'name': name ?? "",
      'job': job ?? "",
      'religion': religion ?? "",
      'mbti': mbti ?? "",
      'bodytype': bodytype ?? "",
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

// rating 계산
  static double resultRating(double rating, int num) =>
      num != 0 ? double.parse((rating / num).toStringAsFixed(1)) : rating;

  factory GenderModel.fromFirebase(DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> json = documentSnapshot.data() as Map<String, dynamic>;
    double temp = 0;
    if (json['rating'] is int) {
      int rating = json['rating'];
      temp = rating.toDouble();
    }

    GenderModel genderModel = GenderModel(
      uid: documentSnapshot.id,
      age: json['age'] ?? 0,
      height: json['height'] ?? 0,
      ratedPersonsLength: json['ratedPersonsLength'] ?? 0,
      // rating: resultRating(json['rating'] is int ? temp : json['rating'],
      //     json['ratedPersonsLength']),
      rating: resultRating(
          json['rating'] is int ? temp : (json['rating'] ?? 0.0),
          (json['ratedPersonsLength'] ?? 0)),
      imgUrl1: json['imgUrl1'] ?? "",
      imgUrl2: json['imgUrl2'] ?? "",
      imgUrl3: json['imgUrl3'] ?? "",
      name: json['name'] ?? "",
      job: json['job'] ?? "",
      religion: json['religion'] ?? "",
      mbti: json['mbti'] ?? "",
      bodytype: json['bodytype'] ?? "",
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
      age ?? 0,
      height ?? 0,
      ratedPersonsLength ?? 0,
      rating ?? 0.0,
      imgUrl1 ?? "",
      imgUrl2 ?? "",
      imgUrl3 ?? "",
      name ?? "",
      job ?? "",
      religion ?? "",
      mbti ?? "",
      bodytype ?? "",
      introduction ?? "",
      character ?? "",
      interest ?? "",
      profileImageUrl ?? "",
    ];
  }

  GenderModel copyWith({
    String? uid,
    int? age,
    int? height,
    int? ratedPersonsLength,
    double? rating,
    String? imgUrl1,
    String? imgUrl2,
    String? imgUrl3,
    String? name,
    String? job,
    String? religion,
    String? mbti,
    String? bodytype,
    String? introduction,
    String? character,
    String? interest,
    String? profileImageUrl,
  }) {
    return GenderModel(
      uid: uid ?? this.uid,
      age: age ?? this.age,
      height: height ?? this.height,
      ratedPersonsLength: ratedPersonsLength ?? this.ratedPersonsLength,
      rating: rating ?? this.rating,
      imgUrl1: imgUrl1 ?? this.imgUrl1,
      imgUrl2: imgUrl2 ?? this.imgUrl2,
      imgUrl3: imgUrl3 ?? this.imgUrl3,
      name: name ?? this.name,
      job: job ?? this.job,
      religion: religion ?? this.religion,
      mbti: mbti ?? this.mbti,
      bodytype: bodytype ?? this.bodytype,
      introduction: introduction ?? this.introduction,
      character: character ?? this.character,
      interest: interest ?? this.interest,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }
}
