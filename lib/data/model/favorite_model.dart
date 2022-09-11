import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import 'package:salondec/core/core.dart';

class FavoriteModel extends Core with EquatableMixin {
  late String uid;
  double? rating;
  String? name;
  String? message;
  String? profileImageUrl;
  bool matchingYn = false;

  FavoriteModel({
    required this.uid,
    required this.name,
    required this.rating,
    required this.message,
    required this.profileImageUrl,
    required this.matchingYn,
  }) : super(DateTime.now(), DateTime.now());

  Map<String, dynamic> toJson({FavoriteModel? favoriteModel}) {
    if (favoriteModel != null) {
      return {
        'uid': uid,
        'rating':
            (rating == null || rating == 0) ? favoriteModel.rating : rating,
        'name': (name == null || name == '') ? favoriteModel.name : name,
        'message': (message == null || message == '')
            ? favoriteModel.message
            : message,
        'profileImageUrl': (profileImageUrl == null || profileImageUrl == '')
            ? favoriteModel.profileImageUrl
            : profileImageUrl,
        'matchingYn': matchingYn,
        'created_at': favoriteModel.createdAt,
        'updated_at': updatedAt,
      };
    }
    return {
      'uid': uid,
      'name': name ?? "",
      'rating': rating ?? 0.0,
      'message': message ?? "",
      'profileImageUrl': profileImageUrl ?? "",
      'matchingYn': matchingYn,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  factory FavoriteModel.fromFirebase(DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> json = documentSnapshot.data() as Map<String, dynamic>;
    double temp = 0;
    if (json['rating'] is int) {
      int rating = json['rating'];
      temp = rating.toDouble();
    }
    FavoriteModel favoriteModel = FavoriteModel(
      uid: json['uid'],
      name: json['name'] ?? "",
      rating: json['rating'] is int ? temp : json['rating'],
      message: json['message'] ?? "",
      profileImageUrl: json['profileImageUrl'] ?? "",
      matchingYn: json['matchingYn'] ?? false,
    );

    favoriteModel.createdAt = (json['created_at'] as Timestamp).toDate();
    favoriteModel.updatedAt = (json['updated_at'] as Timestamp).toDate();

    return favoriteModel;
  }

  @override
  List<Object> get props => [
        uid,
        rating ?? 0.0,
        name ?? "",
        message ?? "",
        profileImageUrl ?? "",
        matchingYn
      ];

  FavoriteModel copyWith({
    String? uid,
    double? rating,
    String? name,
    String? message,
    String? profileImageUrl,
    bool? matchingYn,
  }) {
    return FavoriteModel(
      uid: uid ?? this.uid,
      rating: rating ?? this.rating,
      name: name ?? this.name,
      message: message ?? this.message,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      matchingYn: matchingYn ?? this.matchingYn,
    );
  }
}
