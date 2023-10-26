import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:we_go/global.dart';
import 'package:we_go/model/firestore_model.dart';
import 'package:we_go/model/trip_plan_model.dart';
import 'package:we_go/model/user_model.dart';
import 'package:we_go/routes/routes.dart';
import 'package:we_go/utils/collection.dart';

enum AuthState {
  authorized,
  unauthorized,
  none,
}

class AppController extends GetxController {
  late final StreamSubscription<User?>? authStateSubScription;
  late final StreamSubscription<User?>? userStateSubScription;

  final Rx<AuthState> _authState = AuthState.none.obs;
  AuthState get authState => _authState.value;

  final Rx<UserModel> _loginUser = UserModel().obs;
  UserModel get loginUser => _loginUser.value;

  final RxInt _homeNavIndex = 0.obs;
  int get homeNaveIndex => _homeNavIndex.value;

  void bottomNav(int value) {
    _homeNavIndex.value = value;
  }

  final TextEditingController tripNameController = TextEditingController();
  final FocusNode tripNameFocusNode = FocusNode();

  final TextEditingController destinationsController = TextEditingController();
  final FocusNode destinationsFocusNode = FocusNode();

  final TextEditingController startDateController = TextEditingController();
  final FocusNode startDateFocusNode = FocusNode();

  final TextEditingController endDateController = TextEditingController();
  final FocusNode endDateFocusNode = FocusNode();

  final TextEditingController budgetController = TextEditingController();
  final FocusNode budgetFocusNode = FocusNode();

  final GlobalKey<FormState> tripPlanKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    authStateSubScription = authService.authStateChange().listen((event) {
      if (event != null) {
        _authState.value = AuthState.authorized;
        _loginUser.value = UserModel.withUser(event);
      } else {
        _authState.value = AuthState.unauthorized;
      }
    });
    userStateSubScription = authService.userChange().listen((event) {});
  }

  Future<void> logout() async {
    Get.toNamed(AppRoutes.wrapper);
    _loginUser.value = UserModel();
    authService.auth.signOut();
  }

  Future<void> saveToMyTrips() async {
    if (tripPlanKey.currentState?.validate() != true) return;
    final TripPlanModel savePlan = TripPlanModel(
      tripName: tripNameController.text,
      destination: destinationsController.text,
      startDate: startDateController.text,
      endDate: endDateController.text,
      budget: int.parse(budgetController.text),
    );
    await fireStoreService.write(
      FireStoreModel(
        collection: Collections.tripPlan,
        data: savePlan.toJson(),
      ),
    );
    print("success");
  }
}
