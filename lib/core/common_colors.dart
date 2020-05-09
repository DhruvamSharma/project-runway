import 'package:flutter/material.dart';

class CommonColors {

  // Theme colors
  static final Color primarySwatch = Colors.amber;
  static final Color accentColor = _getColor(0xffFFFFFF);
  static final Color scaffoldColor = _getColor(0xff080808);
  static final Color toggleableActiveColor = Colors.transparent;
  static final Color cursorColor = Colors.grey;

  // Text Colors
  static final Color headerTextColor = _getColor(0xffFFFFFF);
  static final Color taskTextColor = _getColor(0xffFFFFFF);
  static final Color disabledTaskTextColor = _getColor(0xff707070);
  static final Color dateTextColor = _getColor(0xff3C3B3B);
  static final Color rotatedDesignTextColor = _getColor(0xff171616);
  static final Color taskBadgeTextColor = scaffoldColor;
  static final Color taskBadgeColor = accentColor;
  static final Color errorTextColor = Colors.red;

  // App bar colors
  static final Color appBarColor = Colors.transparent;

  static Map<int, Color> _color =
  {
    50:Color.fromRGBO(136,14,79, .1),
    100:Color.fromRGBO(136,14,79, .2),
    200:Color.fromRGBO(136,14,79, .3),
    300:Color.fromRGBO(136,14,79, .4),
    400:Color.fromRGBO(136,14,79, .5),
    500:Color.fromRGBO(136,14,79, .6),
    600:Color.fromRGBO(136,14,79, .7),
    700:Color.fromRGBO(136,14,79, .8),
    800:Color.fromRGBO(136,14,79, .9),
    900:Color.fromRGBO(136,14,79, 1),
  };

  static MaterialColor _getColor(int primary) {
    return MaterialColor(primary, _color);
  }
}