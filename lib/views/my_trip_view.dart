import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:we_go/controller/app_controller.dart';
import 'package:we_go/global.dart';
import 'package:we_go/model/trip_plan_model.dart';
import 'package:we_go/routes/routes.dart';
import 'package:we_go/theme/appTheme.dart';
import 'package:we_go/utils/collection.dart';

class MyTripView extends StatefulWidget {
  const MyTripView({super.key});

  @override
  State<MyTripView> createState() => _MyTripViewState();
}

class _MyTripViewState extends State<MyTripView> {
  final AppController controller = Get.find<AppController>();
  final StreamController<List<TripPlanModel>> tripStream =
      StreamController.broadcast();

  @override
  void initState() {
    controller.tripStreamSubScription = fireStoreService
        .watchAll(
      Collections.tripPlan,
    )
        .listen(
      (event) {
        List<TripPlanModel> model = event.docs
            .map((e) => TripPlanModel.fromJson(e.data(), e.id))
            .toList();

        tripStream.sink.add(model);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<TripPlanModel>>(
      stream: tripStream.stream,
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.data == null) {
          return Center(
            child: Text(
              "No planned trips",
              style: AppTheme.welcomeTextStyle.copyWith(
                color: AppTheme.hintColor,
              ),
            ),
          );
        }
        List<TripPlanModel> model = snapshot.data!.toList();

        return ListView.builder(
          itemCount: model.length,
          itemBuilder: (_, i) {
            return GestureDetector(
              onTap: () {
                Get.toNamed(
                  AppRoutes.tripPlanScreen,
                  arguments: model[i],
                );
              },
              child: ListTile(
                title: Text(model[i].tripName),
                subtitle: Text(model[i].destination),
              ),
            );
          },
        );
      },
    );
  }
}
