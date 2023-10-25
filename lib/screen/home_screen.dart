import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_hub/controller/app_controller.dart';
import 'package:social_hub/theme/appTheme.dart';
import 'package:social_hub/widgets/button.dart';

class HomeScreen extends GetView<AppController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text(
            "Welcome",
            style: AppTheme.largeTextStyle,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Button(
              label: "Logout",
              onPressed: controller.logout,
            ),
          ),
        ],
      ),
    );
  }
}
