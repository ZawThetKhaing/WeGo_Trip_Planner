import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:we_go/global.dart';
import 'package:we_go/model/firestore_model.dart';
import 'package:we_go/model/trip_plan_model.dart';
import 'package:we_go/model/user_model.dart';
import 'package:we_go/routes/routes.dart';
import 'package:we_go/utils/collection.dart';
import 'package:we_go/utils/utils.dart';

enum AuthState {
  authorized,
  unauthorized,
  none,
}

class AppController extends GetxController {
  late StreamSubscription<User?>? authStateSubScription;
  late StreamSubscription<User?>? userStateSubScription;
  late StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>?
      userChangesSubScription;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
      tripStreamSubScription;

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

  final TextEditingController paymentDueDateController =
      TextEditingController();
  final FocusNode paymentDueDateFocusNode = FocusNode();

  GlobalKey<FormState>? tripPlanKey = GlobalKey<FormState>();

  Future<void> logout() async {
    authService.auth.signOut();
    _loginUser.value = UserModel();
    dispose();
    Get.toNamed(AppRoutes.wrapper);
  }

  Future<void> saveToMyTrips() async {
    if (tripPlanKey?.currentState?.validate() != true) return;
    final TripPlanModel savePlan = TripPlanModel(
      owner: loginUser.userName ?? '',
      tripName: tripNameController.text,
      destination: destinationsController.text,
      startDate: startDateController.text,
      endDate: endDateController.text,
      budget: int.parse(budgetController.text),
      paymentDueDate: paymentDueDateController.text,
    );
    await fireStoreService.write(
      FireStoreModel(
        collection: Collections.tripPlan,
        data: savePlan.toJson(),
      ),
    );
    Utils.toast("Success");
  }

  @override
  void onInit() {
    super.onInit();
    authStateSubScription = authService.authStateChange().listen(
      (event) {
        if (event != null) {
          _authState.value = AuthState.authorized;
        } else {
          _authState.value = AuthState.unauthorized;
          _loginUser.value = UserModel();
        }
      },
    );
    userStateSubScription = authService.userChange().listen(
      (event) {
        if (event != null) {
          userChangesSubScription =
              fireStoreService.watchOnly(Collections.user, event.uid).listen(
            (event) {
              if (event.exists == true) {
                _loginUser.value = UserModel.fromJson(event.data(), event.id);
              }
            },
          );
        }
      },
    );
  }

  @override
  void dispose() {
    userStateSubScription?.cancel();
    userStateSubScription = null;
    userChangesSubScription?.cancel();
    userChangesSubScription = null;
    tripStreamSubScription?.cancel();
    tripStreamSubScription = null;

    tripPlanKey = null;
    tripPlanKey = GlobalKey<FormState>();
    tripNameController.dispose();
    tripNameFocusNode.dispose();
    destinationsController.dispose();
    destinationsFocusNode.dispose();
    startDateController.dispose();
    startDateFocusNode.dispose();
    endDateController.dispose();
    endDateFocusNode.dispose();
    budgetController.dispose();
    budgetFocusNode.dispose();
    paymentDueDateController.dispose();
    paymentDueDateFocusNode.dispose();
    super.dispose();
  }
}
