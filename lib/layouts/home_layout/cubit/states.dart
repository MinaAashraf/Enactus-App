
import 'package:enactus/models/user/user.dart';

abstract class HomeStates{}

class HomeInitState extends HomeStates {}
class OnReadUserDataSuccess extends HomeStates {
   UserModel user = UserModel.fromUser();
}






