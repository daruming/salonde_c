import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import 'package:salondec/core/core.dart';

class TextChatModel extends Core with EquatableMixin {
  String uid;
  String docId;
  String? name;
  String title;
  String contents;
  int commentCount;

  TextChatModel({
    required this.uid,
    required this.docId,
    required this.name,
    required this.title,
    required this.contents,
    required this.commentCount,
  }) : super(DateTime.now(), DateTime.now());

  Map<String, dynamic> toJson({TextChatModel? textChatModel}) {
    if (textChatModel != null) {
      var json = {
        'uid': uid,
        'docId': docId,
        'name': (name == null || name == '') ? textChatModel.name : name,
        'title': (title == '') ? textChatModel.title : title,
        'contents': (contents == '') ? textChatModel.contents : contents,
        'commentCount':
            (commentCount == 0) ? textChatModel.commentCount : commentCount,
        'created_at': textChatModel.createdAt,
        'updated_at': updatedAt,
      };
      return json;
    }
    return {
      'uid': uid,
      'docId': docId,
      'name': name ?? "anonymity",
      'title': title,
      'contents': contents,
      'commentCount': commentCount,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  factory TextChatModel.fromFirebase(DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> json = documentSnapshot.data() as Map<String, dynamic>;

    TextChatModel textChatModel = TextChatModel(
      uid: json['uid'] ?? '',
      docId: json['docId'] ?? '',
      name: json['name'] ?? "anonymity",
      title: json['title'] ?? '',
      contents: json['contents'] ?? '',
      commentCount: json['commentCount'] ?? '',
    );

    textChatModel.createdAt = (json['created_at'] as Timestamp).toDate();
    textChatModel.updatedAt = (json['updated_at'] as Timestamp).toDate();

    return textChatModel;
  }

  @override
  List<Object> get props {
    return [
      uid,
      docId,
      name ?? "anonymity",
      title,
      contents,
      commentCount,
    ];
  }

  TextChatModel copyWith({
    String? uid,
    String? docId,
    String? name,
    String? title,
    String? contents,
    int? commentCount,
  }) {
    return TextChatModel(
      uid: uid ?? this.uid,
      docId: docId ?? this.docId,
      name: name ?? this.name,
      title: title ?? this.title,
      contents: contents ?? this.contents,
      commentCount: commentCount ?? this.commentCount,
    );
  }
}

class CommentModel extends Core with EquatableMixin {
  String uid;
  String? name;
  String contents;

  CommentModel({
    required this.uid,
    required this.name,
    required this.contents,
  }) : super(DateTime.now(), DateTime.now());

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name ?? "anonymity",
      'contents': contents,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  factory CommentModel.fromFirebase(DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> json = documentSnapshot.data() as Map<String, dynamic>;

    CommentModel commentModel = CommentModel(
      uid: json['uid'] ?? '',
      name: json['name'] ?? "anonymity",
      contents: json['contents'] ?? '',
    );

    commentModel.createdAt = (json['created_at'] as Timestamp).toDate();
    commentModel.updatedAt = (json['updated_at'] as Timestamp).toDate();

    return commentModel;
  }

  @override
  List<Object> get props {
    return [
      uid,
      name ?? "anonymity",
      contents,
    ];
  }
}
