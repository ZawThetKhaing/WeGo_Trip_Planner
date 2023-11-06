import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:we_go/global.dart';
import 'package:we_go/model/firestore_model.dart';
import 'package:we_go/model/user_model.dart';
import 'package:we_go/routes/routes.dart';
import 'package:we_go/utils/collection.dart';
import 'package:we_go/utils/utils.dart';

class LoginController extends GetxController {
  final TextEditingController userNameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();
  final FocusNode emailFocusNode = FocusNode();

  final TextEditingController passwordController = TextEditingController();
  final FocusNode passwordFocusNode = FocusNode();

  final TextEditingController phoneController = TextEditingController();
  final FocusNode phoneFocusNode = FocusNode();

  final TextEditingController confirmPasswordController =
      TextEditingController();
  final FocusNode confirmPasswordFocusNode = FocusNode();

  final TextEditingController loginEmailController = TextEditingController();

  final FocusNode loginEmailFocusNode = FocusNode();

  final TextEditingController loginPasswordController = TextEditingController();
  final FocusNode loginPasswordFocusNode = FocusNode();

  GlobalKey<FormState>? loginKey = GlobalKey<FormState>();
  GlobalKey<FormState>? signUpKey = GlobalKey<FormState>();

  Future<void> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential

    UserCredential user =
        await authService.auth.signInWithCredential(credential);

    Get.toNamed(AppRoutes.wrapper);
    afterAuth(user);
  }

  Future<void> loginWithEmail() async {
    loginPasswordFocusNode.unfocus();
    if (loginKey?.currentState?.validate() != true) return;
    try {
      await authService.auth.signInWithEmailAndPassword(
        email: loginEmailController.text,
        password: loginPasswordController.text,
      );
    } on FirebaseAuthException catch (e) {
      print(e);
      Utils.toast('email or password is invalid !');
      return;
    }

    Get.toNamed(AppRoutes.wrapper);
    afterAuth();
  }

  Future<void> signupWithEmail() async {
    confirmPasswordFocusNode.unfocus();
    if (signUpKey?.currentState?.validate() != true) return;
    try {
      await authService.auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      authService.auth.currentUser?.updateDisplayName(userNameController.text);
    } on FirebaseAuthException catch (e) {
      e.message;
      Utils.toast('email or password is invalid !');

      return;
    }

    Get.toNamed(AppRoutes.wrapper);
    afterAuth();
  }

  Future<void> afterAuth([UserCredential? userCredential]) async {
    final User? currentUser =
        authService.auth.currentUser ?? userCredential?.user;
    if (currentUser == null) return;
    DocumentSnapshot<Map<String, dynamic>> fireData =
        await fireStoreService.readOnly(
      Collections.user,
      currentUser.uid,
    );
    UserModel loginUser = UserModel();

    ///New user
    if (fireData.data() == null) {
      print("AuthState new user");
      loginUser = UserModel(
        userName: currentUser.displayName ?? userNameController.text,
        phoneNumber: currentUser.phoneNumber ?? phoneController.text,
        profilePhoto: currentUser.photoURL,
        email: currentUser.email,
        uid: fireData.id,
      );

      await fireStoreService.write(
        FireStoreModel(
          collection: Collections.user,
          doc: currentUser.uid,
          data: loginUser.toJson(),
        ),
      );
    } else {
      ///Existing user
      /// if need to update ToDO ::
      /// add fcm token later
      print("AuthState existing user");

      await fireStoreService.update(
        FireStoreModel(
          collection: Collections.user,
          doc: currentUser.uid,
          data: {'fcm': ''},
        ),
      );
    }
  }

  final RxBool _isObsecure = true.obs;
  bool get isObsecure => _isObsecure.value;

  void isObsecureText(String key) {
    _isObsecure.value = !_isObsecure.value;
    update(["obsecure_widget $key"]);
  }

  @override
  void dispose() {
    loginKey = null;
    loginKey = GlobalKey();

    signUpKey = null;
    signUpKey = GlobalKey();

    loginEmailController.dispose();
    loginEmailFocusNode.dispose();
    loginPasswordController.dispose();
    loginPasswordFocusNode.dispose();
    userNameController.dispose();
    emailController.dispose();
    emailFocusNode.dispose();
    phoneController.dispose();
    phoneFocusNode.dispose();
    passwordController.dispose();
    passwordFocusNode.dispose();
    confirmPasswordController.dispose();
    confirmPasswordFocusNode.dispose();
    super.dispose();
  }
}
