import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:we_go/controller/trip_plan_controller.dart';
import 'package:we_go/model/trip_plan_model.dart';
import 'package:we_go/theme/appTheme.dart';
import 'package:we_go/widgets/button.dart';

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
        height: context.height * 0.8,
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Cancel",
                  style: AppTheme.welcomeTextStyle.copyWith(),
                ),
                SizedBox(
                  width: (context.width * 0.5) - 90,
                ),
                Text(
                  "Add plan",
                  style: AppTheme.welcomeTextStyle.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.brandColor,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Column(
              children: [
                TextFormField(
                  controller: controller.addPlanTitleController,
                  style: AppTheme.welcomeTextStyle
                      .copyWith(fontWeight: FontWeight.w700),
                  decoration: const InputDecoration(
                    constraints: BoxConstraints.expand(height: 20),
                    fillColor: AppTheme.planInputFillcolor,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                TextFormField(
                  controller: controller.addPlanContentController,
                  style: AppTheme.bottomNavTextStyle.copyWith(
                    color: AppTheme.tripPlanTextColor,
                  ),
                  maxLines: 2,
                  decoration: InputDecoration(
                    fillColor: AppTheme.planInputFillcolor,
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    hintText: "Add note",
                    hintStyle: AppTheme.bottomNavTextStyle.copyWith(
                      color: AppTheme.btmNavUnselectedColor,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                GetBuilder<TripPlanController>(
                  id: 'drop_down_widget',
                  builder: (ctx) {
                    return DropdownButtonFormField<int>(
                      value: ctx.days.value,
                      decoration: InputDecoration(
                        prefixIcon: SizedBox(
                          width: 18,
                          height: 18,
                          child: Image.asset(
                            "lib/assets/calendar_blank.png",
                          ),
                        ),
                      ),
                      iconDisabledColor: AppTheme.tripPlanTextColor,
                      items: List.generate(
                          dateRange,
                          (index) => DropdownMenuItem(
                              value: index + 1,
                              child: Text(
                                "Day ${index + 1}",
                                style: AppTheme.bottomNavTextStyle,
                              ))),
                      onChanged: (value) {
                        ctx.dropDownChange(value);
                      },
                    );
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: controller.addPlanAddLinkController,
                  style: AppTheme.bottomNavTextStyle.copyWith(
                    color: AppTheme.tripPlanTextColor,
                  ),
                  maxLines: 2,
                  decoration: InputDecoration(
                    fillColor: AppTheme.planInputFillcolor,
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    hintText: "Add link",
                    hintStyle: AppTheme.bottomNavTextStyle.copyWith(
                      color: AppTheme.btmNavUnselectedColor,
                    ),
                    prefixIcon: const Icon(Icons.link),
                  ),
                ),
                Container(
                  width: context.width,
                  height: 100,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Icon(Icons.image), Text("Upload images")],
                  ),
                ),
                Button(
                  label: "Add plan",
                  onPressed: () {
                    controller.addPlan(model);
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
