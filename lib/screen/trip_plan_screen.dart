import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:we_go/global.dart';
import 'package:we_go/model/trip_plan_model.dart';
import 'package:we_go/theme/appTheme.dart';
import 'package:we_go/utils/collection.dart';
import 'package:we_go/widgets/stack_app_bar.dart';
import 'package:we_go/widgets/trip_plan_tabBarView.dart';

class TripPlanScreen extends StatefulWidget {
  const TripPlanScreen({
    super.key,
  });

  @override
  State<TripPlanScreen> createState() => _TripPlanScreenState();
}

class _TripPlanScreenState extends State<TripPlanScreen> {
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? watchTrip;
  final StreamController<TripPlanModel> _streamController =
      StreamController.broadcast();

  @override
  void initState() {
    init();
    super.initState();
  }

  Future<void> init() async {
    watchTrip =
        fireStoreService.watchOnly(Collections.tripPlan, Get.arguments).listen(
      (event) {
        if (event.data() != null) {
          _streamController.sink
              .add(TripPlanModel.fromJson(event.data(), event.id));
        } else {
          watchTrip?.cancel();
          watchTrip = null;
          init();
        }
      },
    );
  }

  @override
  void dispose() {
    _streamController.sink.close();
    watchTrip?.cancel();
    watchTrip = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<TripPlanModel>(
        stream: _streamController.stream,
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data == null) return const SizedBox();
          final TripPlanModel _model = snapshot.data!;
          return Stack(
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
                                _model.tripName,
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
                                    _model.destination,
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
                                      DateTime.parse(_model.startDate),
                                    )} to ${DateFormat.MMMd().format(
                                      DateTime.parse(_model.endDate),
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
                      model: _model,
                    ),
                  )
                ],
              ),
              Positioned(
                top: context.width * 0.15,
                child: const StackAppBar(),
              ),
            ],
          );
        },
      ),
    );
  }
}
