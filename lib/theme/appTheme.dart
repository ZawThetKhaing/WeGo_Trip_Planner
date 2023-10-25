import 'package:flutter/material.dart';

abstract class AppTheme {
  ///InputDecorationTheme
  static const InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
    isDense: true,
    border: OutlineInputBorder(borderSide: BorderSide.none),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppTheme.errorBorderColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppTheme.focusBorder),
    ),
    focusColor: Colors.black,
    filled: true,
    fillColor: Color.fromRGBO(243, 243, 243, 1),
  );

  static const TextStyle normalTextStyle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: textColor1,
  );
  static const TextStyle appNameTextstyle = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle largeTextStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: brandColor,
  );
  static const Color brandColor = Color.fromRGBO(52, 168, 83, 1);
  static const Color buttonColor = Color.fromRGBO(55, 151, 239, 1);
  static const Color hintColor = Color.fromRGBO(184, 184, 184, 1);
  static const Color textColor1 = Color.fromRGBO(34, 58, 41, 1);
  static const Color boxColor2 = Color.fromRGBO(52, 168, 83, 0.2);
  static const Color errorBorderColor = Color.fromRGBO(234, 67, 53, 1);
  static const Color focusBorder = Color.fromRGBO(52, 168, 83, 1);
}
