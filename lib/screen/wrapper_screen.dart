import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:we_go/controller/app_controller.dart';
import 'package:we_go/routes/routes.dart';

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
      const Duration(seconds: 1),
      () {
        if (_appController.authState == AuthState.none) {
          Get.offNamed(AppRoutes.login);
          return;
        }
        if (_appController.authState == AuthState.authorized) {
          Get.offNamedUntil(AppRoutes.home, (route) => false);
        } else if (_appController.authState == AuthState.unauthorized) {
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
