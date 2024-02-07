import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:we_go/global.dart';
import 'package:we_go/model/firestore_model.dart';
import 'package:we_go/model/notification_model.dart';
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

class AppController extends GetxController with AppMixin {
  ///Bottom Navigation Controller
  void bottomNav(int value) {
    _homeNavIndex.value = value;
    if (value == 2) {
      if (notificationReceived.isTrue) {
        List<Future> toUpdate = [];

        for (NotificationModel noti in receivingNoti) {
          if (noti.id != null) {
            toUpdate.add(
              fireStoreService.update(
                FireStoreModel(
                  collection: Collections.notification,
                  doc: noti.id,
                  data: {'isRead': true},
                ),
              ),
            );
          }
        }

        if (toUpdate.isNotEmpty) {
          Future.wait(toUpdate).whenComplete(
            () {
              update(['app_bottom_nav_bar']);
              notificationReceived.value = false;
            },
          );
        }
      }
    }
    update(['app_bottom_nav_bar']);
  }

  ///Date time picker
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

  ///Contact us
  Future<void> contactUs() async {
    String? encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map((MapEntry<String, String> e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }

// ···
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'zawthetkhaing2000@gmail.com',
      query: encodeQueryParameters(<String, String>{
        'subject': 'Example Subject & Symbols are allowed!',
      }),
    );

    launchUrl(emailLaunchUri);
  }

  ///Copy email
  void copyEmail() {
    Clipboard.setData(ClipboardData(text: loginUser.value.email ?? ''));
    Utils.toast("Copy");
  }

  ///Logout
  Future<void> logout() async {
    authService.auth.signOut();

    dispose();
    _authState.value = AuthState.unauthorized;
    Get.toNamed(AppRoutes.wrapper);
    loginUser.value = UserModel();
  }

  /// Reset plan input
  void clear() {
    tripNameController.clear();
    destinationsController.clear();
    budgetController.clear();
    dateTimepicker.value = '';
    update(['end_date', 'start_date', 'payment_due_date']);
  }

  /// Change password
  Future<void> changePassword() async {
    if (isUploading == true) return;
    if (changePasswordKey?.currentState?.validate() == false) return;
    confirmPasswordFocusNode.unfocus();

    isUploading = true;
    try {
      await authService.auth.signInWithEmailAndPassword(
          email: loginUser.value.email!, password: oldPasswordController.text);
      authService.auth.currentUser!.updatePassword(newPasswordController.text);
    } catch (e) {
      isUploading = false;
      confirmPasswordFocusNode.unfocus();
      Utils.toast("Invalid password !");
      return;
    }
    Utils.toast("Password successfully change");

    isUploading = false;
    Get.back();
  }

