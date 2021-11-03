import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enactus/layouts/home_layout/cubit/states.dart';
import 'package:enactus/layouts/home_layout/home_layout.dart';
import 'package:enactus/layouts/login_layout/login_layout.dart';
import 'package:enactus/models/user/user.dart';
import 'package:enactus/shared/components/constants.dart';
import 'package:enactus/shared/network/local/cache_helper/cach_helper.dart';
import 'package:enactus/shared/network/remote/firebase/user_firebase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitState());

  static HomeCubit get(context) => BlocProvider.of(context);

  UserModel user = UserModel.fromUser();
  late StreamSubscription subscription;

  Future<void> getUserData() async {
    try {
      subscription = UserFirebase.getUser().listen((event) async {
        Map<String, dynamic>? json = event.data();
        if (json != null && (json['uId']==user.uId || user.uId =='')) {
          user =  UserModel.fromJson(json);
          generalUser = user;
          notificationsNum = user.unseenNotifications;
          emit(OnReadUserDataSuccess()..user = this.user);
        }
      });
    } catch (err) {
      subscription.cancel();
      print(err.toString());
    }
  }

  cancelListener() {
    subscription.cancel();
  }

  Widget screen = HomeLayout();

  void isUserLogin() {
    screen = UserFirebase.isUserLogin() ? HomeLayout() : LoginLayout();
  }

  int notificationsNum = 0;

  clearNotificationsNum() {
    UserFirebase.clearUnSeenNotificationsNumber();
  }
}
