import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:we_go/controller/app_controller.dart';
import 'package:we_go/theme/appTheme.dart';

class DateTimerPicker extends StatelessWidget {
  final String hintText;
  final String assetPath;
  final String widgetId;
  const DateTimerPicker({
    super.key,
    required this.hintText,
    required this.assetPath,
    required this.widgetId,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(
      id: widgetId,
      builder: (ctx) {
        return GestureDetector(
          onTap: () async {
            final DateTime? date = await showDatePicker(
              context: context,
              initialDate: ctx.dateTimepicker.isEmpty == true
                  ? DateTime.now()
                  : DateTime.parse(ctx.dateTimepicker.value),
              firstDate: DateTime(DateTime.now().year - 1),
              lastDate: DateTime(DateTime.now().year + 1),
            );
            if (date != null) {
              final String pickdate = date.toString().split(' ').first;
              ctx.pickDateTime(pickdate, widgetId);
            }
            return;
          },
          child: Container(
            width: context.width,
            height: ctx.isError.value ? 48 : 40,
            color: Colors.transparent,
            margin: const EdgeInsets.only(top: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 18,
                        height: 18,
                        child: Image.asset("lib/assets/$assetPath.png"),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Text(
                        ctx.dateTimepicker.value.isEmpty
                            ? hintText
                            : ctx.dateTimepicker.value.replaceAll('-', '/'),
                        style: ctx.dateTimepicker.value.isEmpty
                            ? AppTheme.bottomNavTextStyle.copyWith(
                                color: AppTheme.btmNavUnselectedColor,
                              )
                            : AppTheme.bottomNavTextStyle.copyWith(
                                color: AppTheme.textColor1,
                              ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: ctx.isError.value
                      ? AppTheme.errorBorderColor
                      : AppTheme.btmNavUnselectedColor,
                  thickness: 1,
                ),
                ctx.isError.value
                    ? const Text(
                        "This field is requried.",
                        style: AppTheme.errorTextStyle,
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        );
      },
    );
  }
}
