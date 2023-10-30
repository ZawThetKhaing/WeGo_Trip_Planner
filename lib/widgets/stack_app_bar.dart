import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:we_go/theme/appTheme.dart';

class StackAppBar extends StatelessWidget {
  const StackAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: context.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Trip plan",
                style: AppTheme.welcomeTextStyle.copyWith(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 1,
          child: IconButton(
            onPressed: Get.back,
            splashRadius: 20,
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }
}
