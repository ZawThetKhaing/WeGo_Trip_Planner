import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_hub/controller/app_controller.dart';
import 'package:social_hub/routes/routes.dart';

class WrapperScreen extends StatefulWidget {
  const WrapperScreen({super.key});

  @override
  State<WrapperScreen> createState() => _WrapperScreenState();
}

class _WrapperScreenState extends State<WrapperScreen> {
  final AppController _appController = Get.find<AppController>();
  @override
  void initState() {
    init();
    super.initState();
  }

  void init() async {
    await Future.delayed(
      const Duration(seconds: 3),
      () {
        if (_appController.authState == AuthState.none) {
          Get.offNamed(AppRoutes.login);
          return;
        }
        if (_appController.loginUser.user != null) {
          Get.offNamedUntil(AppRoutes.home, (route) => false);
        } else if (_appController.loginUser.user == null) {
          Get.offNamedUntil(AppRoutes.login, (route) => false);
        } else {
          init();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
