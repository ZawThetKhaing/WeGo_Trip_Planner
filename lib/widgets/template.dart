import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:we_go/theme/appTheme.dart';

class Template extends StatelessWidget {
  final String title;
  final Widget body;
  const Template({
    super.key,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          splashRadius: 20,
          onPressed: Get.back,
          icon: const Icon(
            Icons.arrow_back,
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: AppTheme.welcomeTextStyle.copyWith(
            color: Colors.black,
          ),
        ),
      ),
      body: body,
    );
  }
}
