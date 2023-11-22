import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:we_go/controller/trip_plan_controller.dart';
import 'package:we_go/model/trip_plan_model.dart';
import 'package:we_go/theme/appTheme.dart';

class AddPlanBottomSheet extends GetView<TripPlanController> {
  final int dateRange;
  final TripPlanModel model;

  const AddPlanBottomSheet({
    super.key,
    required this.dateRange,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: Container(
        height: context.height * 0.85,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: Get.back,
                  child: const Text(
                    "Cancel",
                    style: AppTheme.welcomeTextStyle,
                  ),
                ),
                Text(
                  "Add plan",
                  style: AppTheme.welcomeTextStyle.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.brandColor,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    controller.addPlan(model);
                  },
                  child: const Text(
                    "Save",
                    style: AppTheme.welcomeTextStyle,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                children: [
                  TextFormField(
                    cursorHeight: 20,
                    cursorColor: AppTheme.textColor1,
                    controller: controller.addPlanTitleController,
                    focusNode: controller.tripPlanFocusNode,
                    validator: (_) =>
                        _?.isEmpty == true ? "This field is required." : null,
                    style: AppTheme.welcomeTextStyle
                        .copyWith(fontWeight: FontWeight.w700),
                    decoration: const InputDecoration(
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  /// Add note
                  TextFormField(
                    cursorHeight: 16,
                    cursorColor: AppTheme.textColor1,
                    controller: controller.addPlanContentController,
                    validator: (_) =>
                        _?.isEmpty == true ? "This field is required." : null,
                    style: AppTheme.bottomNavTextStyle.copyWith(
                      color: AppTheme.tripPlanTextColor,
                    ),
                    maxLines: 2,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: AppTheme.planInputFillcolor,
                        ),
                      ),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: AppTheme.planInputFillcolor,
                        ),
                      ),
                      hintText: "Add note",
                      hintStyle: AppTheme.bottomNavTextStyle.copyWith(
                        color: AppTheme.btmNavUnselectedColor,
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24.0),
                    child: GetBuilder<TripPlanController>(
                      id: 'drop_down_widget',
                      builder: (ctx) {
                        return DropdownButtonFormField<int>(
                          value: ctx.days.value,
                          decoration: const InputDecoration(
                            fillColor: Colors.white,
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: AppTheme.planInputFillcolor,
                              ),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: AppTheme.planInputFillcolor,
                              ),
                            ),
                            prefixIcon: PhosphorIcon(
                              PhosphorIconsFill.calendarBlank,
                              size: 18,
                            ),
                            prefixIconConstraints: BoxConstraints.expand(
                              width: 40,
                              height: 20,
                            ),
                            prefixIconColor: AppTheme.textColor1,
                          ),
                          iconDisabledColor: AppTheme.tripPlanTextColor,
                          items: List.generate(
                            dateRange,
                            (index) => DropdownMenuItem(
                              value: index + 1,
                              child: Text(
                                "Day ${index + 1}",
                                style: AppTheme.bottomNavTextStyle,
                              ),
                            ),
                          ),
                          onChanged: (value) {
                            ctx.dropDownChange(value);
                          },
                        );
                      },
                    ),
                  ),

                  TextFormField(
                    cursorHeight: 16,
                    cursorColor: AppTheme.textColor1,
                    controller: controller.addPlanAddLinkController,
                    style: AppTheme.bottomNavTextStyle.copyWith(
                      color: AppTheme.likeColor,
                    ),
                    maxLines: 4,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: AppTheme.planInputFillcolor,
                        ),
                      ),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: AppTheme.planInputFillcolor,
                        ),
                      ),
                      hintText: "Add link",
                      hintStyle: AppTheme.bottomNavTextStyle.copyWith(
                        color: AppTheme.btmNavUnselectedColor,
                      ),
                      prefixIconConstraints: const BoxConstraints.expand(
                        width: 40,
                        height: 30,
                      ),
                      prefixIcon: const PhosphorIcon(
                        PhosphorIconsBold.link,
                        size: 18,
                        color: AppTheme.textColor1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            GetBuilder<TripPlanController>(
              id: 'add_plan_pick_images',
              builder: (ctx) {
                return controller.addPlansImages.isEmpty
                    ? GestureDetector(
                        onTap: () {
                          controller.pickAddPlansImages(model);
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 15),
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: AppTheme.planInputFillcolor,
                              ),
                              borderRadius: BorderRadius.circular(5)),
                          width: context.width,
                          height: 100,
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.image),
                              Text("Upload images")
                            ],
                          ),
                        ),
                      )
                    : SizedBox(
                        width: context.width,
                        height: 220,
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                          ),
                          itemCount: controller.addPlansImages.length + 1,
                          itemBuilder: (_, i) {
                            return i < controller.addPlansImages.length
                                ? Container(
                                    margin: const EdgeInsets.only(
                                      right: 10,
                                      bottom: 10,
                                    ),
                                    width: 110,
                                    height: 100,
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(5),
                                      ),
                                      child: Image.file(
                                        File(
                                          controller.addPlansImages[i].path,
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      controller.pickAddPlansImages(model);
                                    },
                                    child: Container(
                                      width: 110,
                                      height: 100,
                                      decoration: const BoxDecoration(
                                        color: Color.fromRGBO(243, 243, 243, 1),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                      ),
                                      child: const Center(
                                        child: PhosphorIcon(
                                          PhosphorIconsFill.plusCircle,
                                          size: 32,
                                          color: AppTheme.planInputFillcolor,
                                        ),
                                      ),
                                    ),
                                  );
                          },
                        ),
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}
