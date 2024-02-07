import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:we_go/theme/appTheme.dart';

abstract class Utils {
  static void toast(String message) => Fluttertoast.showToast(
        msg: message,
        backgroundColor: AppTheme.brandColor,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
      );

  static String aboutUs =
      ", the ultimate trip planning app designed to simplify your travel experiences. WeGo was born from the struggles of two friends, in organizing a group trip. Their shared passion for travel and tech innovation led them to create a user-friendly solution to streamline the complexities of planning group travel.\n\nAt WeGo, our goal is to empower travelers globally by simplifying the trip planning process. We strive to provide an intuitive platform fostering effortless collaboration among travel groups, ensuring memorable journeys. \n\nYou may support us and start using WeGo to transform your trip planning experience. Whether it's a family vacation, friends' getaway, or solo adventure, WeGo is your trusted companion for turning travel dreams into reality. \n\nEmbark on your next adventure with WeGo today and discover a world of possibilities.\n\nHappy exploring!\nWeGo Team";

  static String ago(DateTime date) {
    if (DateTime.now().difference(date).inMinutes < 60) {
      return '${DateTime.now().difference(date).inMinutes}m';
    } else if (DateTime.now().difference(date).inHours < 24) {
      return '${DateTime.now().difference(date).inHours}h';
    } else if (DateTime.now().difference(date).inDays < 7) {
      return '${DateTime.now().difference(date).inDays}d';
    } else if (DateTime.now().difference(date).inDays < 14) {
      return '1w';
    } else if (DateTime.now().difference(date).inDays < 21) {
      return '2w';
    } else if (DateTime.now().difference(date).inDays < 28) {
      return '3w';
    } else if (DateTime.now().difference(date).inDays < 31) {
      return '4w';
    }
    return 'about a month';
  }
}
