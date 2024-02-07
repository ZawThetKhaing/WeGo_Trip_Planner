import 'package:flutter/material.dart';

abstract class AppTheme {
  ///AppTheme
  static ThemeData appTheme = ThemeData(
    fontFamily: 'Poppins',
    appBarTheme: const AppBarTheme(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        elevation: 0),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          AppTheme.buttonColor,
        ),
        overlayColor: MaterialStateProperty.all(
          Colors.transparent,
        ),
        shape: MaterialStateProperty.all(
          const RoundedRectangleBorder(),
        ),
        elevation: MaterialStateProperty.all(0),
        textStyle: MaterialStateProperty.all(
          const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.all(
          Colors.transparent,
        ),
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      isDense: true,
      border: OutlineInputBorder(borderSide: BorderSide.none),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppTheme.errorBorderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppTheme.focusBorderColor),
      ),
      focusColor: Colors.black,
      filled: true,
      fillColor: Color.fromRGBO(243, 243, 243, 1),
    ),
  );

  ///
  static const TextStyle normalTextStyle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: textColor1,
    fontFamily: 'Poppins',
  );
  static const TextStyle errorTextStyle = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w300,
    color: errorBorderColor,
    fontFamily: 'Poppins',
  );

  static const TextStyle agoTextStyle = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: agoColor,
    fontFamily: 'Poppins',
  );

  static const TextStyle appNameTextstyle = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.bold,
    fontFamily: 'Poppins',
  );
  static const TextStyle bottomNavTextStyle = TextStyle(
    fontSize: 13,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
  );

  static const TextStyle welcomeTextStyle = TextStyle(
    fontSize: 15,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w500,
    color: textColor1,
  );

  static const TextStyle largeTextStyle = TextStyle(
    fontSize: 20,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w600,
    color: brandColor,
  );

  static const Gradient myTripViewGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color.fromRGBO(34, 58, 41, 0),
      Color.fromRGBO(34, 58, 41, 1),
    ],
  );

  static const Color brandColor = Color.fromRGBO(52, 168, 83, 1);
  static const Color agoColor = Color.fromRGBO(151, 151, 151, 1);

  static const Color buttonColor = Color.fromRGBO(55, 151, 239, 1);
  static const Color hintColor = Color.fromRGBO(184, 184, 184, 1);
  static const Color textColor1 = Color.fromRGBO(34, 58, 41, 1);
  static const Color boxColor2 = Color.fromRGBO(52, 168, 83, 0.2);
  static const Color errorBorderColor = Color.fromRGBO(234, 67, 53, 1);
  static const Color focusBorderColor = Color.fromRGBO(52, 168, 83, 1);
  static const Color tripPlanTextColor = Color.fromRGBO(34, 58, 41, 0.75);
  static const Color planInputFillcolor = Color.fromRGBO(34, 58, 41, 0.1);
  static const Color likeColor = Color.fromRGBO(66, 133, 244, 1);
  static const Color unlikeColor = Color.fromRGBO(34, 58, 41, 0.5);
  static const Color btmNavUnselectedColor = Color.fromRGBO(200, 203, 201, 1);
  static const Color halfPaidColor = Color.fromRGBO(142, 142, 142, 1);
}
