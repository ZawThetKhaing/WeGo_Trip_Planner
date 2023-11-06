import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:we_go/controller/app_controller.dart';
import 'package:we_go/global.dart';
import 'package:we_go/model/trip_plan_model.dart';
import 'package:we_go/routes/routes.dart';
import 'package:we_go/utils/collection.dart';

class MyTripView extends StatefulWidget {
  const MyTripView({super.key});

  @override
  State<MyTripView> createState() => _MyTripViewState();
}

class _MyTripViewState extends State<MyTripView> {
  final AppController appController = Get.find<AppController>();
  List<TripPlanModel> _myTripPlanList = [];
  final StreamController<List<TripPlanModel>> _streamController =
      StreamController.broadcast();
  @override
  void initState() {
    fireStoreService
        .watchAll(
      Collections.tripPlan,
    )
        .listen(
      (event) {
        _myTripPlanList = event.docs
            .map(
              (e) => TripPlanModel.fromJson(
                e.data(),
                e.id,
              ),
            )
            .toList();

        _myTripPlanList = _myTripPlanList.where(
          (element) {
            if (element.participants == null) return false;
            return element.ownerId == appController.loginUser.uid ||
                (element.participants ?? []).contains(appController.loginUser);
          },
        ).toList();
        _streamController.sink.add(_myTripPlanList);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<TripPlanModel>>(
        stream: _streamController.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data == null) {
            return const Center(
              child: Text('No trip plans.'),
            );
          }

          return ListView.builder(
            itemCount: _myTripPlanList.length,
            itemBuilder: (_, i) {
              final TripPlanModel _selectedModel = snapshot.data![i];

              return GestureDetector(
                onTap: () {
                  Get.toNamed(
                    AppRoutes.tripPlanScreen,
                    arguments: _selectedModel.id,
                  );
                },
                child: ListTile(
                  title: Text(_selectedModel.tripName),
                  subtitle: Text(_selectedModel.destination),
                ),
              );
            },
          );
        });
  }
}
