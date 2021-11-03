import 'dart:ui';

import 'package:enactus/shared/styles/sizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'colors.dart';
import 'fonts.dart';

ThemeData myTheme = ThemeData(
    primarySwatch: PRIMARY_SWATCH,
    scaffoldBackgroundColor: WHITE_COLOR,
    fontFamily: REGULAR_FONT,


    textTheme: TextTheme(
      bodyText1: TextStyle(fontFamily:MEDIUM_FONT,fontSize: FONT_17, color: BLACK_COLOR ),
      bodyText2: TextStyle(fontFamily:REGULAR_FONT,fontSize: FONT_14, color: BLACK_COLOR ),
      headline2: TextStyle(fontFamily:BOLD_FONT,fontSize: FONT_14, color: BLACK_COLOR ),
      headline1: TextStyle(fontFamily:BOLD_FONT ,fontSize: BOLD_HEADLINE, color: BLACK_COLOR ,),
      subtitle1  : TextStyle(fontFamily:LIGHT_FONT ,fontSize: FONT_9, color: BLACK_COLOR ),
    ),
    iconTheme: IconThemeData(
      color: BLACK_COLOR
    ),
    appBarTheme: AppBarTheme(

        actionsIconTheme: IconThemeData(
            color: WHITE_COLOR,
        ),
        iconTheme: IconThemeData(
            color: WHITE_COLOR
        ),
        color: BLACK_COLOR,
        elevation: 0,
        backwardsCompatibility: false,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: BLACK_COLOR,
            statusBarBrightness: Brightness.dark)));
