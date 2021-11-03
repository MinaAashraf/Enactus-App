import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enactus/shared/components/constants.dart';

class Notification {
  final String? url;

  final String title;

  final Timestamp date;

  Notification(this.url, this.title, this.date);

  Map<String, dynamic> toMap() {
    return {'url': url, 'title': title, 'date': date};
  }

  static Notification fromJson(Map<String, dynamic> json) {
    return Notification(
      json['url'],
      json['title'],
      json['date'],
    );
  }


  String handleNotiDate() {
    DateTime notiDateTime = _fromTimeStamp();
    return handleDate(notiDateTime);
  }

  DateTime _fromTimeStamp() {
    return DateTime.fromMicrosecondsSinceEpoch(
        this.date.microsecondsSinceEpoch);
  }


}
