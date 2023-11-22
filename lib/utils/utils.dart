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
