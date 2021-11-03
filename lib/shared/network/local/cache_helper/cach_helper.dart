
import 'package:enactus/models/user/user.dart';
import 'package:enactus/strings/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {

  static late SharedPreferences _sharedPreferences;

  static Future<void>  init ()async
  {
    _sharedPreferences =await SharedPreferences.getInstance();
  }

  static Future<void> storeUserToPreferences (String userName)async
  {
   await _sharedPreferences.setString(USER_NAME_KEY, USER_IMAGE_KEY);
  }


}