import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enactus/shared/components/constants.dart';
import 'package:enactus/shared/network/remote/firebase/post_firebase.dart';

class Post {
  String creatorName;
  String creatorImage;
  String creatorAuthority;
  String creatorId;
  Timestamp dateTime;
  String text;
  String? postImage;
  int commentsNum;
  int likesCount;
  String postId ;

  Post({
    required this.postId,
    required this.creatorName,
    required this.creatorImage,
    required this.creatorAuthority,
    required this.creatorId,
    required this.dateTime,
    required this.text,
    this.postImage,
    this.likesCount = 0,
    this.commentsNum = 0,

  });

  Map<String, dynamic> toMap() {
    return {
      'creatorName': creatorName,
      'creatorImage': creatorImage,
      'creatorAuthority' : creatorAuthority,
      'creatorId': creatorId,
      'dateTime': dateTime,
      'text': text,
      'postImage': postImage,
      'commentsNum': 0,
      'likesCount': 0,
      'postId': postId,
    };
  }

  static Post fromJson(Map<String, dynamic> json) {
    return Post(
      creatorName: json['creatorName'],
      creatorImage: json['creatorImage'],
      creatorAuthority: json['creatorAuthority'],
      creatorId: json['creatorId'],
      dateTime: json['dateTime'],
      text: json['text'],
      postImage: json['postImage'],
      commentsNum: json['commentsNum'],
      likesCount: json['likesCount'],
      postId: json['postId'],

    );
  }

  String handlePostDate() {
    DateTime postDateTime = _fromTimeStamp();
    return handleDate(postDateTime);
  }

  DateTime _fromTimeStamp() {
    return DateTime.fromMicrosecondsSinceEpoch(
        this.dateTime.microsecondsSinceEpoch);
  }

  int compare (Post p)
  {
    return p.dateTime.compareTo(this.dateTime);
  }

}
