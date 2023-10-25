import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:social_hub/global.dart';
import 'package:social_hub/model/user_model.dart';
import 'package:social_hub/routes/routes.dart';

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
}
