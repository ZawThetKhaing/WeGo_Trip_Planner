import 'package:flutter/material.dart';
import 'package:we_go/theme/appTheme.dart';

class MyTripView extends StatelessWidget {
  const MyTripView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          "No planned trips",
          style: AppTheme.welcomeTextStyle.copyWith(
            color: AppTheme.hintColor,
          ),
        ),
      ),
    );
  }
}
