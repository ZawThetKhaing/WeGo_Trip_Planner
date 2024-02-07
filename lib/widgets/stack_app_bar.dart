import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:we_go/controller/trip_plan_controller.dart';
import 'package:we_go/model/trip_plan_model.dart';
import 'package:we_go/theme/appTheme.dart';

class StackAppBar extends GetView<TripPlanController> {
  final TripPlanModel model;
  const StackAppBar({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: context.width,
          height: 35,
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
        ),
        Positioned(
            right: 10,
            child: GestureDetector(
              onTap: () {
                controller.tripPlanBgImageChange(model);
              },
              child: Container(
                width: 60,
                height: 30,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.edit,
                      color: AppTheme.textColor1,
                      size: 11,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Edit",
                      style: AppTheme.normalTextStyle,
                    ),
                  ],
                ),
              ),
            ))
      ],
    );
  }
}
