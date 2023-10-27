import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:we_go/theme/appTheme.dart';

abstract class Utils {
  static String? dateTimeValidator(String? data) {
    return data?.split('-').first.length == 4 &&

            ///month
            data?.split('-').last.split('-').first.length == 2 &&

            ///day
            data?.split('-').last.split('-').last.length == 2
        ? null
        : "Please input like '2023-10-10'";
  }

  static void toast(String message) => Fluttertoast.showToast(
        msg: message,
        backgroundColor: AppTheme.brandColor,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
      );
}
