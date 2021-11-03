import 'package:enactus/models/feedback.dart';
import 'package:enactus/models/notification.dart';

class UserModel {
  String uId = '';
  String fullName = '';
  String email = '';
  String phone = '';
  String id = '';
  String college = '';
  String semester = '';
  String teamName = '';
  String image = '';
  String authority = '';
  String position = '';
  double score = 0.0;
  int rank = 0;
  List<Feedback> feedBacks = [];
  List<String> postsIds = [];
  List<Notification> notifications = [];
  int unseenNotifications = 0;

  // String uId = '';

  UserModel({
    required this.uId,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.id,
    required this.college,
    required this.semester,
    required this.teamName,
    required this.authority,
    required this.position,
    //    required this.uId,
    this.image = '',
    this.score = 0.0,
    this.rank = 0,
    this.feedBacks = const [],
    this.postsIds = const [],
    this.notifications = const [],
    this.unseenNotifications = 0,
  });

  UserModel.fromUser();

  Map<String, dynamic> toMap() {
    List<Map<String, dynamic>> feedbacksInMapsForm =
        feedBacks.map((element) => element.toMap()).toList();
    List<Map<String, dynamic>> notificationsInMapForm =
        notifications.map((element) => element.toMap()).toList();

    return {
      'uId' : uId,
      'fullName': fullName,
      'teamName': teamName,
      'email': email,
      'phone': phone,
      'id': id,
      'college': college,
      'semester': semester,
      'authority': authority,
      'image': image,
      'feedBacks': feedbacksInMapsForm,
      'postsIds': postsIds,
      'notifications': notificationsInMapForm,
      'unseenNotifications': unseenNotifications,
      'rank': rank,
      'score': score,
      'position': position,
    };
  }

  static UserModel fromJson(Map<String, dynamic> json) {
    final List<Feedback> feedBacks = List.from(json['feedBacks'])
        .map((feedback) => Feedback.fromJson(feedback))
        .toList();
    final List<String> postsIds = List.from(json['postsIds']);
    final List<Notification> notifications = List.from(json['notifications'])
        .map((notification) => Notification.fromJson(notification))
        .toList();

    return UserModel(
      uId : json['uId'],
      fullName: json['fullName'],
      teamName: json['teamName'],
      email: json['email'],
      phone: json['phone'],
      id: json['id'],
      college: json['college'],
      semester: json['semester'],
      authority: json['authority'],
      image: json['image'],
      rank: json['rank'],
      score: json['score'],
      position: json['position'],
      unseenNotifications: json['unseenNotifications'],
      feedBacks: feedBacks,
      postsIds: postsIds,
      notifications: notifications,
    );
  }
}
