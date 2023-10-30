import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:we_go/controller/app_controller.dart';
import 'package:we_go/global.dart';
import 'package:we_go/theme/appTheme.dart';
import 'package:we_go/utils/utils.dart';
import 'package:we_go/widgets/button.dart';
import 'package:we_go/widgets/trip_plan_textInputField.dart';

class PlanView extends StatelessWidget {
  const PlanView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final AppController controller = Get.find<AppController>();
    return Form(
      key: controller.tripPlanKey,
      child: ListView(
        padding:
            EdgeInsets.only(left: 15, right: 15, top: context.height * 0.07),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                () => Text(
                  "Welcome to WeGo, ${controller.loginUser.userName}",
                  style: AppTheme.welcomeTextStyle,
                ),
              ),
              const Text(
                "Create your dream trip now",
                style: AppTheme.largeTextStyle,
              ),
              TripPlanTextInputField(
                controller: controller.tripNameController,
                focusNode: controller.tripNameFocusNode,
                hintText: "Trip name",
                onEditingComplete:
                    controller.destinationsFocusNode.requestFocus,
                prefix: SizedBox(
                  width: 18,
                  height: 18,
                  child: Image.asset(
                    "lib/assets/Tent.png",
                  ),
                ),
              ),
              TripPlanTextInputField(
                controller: controller.destinationsController,
                focusNode: controller.destinationsFocusNode,
                hintText: "Destination",
                onEditingComplete: controller.startDateFocusNode.requestFocus,
                prefix: const Icon(
                  Icons.location_on,
                  size: 18,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TripPlanTextInputField(
                      controller: controller.startDateController,
                      focusNode: controller.startDateFocusNode,
                      hintText: "Start date",
                      keyboardType: TextInputType.number,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (_) {
                        return Utils.dateTimeValidator(_);
                      },
                      onEditingComplete:
                          controller.endDateFocusNode.requestFocus,
                      prefix: SizedBox(
                        width: 18,
                        height: 18,
                        child: Image.asset("lib/assets/calendar_start.png"),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TripPlanTextInputField(
                      controller: controller.endDateController,
                      focusNode: controller.endDateFocusNode,
                      keyboardType: TextInputType.number,
                      hintText: "End date",
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (_) {
                        return Utils.dateTimeValidator(_);
                      },
                      onEditingComplete:
                          controller.budgetFocusNode.requestFocus,
                      prefix: SizedBox(
                        width: 18,
                        height: 18,
                        child: Image.asset("lib/assets/calendar_end.png"),
                      ),
                    ),
                  ),
                ],
              ),
              TripPlanTextInputField(
                controller: controller.budgetController,
                focusNode: controller.budgetFocusNode,
                keyboardType: TextInputType.number,
                hintText: "Budget per person",
                onEditingComplete:
                    controller.paymentDueDateFocusNode.requestFocus,
                prefix: SizedBox(
                  width: 18,
                  height: 18,
                  child: Image.asset("lib/assets/PiggyBank.png"),
                ),
              ),
              TripPlanTextInputField(
                controller: controller.paymentDueDateController,
                focusNode: controller.paymentDueDateFocusNode,
                keyboardType: TextInputType.number,
                hintText: "Payment due date",
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (_) {
                  return Utils.dateTimeValidator(_);
                },
                onEditingComplete: () {
                  controller.paymentDueDateFocusNode.unfocus();
                  controller.saveToMyTrips();
                },
                prefix: SizedBox(
                  width: 18,
                  height: 18,
                  child: Image.asset("lib/assets/calendar_payment.png"),
                ),
              ),
              Button(
                label: "Continue planning",
                onPressed: controller.saveToMyTrips,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
