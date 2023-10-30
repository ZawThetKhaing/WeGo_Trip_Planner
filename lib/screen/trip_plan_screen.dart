import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:we_go/model/trip_plan_model.dart';
import 'package:we_go/theme/appTheme.dart';
import 'package:we_go/widgets/stack_app_bar.dart';
import 'package:we_go/widgets/trip_plan_tabBarView.dart';

class TripPlanScreen extends StatelessWidget {
  final TripPlanModel model;
  const TripPlanScreen({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: 200,
                width: context.width,
                child: Image.asset(
                  'lib/assets/trip_plan_default_photo.png',
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),

                    ///Title
                    SizedBox(
                      height: 75,
                      width: context.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            model.tripName,
                            style: AppTheme.largeTextStyle,
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                size: 13,
                                color: AppTheme.tripPlanTextColor,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                model.destination,
                                style: AppTheme.bottomNavTextStyle.copyWith(
                                  color: AppTheme.tripPlanTextColor,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 13,
                                height: 13,
                                child: Image.asset(
                                  "lib/assets/calendar_blank.png",
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                "${DateFormat.MMMd().format(
                                  DateTime.parse(model.startDate),
                                )} to ${DateFormat.MMMd().format(
                                  DateTime.parse(model.endDate),
                                )}",
                                style: AppTheme.bottomNavTextStyle.copyWith(
                                  color: AppTheme.tripPlanTextColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TripPlanTabBarView(
                  model: model,
                ),
              )
            ],
          ),
          Positioned(
            top: context.width * 0.15,
            child: const StackAppBar(),
          ),
        ],
      ),
    );
  }
}
