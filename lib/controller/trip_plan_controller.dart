import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:we_go/global.dart';
import 'package:we_go/model/firestore_model.dart';
import 'package:we_go/model/notification_model.dart';
import 'package:we_go/model/trip_plan_model.dart';
import 'package:we_go/model/user_model.dart';
import 'package:we_go/utils/collection.dart';
import 'package:we_go/utils/utils.dart';

class TripPlanController extends GetxController {
  late StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
      allUserSubScription;

  final RxList<UserModel> _allUser = <UserModel>[].obs;
  List<UserModel> get allUser => _allUser;

  RxList<UserModel> selectedUserList = <UserModel>[].obs;

  final TextEditingController addPlanTitleController = TextEditingController();
  final TextEditingController addPlanContentController =
      TextEditingController();
  final TextEditingController addPlanAddLinkController =
      TextEditingController();

  final TextEditingController budgetEntryController = TextEditingController();
  final FocusNode tripPlanFocusNode = FocusNode();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isUploading = false;

  final RxInt days = 1.obs;
  void dropDownChange(int? value) {
    days.value = value ?? 0;
    update(['drop_down_widget']);
  }

  void selectFriend(UserModel model, int i) {
    if (selectedUserList.contains(model)) {
      selectedUserList.remove(model);
    } else {
      selectedUserList.add(model);
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
    if (formKey.currentState?.validate() != true) return;
    if (isUploading) return;
    isUploading = true;
    Get.back();
    Utils.toast("Uploading");
    final List<Plans> initialPlans = model.plans ?? [];
    final List<Future<String>> uploadTasks = [];
    if (addPlansImages.isNotEmpty) {
      for (XFile photoFile in addPlansImages) {
        uploadTasks.add(
          fireBaseStorageService.upload(
            path:
                'trip_plan/${model.id}/plan_day_$days/${photoFile.name} ${DateTime.now()}.jpg',
            file: photoFile,
            url: '',
          ),
        );
      }
    }
    final List<String> downLoadLink = await Future.wait(uploadTasks);
    final Plans currentPlan = Plans(
      id: '${days.value}${Random.secure().nextInt(100000)}${DateTime.now()}',
      day: days.value,
      title: addPlanTitleController.text,
      content: addPlanContentController.text,
      likes: [],
      unlikes: [],
      photos: downLoadLink,
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

    isUploading = false;
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
    final List<UserModel> forNoti = [];

    for (UserModel selectedUser in selectedUserList) {
      if (_participant.contains(selectedUser)) {
        _participant.remove(selectedUser);
      } else {
        forNoti.add(selectedUser);
      }
    }
    _participant.addAll(selectedUserList);
    print(forNoti.length);
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

    if (forNoti.isNotEmpty) {
      NotificationModel notificationModel =
          NotificationModel.forAllParticipants(
        senderName: authService.auth.currentUser!.displayName ?? 'Anonymous',
        senderId: authService.auth.currentUser!.uid,
        receivers: forNoti.map((e) => e.uid).toList(),
        message: ' invited you to the trip ',
        content: model.tripName,
      );

      await fireStoreService.write(
        FireStoreModel(
            collection: Collections.notification,
            data: notificationModel.toJson()),
      );
    }
    selectedUserList.value = <UserModel>[];
    Get.back();
    Utils.toast("Successfully added");
  }

  final Rx<XFile> pickedImage = XFile('').obs;
  Future<void> pickImage(TripPlanModel model) async {
    if (isUploading) return;
    isUploading = true;
    XFile? pickImage = await imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickImage != null) {
      pickedImage.value = pickImage;
      update(['trip_plan_background_image']);
    }

    final String downloadLink = await fireBaseStorageService.upload(
      path: 'trip_plan/${model.id}/plan_background_photo/${DateTime.now()}.jpg',
      file: pickedImage.value,
      url: model.backGroundPhoto ?? '',
    );
    if (downloadLink.isNotEmpty) {
      await fireStoreService.update(
        FireStoreModel(
          collection: Collections.tripPlan,
          doc: model.id,
          data: {'background_photo': downloadLink},
        ),
      );
    } else {
      isUploading = false;

      return;
    }
    isUploading = false;
  }

  final RxList<XFile> addPlansImages = <XFile>[].obs;

  Future<void> pickAddPlansImages(
    TripPlanModel model,
  ) async {
    final XFile? pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage == null) return;
    addPlansImages.add(pickedImage);
    update(['add_plan_pick_images']);
  }

  Future<void> paid(
    TripPlanModel tripPlanModel,
    UserModel userModel,
    String paidStatus,
  ) async {
    UserModel selectedUserModel;
    selectedUserModel = tripPlanModel.participants!.firstWhere(
      (UserModel element) => element == userModel,
    );

    if (paidStatus == Collections.paid) {
      selectedUserModel = UserModel.forBudgetPaid(selectedUserModel).copyWith(
        data: UserModel(
          budgetPaidStatus: Collections.paid,
          budgetPaid: tripPlanModel.budget,
        ),
      );
    } else if (paidStatus == Collections.halfPaid) {
      selectedUserModel = UserModel.forBudgetPaid(selectedUserModel).copyWith(
        data: UserModel(
          budgetPaidStatus: Collections.halfPaid,
          budgetPaid: int.parse(budgetEntryController.text),
        ),
      );
      Get.back();
    } else {
      selectedUserModel = UserModel.forBudgetPaid(selectedUserModel).copyWith(
        data: UserModel(
          budgetPaidStatus: Collections.unPaid,
          budgetPaid: 0,
        ),
      );
    }

    tripPlanModel.participants!.remove(userModel);
    tripPlanModel.participants!.add(selectedUserModel);

    await fireStoreService.update(
      FireStoreModel(
        collection: Collections.tripPlan,
        doc: tripPlanModel.id,
        data: tripPlanModel.toJson(),
      ),
    );
  }

  @override
  void onInit() {
    super.onInit();
    allUserSubScription = fireStoreService.watchAll(Collections.user).listen(
      (event) {
        _allUser.value = event.docs.map((e) {
          return UserModel.fromJson(e.data(), e.id);
        }).toList();
      },
    );
  }

  @override
  void onClose() {
    allUserSubScription?.cancel();
    allUserSubScription = null;
    super.onClose();
  }
}
