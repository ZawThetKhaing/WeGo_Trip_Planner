import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:we_go/controller/app_controller.dart';
import 'package:we_go/global.dart';
import 'package:we_go/model/trip_plan_model.dart';
import 'package:we_go/routes/routes.dart';
import 'package:we_go/theme/appTheme.dart';
import 'package:we_go/utils/collection.dart';
import 'package:we_go/widgets/myTrip_grid_card.dart';

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
            return element.owner.uid == appController.loginUser.uid ||
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
        if (snapshot.data == null || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('No trip plans.'),
          );
        }

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "My Trips",
                      style: AppTheme.largeTextStyle.copyWith(
                        color: AppTheme.textColor1,
                      ),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    Text(
                      "Participated Trips",
                      style: AppTheme.largeTextStyle.copyWith(
                        color: const Color.fromRGBO(34, 58, 41, 0.25),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: GridView.builder(
                    itemCount: _myTripPlanList.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    padding: const EdgeInsets.all(10),
                    itemBuilder: (_, i) {
                      _myTripPlanList.sort(
                        (a, b) => a.createdAt.compareTo(b.createdAt),
                      );
                      return Center(
                        child: MyTripsGridCard(
                          model: _myTripPlanList[i],
                          onTap: () {
                            Get.toNamed(
                              AppRoutes.tripPlanScreen,
                              arguments: _myTripPlanList[i].id,
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
