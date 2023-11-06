import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:we_go/global.dart';
import 'package:we_go/model/firestore_model.dart';
import 'package:we_go/model/trip_plan_model.dart';
import 'package:we_go/model/user_model.dart';
import 'package:we_go/utils/collection.dart';
import 'package:we_go/utils/utils.dart';

class TripPlanController extends GetxController {
  late StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
      allUserSubScription;

  final RxList<UserModel> _allUser = <UserModel>[].obs;
  List<UserModel> get allUser => _allUser;

  final RxList<UserModel> _selectedUserList = <UserModel>[].obs;
  List<UserModel> get selectedUserList => _selectedUserList;

  final TextEditingController addPlanTitleController = TextEditingController();
  final TextEditingController addPlanContentController =
      TextEditingController();
  final TextEditingController addPlanAddLinkController =
      TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final RxInt days = 1.obs;
  void dropDownChange(int? value) {
    days.value = value ?? 0;
    update(['drop_down_widget']);
  }

  void selectFriend(UserModel model, int i) {
    if (_selectedUserList.contains(model)) {
      _selectedUserList.remove(model);
    } else {
      _selectedUserList.add(model);
    }
    update(['radio_button $i']);
  }

  Future<void> like(
    TripPlanModel model,
    String uid,
    Plans plan,
  ) async {
    final List<Plans> initialPlans = model.plans!.toList();

    List<String> initialLikes = plan.likes.toList();
    initialPlans.remove(plan);

    if (initialLikes.contains(uid)) {
      initialLikes.remove(uid);
    } else {
      initialLikes.add(uid);
    }
    plan = Plans(
      id: plan.id,
      day: plan.day,
      title: plan.title,
      content: plan.content,
      likes: initialLikes,
      unlikes: plan.unlikes,
      createdAt: plan.createdAt,
    );

    initialPlans.add(plan);

    await fireStoreService.update(
      FireStoreModel(
        collection: Collections.tripPlan,
        doc: model.id,
        data: {
          'plans': initialPlans.map((e) => e.toJson()),
        },
      ),
    );
  }

  Future<void> disLike(
    TripPlanModel model,
    String uid,
    Plans plan,
  ) async {
    final List<Plans> initialPlans = model.plans!.toList();

    List<String> initialDisLike = plan.unlikes.toList();
    initialPlans.remove(plan);

    if (initialDisLike.contains(uid)) {
      initialDisLike.remove(uid);
    } else {
      initialDisLike.add(uid);
    }
    plan = Plans(
      id: plan.id,
      day: plan.day,
      title: plan.title,
      content: plan.content,
      likes: plan.likes,
      unlikes: initialDisLike,
      createdAt: plan.createdAt,
    );

    initialPlans.add(plan);

    await fireStoreService.update(
      FireStoreModel(
        collection: Collections.tripPlan,
        doc: model.id,
        data: {
          'plans': initialPlans.map((e) => e.toJson()),
        },
      ),
    );
  }

  Future<void> addPlan(TripPlanModel model) async {
    final List<Plans> initialPlans = model.plans ?? [];

    final Plans currentPlan = Plans(
      id: '${days.value}${Random.secure().nextInt(100000)}${DateTime.now()}',
      day: days.value,
      title: addPlanTitleController.text,
      content: addPlanContentController.text,
      likes: [],
      unlikes: [],
      createdAt: DateTime.now(),
    );

    initialPlans.add(currentPlan);
    await fireStoreService.update(
      FireStoreModel(
        collection: Collections.tripPlan,
        doc: model.id,
        data: {
          'plans': initialPlans.map((e) => e.toJson()),
        },
      ),
    );
    addPlanAddLinkController.clear();
    addPlanContentController.clear();
    addPlanTitleController.clear();
    Utils.toast("Successfully added");
    Get.back();
  }

  Future<void> removeFriend(TripPlanModel model, String id) async {
    List<UserModel> _participant = model.participants?.toList() ?? [];
    _participant.remove(UserModel(uid: id));
    await fireStoreService.update(
      FireStoreModel(
        collection: Collections.tripPlan,
        doc: model.id,
        data: {
          'participants': _participant.map(
            (e) => e.toInvite(),
          ),
        },
      ),
    );
  }

  Future<void> addInviteFriend(TripPlanModel model) async {
    List<UserModel> _participant = model.participants?.toList() ?? [];

    for (UserModel selectedUser in selectedUserList) {
      if (_participant.contains(selectedUser)) {
        _participant.remove(selectedUser);
      }
    }
    _participant.addAll(selectedUserList);
    await fireStoreService.update(
      FireStoreModel(
        collection: Collections.tripPlan,
        doc: model.id,
        data: {
          'participants': _participant.map(
            (e) => e.toInvite(),
          ),
        },
      ),
    );
    _selectedUserList.value = [];
    Get.back();
    Utils.toast("Successfully added");
  }

  @override
  void onInit() {
    super.onInit();
    allUserSubScription = fireStoreService.watchAll(Collections.user).listen(
      (event) {
        _allUser.value =
            event.docs.map((e) => UserModel.fromJson(e.data(), e.id)).toList();
      },
    );

//
  }

  @override
  void onClose() {
    allUserSubScription?.cancel();
    allUserSubScription = null;
    super.onClose();
  }
}
