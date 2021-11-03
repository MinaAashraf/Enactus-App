import 'package:enactus/layouts/home_layout/home_layout.dart';
import 'package:enactus/layouts/login_layout/login_layout.dart';
import 'package:enactus/shared/components/components.dart';
import 'package:enactus/shared/components/constants.dart';
import 'package:enactus/shared/network/remote/firebase/user_firebase.dart';
import 'package:enactus/shared/styles/colors.dart';
import 'package:enactus/strings/strings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NoConnectionScreen extends StatelessWidget {
  const NoConnectionScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'No internet connection',
          style: getTextTheme(context).bodyText2!.copyWith(color: WHITE_COLOR),
        ),
        titleSpacing: 30,
      ),
      body: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            NO_INTERNET_ICON,
            width: 100,
            height: 100,
          ),
          buildVerticalSpace(),
          MaterialButton(
            onPressed: () async {
              bool connected = await checkConnection();
              if (connected) {
                WidgetsFlutterBinding.ensureInitialized();
                await Firebase.initializeApp();
                Navigator.pushReplacement(context,
                    PageRouteBuilder(pageBuilder: (_, __, ___) {
                      return UserFirebase.isUserLogin()
                          ? HomeLayout()
                          : LoginLayout();
                    }));
              }
              else
                showToast('No Internet Connection');
            },
            child: Text(
              'Try again',
              style: getTextTheme(context).bodyText1,
            ),
            color: PRIMARY_SWATCH,
          )
        ],
      )),
    );
  }
}
