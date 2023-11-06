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

  final TextEditingController budgetController = TextEditingController();
  final FocusNode budgetFocusNode = FocusNode();

  GlobalKey<FormState>? tripPlanKey = GlobalKey<FormState>();

  String? startDate;
  String? endDate;
  String? paymentDate;

  final RxBool isError = false.obs;

  final RxString dateTimepicker = ''.obs;
  void pickDateTime(String date, String widgetId) {
    dateTimepicker.value = date;
    if (widgetId == 'start_date') {
      startDate = date;
    } else if (widgetId == 'end_date') {
      endDate = date;
    } else if (widgetId == 'payment_due_date') {
      paymentDate = date;
    }
    update([widgetId]);
  }

  bool isUploading = false;

  Future<void> logout() async {
    authService.auth.signOut();
    _loginUser.value = UserModel();
    dispose();
    Get.toNamed(AppRoutes.wrapper);
  }

  void clear() {
    tripNameController.clear();
    destinationsController.clear();
    budgetController.clear();
    dateTimepicker.value = '';
    update(['end_date', 'start_date', 'payment_due_date']);
  }

  Future<void> saveToMyTrips() async {
    if (tripPlanKey?.currentState?.validate() != true) return;
    if (startDate == null) {
      isError.value = true;
      update(['start_date']);
      return;
    } else {
      isError.value = false;
      update(['start_date']);
    }
    if (endDate == null) {
      isError.value = true;
      update(['end_date']);
      return;
    } else {
      isError.value = false;
      update(['end_date']);
    }
    if (paymentDate == null) {
      isError.value = true;
      update(['payment_due_date']);
      return;
    } else {
      isError.value = false;
      update(['payment_due_date']);
    }
    try {
      DateTimeRange(
        start: DateTime.parse(startDate!),
        end: DateTime.parse(endDate!),
      ).duration.inDays;
    } catch (e) {
      return Get.defaultDialog(
        title: "Trip create failed !",
        middleText: "Start date can't be later than end date.",
      );
    }

    if (isUploading == true) return;

    isUploading = true;

    final TripPlanModel savePlan = TripPlanModel(
      owner: loginUser.userName ?? '',
      ownerId: loginUser.uid,
      tripName: tripNameController.text,
      destination: destinationsController.text,
      startDate: startDate!,
      endDate: endDate!,
      budget: int.parse(budgetController.text),
      paymentDueDate: paymentDate!,
      participants: [],
    );
    final String doc =
        '${loginUser.uid}${tripNameController.text}${DateTime.now().toString()}';
    try {
      await fireStoreService.write(
        FireStoreModel(
          collection: Collections.tripPlan,
          doc: doc,
          data: savePlan.toJson(),
        ),
      );
    } catch (e) {
      Utils.toast("Failed");
      return;
    }
    Utils.toast("Success");
    Get.toNamed(
      AppRoutes.tripPlanScreen,
      arguments: doc,
    );
    clear();
    isUploading = false;
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
    tripPlanKey = null;
    tripPlanKey = GlobalKey<FormState>();
    tripNameController.dispose();
    tripNameFocusNode.dispose();
    destinationsController.dispose();
    destinationsFocusNode.dispose();
    budgetController.dispose();
    budgetFocusNode.dispose();
    super.dispose();
  }
}
