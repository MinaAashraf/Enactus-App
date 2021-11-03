import 'package:dio/dio.dart';
import 'package:enactus/strings/strings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FcmDioHelper {
  static late Dio dio;

  static const baseUrl = 'https://fcm.googleapis.com/fcm/';

  static init() {
    dio = Dio(BaseOptions(
        baseUrl: baseUrl,
        receiveDataWhenStatusError: true,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "key=$FCM_SERVER_KEY"
        }));
  }

  static Future<Response> pushFcmNotification (
      String title, String body, String url, bool notifyAllUsers) async{
    return await dio.post('send', data: getData(title, body, url,notifyAllUsers));
  }

  static Map getData(String title, String body, String url, bool notifyAllUsers) => {
        "to": notifyAllUsers? "/topics/all" : '${FirebaseMessaging.instance.getToken()}',
        "notification": {
          "title": "$title",
          "body": "$body",
          "mutable_content": true,
          "sound": "default"
        },
        "data": {"url": "$url"}
      };
}
