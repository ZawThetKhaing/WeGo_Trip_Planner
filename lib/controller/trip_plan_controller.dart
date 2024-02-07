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

class TripPlanController extends GetxController with TripPlanMixin {
  ///Dropdown Ui Control
  void dropDownChange(int? value) {
    days.value = value ?? 0;
    update(['drop_down_widget']);
  }

  ///Select friends to invite
  void selectFriend(UserModel model, int i) {
    if (selectedUserList.contains(model)) {
      selectedUserList.remove(model);
    } else {
      selectedUserList.add(model);
    }
    update(['radio_button $i']);
  }

  ///Add friends (Access all participants)
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

  ///Remove existing friend (Access Trip Creater Only)
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

  ///Like plan
  Future<void> like(
    TripPlanModel model,
    String uid,
    Plans plan,
    String day,
  ) async {
    final List<PlanDays> initialPlans = model.plans!.toList();

    PlanDays? planDay = initialPlans.firstWhereOrNull((e) => e.day == day);
    planDay!.plans.remove(plan);
    initialPlans.remove(planDay);
    List<String> initialLikes = plan.likes.toList();

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
      photos: plan.photos,
      relatedLink: plan.relatedLink,
    );

    planDay.plans.add(plan);

    initialPlans.add(planDay);

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

  ///Dislike lan
  Future<void> disLike(
    TripPlanModel model,
    String uid,
    Plans plan,
    String day,
  ) async {
    List<String> initialDisLike = plan.unlikes.toList();
    final List<PlanDays> initialPlans = model.plans!.toList();

    PlanDays? planDay = initialPlans.firstWhereOrNull((e) => e.day == day);
    planDay!.plans.remove(plan);
    initialPlans.remove(planDay);

    if (initialDisLike.contains(uid)) {
      initialDisLike.remove(uid);
    } else {
      initialDisLike.add(uid);
    }
    plan = Plans(
      id: plan.id,
      day: plan.day,
      title: plan.title,
      relatedLink: plan.relatedLink,
      content: plan.content,
      likes: plan.likes,
      unlikes: initialDisLike,
      createdAt: plan.createdAt,
      photos: plan.photos,
    );

    planDay.plans.add(plan);
    initialPlans.add(planDay);

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

  ///Add plans
  Future<void> addPlan(TripPlanModel model) async {
    if (formKey?.currentState?.validate() != true) return;
    if (isUploading) return;
    isUploading = true;
    Get.back();
    Utils.toast("Uploading");
    final List<PlanDays> initialPlans = model.plans ?? [];
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
      relatedLink: addPlanAddLinkController.text,
      likes: [],
      unlikes: [],
      photos: downLoadLink,
      createdAt: DateTime.now(),
    );

    final PlanDays? abc = initialPlans
        .where((element) => element.day == days.value.toString())
        .firstOrNull;

    if (abc != null) {
      abc.plans.add(currentPlan);
    } else {
      initialPlans.add(
        PlanDays(
          day: days.value.toString(),
          plans: [
            currentPlan,
          ],
        ),
      );
    }

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
    addPlansImages.clear();
    Utils.toast("Successfully added");
    isUploading = false;
  }

  ///Change trip plan background image
  Future<void> tripPlanBgImageChange(TripPlanModel model) async {
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

  ///Remove picked image before adding to plans
  void removePickImage(XFile file) {
    addPlansImages.remove(
      file,
    );
    update(['add_plan_pick_images']);
  }

  ///Pick image before adding to plans
  Future<void> pickAddPlansImages(
    TripPlanModel model,
  ) async {
    final XFile? pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage == null) return;
    addPlansImages.add(pickedImage);
    update(['add_plan_pick_images']);
  }

  ///Budget reminder notification
  Future<void> budgetNotification(TripPlanModel model, UserModel toWho) async {
    final List<UserModel> forNoti = [toWho];
    NotificationModel notificationModel = NotificationModel.forAllParticipants(
      senderName: authService.auth.currentUser!.displayName ?? 'Anonymous',
      senderId: authService.auth.currentUser!.uid,
      receivers: forNoti.map((e) => e.uid).toList(),
      message: ' reminded you to pay budget for ',
      content: model.tripName,
    );

    await fireStoreService.write(
      FireStoreModel(
          collection: Collections.notification,
          data: notificationModel.toJson()),
    );
    Utils.toast("Notified !");
  }

  ///Slideable function for budget paid
  Future<void> paidBudget(
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

    /// Listen all users for invitation friends
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
    disposed();
    super.onClose();
  }
}

abstract mixin class TripPlanMixin {
  late StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
      allUserSubScription;

  final TextEditingController addPlanTitleController = TextEditingController();
  final TextEditingController addPlanContentController =
      TextEditingController();
  final TextEditingController addPlanAddLinkController =
      TextEditingController();

  final TextEditingController budgetEntryController = TextEditingController();
  final FocusNode tripPlanFocusNode = FocusNode();
  GlobalKey<FormState>? formKey = GlobalKey<FormState>();

  final RxList<UserModel> _allUser = <UserModel>[].obs;
  List<UserModel> get allUser => _allUser;

  RxList<UserModel> selectedUserList = <UserModel>[].obs;

  final Rx<XFile> pickedImage = XFile('').obs;

  final RxList<XFile> addPlansImages = <XFile>[].obs;

  final RxInt days = 1.obs;

  bool isUploading = false;

  void disposed() {
    allUserSubScription?.cancel();
    allUserSubScription = null;
    formKey = null;
    formKey = GlobalKey<FormState>();
    addPlanTitleController.dispose();
    addPlanContentController.dispose();
    addPlanAddLinkController.dispose();
    budgetEntryController.dispose();
    tripPlanFocusNode.dispose();
  }
}
