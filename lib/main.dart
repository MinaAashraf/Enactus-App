import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enactus/layouts/home_layout/home_layout.dart';
import 'package:enactus/layouts/login_layout/login_layout.dart';
import 'package:enactus/layouts/splach_layout/splach_layout.dart';
import 'package:enactus/modules/no_connection_screen.dart';
import 'package:enactus/shared/components/constants.dart';
import 'package:enactus/shared/network/local/cache_helper/cach_helper.dart';
import 'package:enactus/shared/network/remote/fcm_api/dio_helper.dart';
import 'package:enactus/shared/network/remote/firebase/user_firebase.dart';
import 'package:enactus/shared/styles/themes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool connected = await checkConnection();
  if (connected) {
    await Firebase.initializeApp();
    await CacheHelper.init();
    await FcmDioHelper.init();
    await FirebaseMessaging.instance.subscribeToTopic('all');
  }
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: myTheme,
        home: SplachLayout());
  }
}
