import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
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
                prefix: const PhosphorIcon(
                  PhosphorIconsFill.tent,
                  size: 18,
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
              const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: DateTimerPicker(
                      hintText: 'Start date',
                      icon: PhosphorIcon(
                        PhosphorIconsFill.calendarCheck,
                        size: 18,
                      ),
                      widgetId: 'start_date',
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: DateTimerPicker(
                      hintText: 'End date',
                      widgetId: 'end_date',
                      icon: PhosphorIcon(
                        PhosphorIconsFill.calendarX,
                        size: 18,
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
                onEditingComplete: controller.budgetFocusNode.unfocus,
                prefix: const PhosphorIcon(
                  PhosphorIconsFill.piggyBank,
                  size: 18,
                ),
              ),
              const DateTimerPicker(
                hintText: 'Payment due date',
                widgetId: 'payment_due_date',
                icon: PhosphorIcon(
                  PhosphorIconsFill.calendar,
                  size: 18,
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
