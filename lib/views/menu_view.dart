import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:we_go/controller/app_controller.dart';
import 'package:we_go/widgets/button.dart';

class MenuView extends GetView<AppController> {
  const MenuView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.center,
      child: Button(
        label: "Logout",
        onPressed: controller.logout,
      ),
    );
  }
}
