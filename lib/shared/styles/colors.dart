import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

const WHITE_COLOR = Colors.white;
final GREY_COLOR = HexColor('#DADADA');
final BLACK_COLOR = Colors.black;
const blackLightColor = Colors.black26;
Color blackLightColor2 = Colors.white.withOpacity(200);

final WHITE30 = HexColor('#b2b2b2');

//primary swatch
const MaterialColor PRIMARY_SWATCH = MaterialColor(
  _Main_Color,
  <int, Color>{
    50: Color(0xFFFDC311),
    100: Color(0xFFFDC311),
    200: Color(0xFFFDC311),
    300: Color(0xFFFDC311),
    400: Color(0xFFFDC311),
    500: Color(_Main_Color),
    600: Color(0xFFFDC311),
    700: Color(0xFFFDC311),
    800: Color(0xFFFDC311),
    900: Color(0xFFFDC311),
  },
);
const int _Main_Color = 0xFFFDC311;
