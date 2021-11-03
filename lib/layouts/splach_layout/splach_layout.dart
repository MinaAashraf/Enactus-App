import 'dart:async';

import 'package:enactus/layouts/home_layout/home_layout.dart';
import 'package:enactus/layouts/login_layout/login_layout.dart';
import 'package:enactus/modules/no_connection_screen.dart';
import 'package:enactus/shared/components/components.dart';
import 'package:enactus/shared/components/constants.dart';
import 'package:enactus/shared/network/remote/firebase/user_firebase.dart';
import 'package:enactus/shared/styles/colors.dart';
import 'package:enactus/strings/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplachLayout extends StatefulWidget {
  @override
  _SplachLayoutState createState() => _SplachLayoutState();
}

class _SplachLayoutState extends State<SplachLayout>
    with SingleTickerProviderStateMixin {
  double screenHeight = 0;
  Color color1 = PRIMARY_SWATCH;
  Color color2 = WHITE_COLOR;
  Color color3 = WHITE_COLOR;
  Color color4 = WHITE_COLOR;

  @override
  void initState() {
    _animateLogosColor();
    goToHomePage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = getScreenWidth(context);
    screenHeight = getScreenHeight(context);
    return Scaffold(
        backgroundColor: BLACK_COLOR,
        body: Stack(
          children: [
            Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth / 12),
                  child: buildDelayedImage(),
                )),
            SizedBox(
              height: 10,
            ),
            Center(child: buildRowOfRepeatedLogo())
          ],
        ));
  }

  Future goToHomePage() async {
    await new Future.delayed(const Duration(milliseconds: 4000));
    bool connected = await checkConnection();
    Navigator.pushReplacement(
        context,
        PageRouteBuilder(
            pageBuilder: (_, __, ___) {
              return connected ? UserFirebase.isUserLogin()
                  ? HomeLayout()
                  : LoginLayout()
                  : NoConnectionScreen();
            })
    );
  }


Future<void> animate() async {
  setState(() {
    padding = 250;
  });
}

Widget buildDelayedImage() {
  return LayoutBuilder(
    builder: (BuildContext context, BoxConstraints constraints) {
      return buildLogoImage();
    },
  );
}

var padding = 600.0;

Widget buildRowOfRepeatedLogo() {
  return LayoutBuilder(
    builder: (BuildContext context, BoxConstraints constraints) {
      return AnimatedContainer(
        duration: Duration(milliseconds: 300),
        child: Padding(
          padding: EdgeInsets.only(top: screenHeight / 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildSmallLogo(
                  imageAssetName: '$FULL_COLOR_LOGO', color: color1),
              buildHorizontalSpace(width: 5),
              buildSmallLogo(
                  imageAssetName: '$FULL_COLOR_LOGO', color: color2),
              buildHorizontalSpace(width: 5),
              buildSmallLogo(
                  imageAssetName: '$FULL_COLOR_LOGO', color: color3),
              buildHorizontalSpace(width: 5),
              buildSmallLogo(
                  imageAssetName: '$FULL_COLOR_LOGO', color: color4),
              buildHorizontalSpace(width: 5),
            ],
          ),
        ),
      );
    },
  );
}

_animateLogosColor() async {
  while (true) {
    await _animateOneLogo(1);
    await _animateOneLogo(2);
    await _animateOneLogo(3);
    await _animateOneLogo(4);
  }
}

_animateOneLogo(int i) async {
  setState(() {
    switch (i) {
      case 1:
        color1 = PRIMARY_SWATCH;
        color4 = WHITE_COLOR;
        break;
      case 2:
        color2 = PRIMARY_SWATCH;
        color1 = WHITE_COLOR;
        break;
      case 3:
        color3 = PRIMARY_SWATCH;
        color2 = WHITE_COLOR;
        break;
      case 4:
        color4 = PRIMARY_SWATCH;
        color3 = WHITE_COLOR;
        break;
    }
  });
  await new Future.delayed(const Duration(milliseconds: 200));
}}