  /// Profile picture picker
  Future<void> editProfilePicImagePicker() async {
    if (isUploading == true) return;

    isUploading = true;
    final XFile? pickImage =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickImage == null) return;
    editProfilePic.value = pickImage;
    update(['edit_profile_pic']);
    isUploading = false;
  }

  /// Edit Profile
  Future<void> editProfile() async {
    if (isUploading == true) return;
    isUploading = true;
    String? downLoadLink;
    List<Future>? tasks = [];

    if (editProfileUserNameController.text.isNotEmpty &&
        editProfileUserNameController.text != loginUser.value.userName) {
      tasks.add(
        authService.auth.currentUser!
            .updateDisplayName(editProfileUserNameController.text),
      );

      tasks.add(
        fireStoreService.update(
          FireStoreModel(
            collection: Collections.user,
            doc: loginUser.value.uid,
            data: {
              'user_name': editProfileUserNameController.text,
            },
          ),
        ),
      );
    }
    if (editProfilePic.value.path.isNotEmpty) {
      downLoadLink = await fireBaseStorageService.upload(
        path:
            'profile/${loginUser.value.uid}/${editProfilePic.value.name}${DateTime.now()}.jpg',
        file: editProfilePic.value,
        url: loginUser.value.profilePhoto,
      );
      await fireStoreService.update(
        FireStoreModel(
          collection: Collections.user,
          doc: loginUser.value.uid,
          data: {'profile_photo': downLoadLink},
        ),
      );
    }
    isUploading = false;
    Get.back();
  }

  /// Write Trip Plan to server
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
      owner: loginUser.value.copyWith(
        data: UserModel(
          budgetPaid: int.parse(budgetController.text),
          budgetPaidStatus: Collections.paid,
        ),
      ),
      tripName: tripNameController.text,
      destination: destinationsController.text,
      startDate: startDate!,
      endDate: endDate!,
      budget: int.parse(budgetController.text),
      paymentDueDate: paymentDate!,
      participants: [],
    );
    final String doc =
        '${loginUser.value.uid}${tripNameController.text}${DateTime.now().toString()}';
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

    ///Listen Notifications
    if (authService.auth.currentUser?.uid != null) {
      watchNotification =
          fireStoreService.watchAll(Collections.notification).listen(
        (event) {
          List<NotificationModel> allNoti = event.docs.map(
            (e) {
              return NotificationModel.fromJson(e.data(), e.id);
            },
          ).toList();

          List<NotificationModel> finalNoti = allNoti
              .where(
                (element) => element.receivers
                    .contains(authService.auth.currentUser!.uid),
              )
              .toList();

          for (NotificationModel noti in finalNoti) {
            if (noti.isread != true) receivingNoti.add(noti);
          }

          notificationReceived.value = receivingNoti.isNotEmpty;
          update(['app_bottom_nav_bar']);
        },
      );
    }
    authStateSubScription = authService.authStateChange().listen(
      (event) {
        if (event != null) {
          _authState.value = AuthState.authorized;
        } else {
          _authState.value = AuthState.unauthorized;
          loginUser.value = UserModel();
        }
      },
    );

    userStateSubScription = authService.userChange().listen(
      (event) async {
        if (event != null) {
          fireStoreService.watchOnly(Collections.user, event.uid).listen(
            (value) {
              loginUser.value = UserModel.fromJson(
                value.data(),
                value.id,
              );
            },
          );
        }
      },
    );
  }

  @override
  void dispose() {
    disposed();
    super.dispose();
  }
}

mixin class AppMixin {
  late StreamSubscription<User?>? authStateSubScription;
  late StreamSubscription<User?>? userStateSubScription;
  late StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
      watchNotification;

  final TextEditingController tripNameController = TextEditingController();
  final FocusNode tripNameFocusNode = FocusNode();

  final TextEditingController destinationsController = TextEditingController();
  final FocusNode destinationsFocusNode = FocusNode();

  final TextEditingController budgetController = TextEditingController();
  final FocusNode budgetFocusNode = FocusNode();

  final TextEditingController editProfileUserNameController =
      TextEditingController();
  final TextEditingController oldPasswordController = TextEditingController();

  final FocusNode newPasswordFocusNode = FocusNode();
  final TextEditingController newPasswordController = TextEditingController();

  final FocusNode confirmPasswordFocusNode = FocusNode();
  final TextEditingController confrimPasswordController =
      TextEditingController();

  final Rx<AuthState> _authState = AuthState.none.obs;
  AuthState get authState => _authState.value;

  GlobalKey<FormState>? tripPlanKey = GlobalKey<FormState>();
  GlobalKey<FormState>? changePasswordKey = GlobalKey<FormState>();

  String? startDate;
  String? endDate;
  String? paymentDate;

  List<NotificationModel> receivingNoti = [];

  bool isUploading = false;

  final RxBool isError = false.obs;

  final RxBool notificationReceived = false.obs;

  final Rx<XFile> editProfilePic = XFile("").obs;

  final RxString dateTimepicker = ''.obs;

  final Rx<UserModel> loginUser = UserModel().obs;

  final RxInt _homeNavIndex = 0.obs;
  int get homeNaveIndex => _homeNavIndex.value;

  void disposed() {
    watchNotification?.cancel();
    watchNotification = null;
    userStateSubScription?.cancel();
    userStateSubScription = null;
    tripPlanKey = null;
    tripPlanKey = GlobalKey<FormState>();
    changePasswordKey = null;
    changePasswordKey = GlobalKey<FormState>();
    tripNameController.dispose();
    tripNameFocusNode.dispose();
    destinationsController.dispose();
    destinationsFocusNode.dispose();
    budgetController.dispose();
    budgetFocusNode.dispose();
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confrimPasswordController.dispose();
    newPasswordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
  }
}
