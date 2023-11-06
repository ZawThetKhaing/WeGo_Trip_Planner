import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:we_go/controller/app_controller.dart';
import 'package:we_go/theme/appTheme.dart';
import 'package:we_go/widgets/button.dart';
import 'package:we_go/widgets/dateTimePicker.dart';
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
                onEditingComplete: controller.destinationsFocusNode.unfocus,
                prefix: const Icon(
                  Icons.location_on,
                  size: 18,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: DateTimerPicker(
                      hintText: 'Start date',
                      assetPath: 'calendar_start',
                      widgetId: 'start_date',
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: DateTimerPicker(
                      hintText: 'End date',
                      assetPath: 'calendar_end',
                      widgetId: 'end_date',
                    ),
                  ),
                ],
              ),
              TripPlanTextInputField(
                controller: controller.budgetController,
                focusNode: controller.budgetFocusNode,
                keyboardType: TextInputType.number,
                hintText: "Budget per person",
                onEditingComplete: controller.budgetFocusNode.unfocus,
                prefix: SizedBox(
                  width: 18,
                  height: 18,
                  child: Image.asset("lib/assets/PiggyBank.png"),
                ),
              ),
              const DateTimerPicker(
                  hintText: 'Payment due date',
                  assetPath: 'calendar_payment',
                  widgetId: 'payment_due_date'),
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
