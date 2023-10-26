import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:we_go/global.dart';
import 'package:we_go/routes/routes.dart';

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

  final GlobalKey<FormState> loginKey = GlobalKey<FormState>();
  final GlobalKey<FormState> signUpKey = GlobalKey<FormState>();

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
  }

  Future<void> loginWithEmail() async {
    if (loginKey.currentState?.validate() != true) return;
    try {
      UserCredential user = await authService.auth.signInWithEmailAndPassword(
        email: loginEmailController.text,
        password: loginPasswordController.text,
      );
    } on FirebaseAuthException catch (e) {
      print("login in error  ${e.message}");
    }
    Get.toNamed(AppRoutes.wrapper);
  }

  Future<void> signupWithEmail() async {
    if (signUpKey.currentState?.validate() != true) return;
    try {
      UserCredential user =
          await authService.auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
    } catch (e) {
      print("sign in error $e");
    }
    Get.toNamed(AppRoutes.wrapper);
  }

  final RxBool _isObsecure = false.obs;
  bool get isObsecure => _isObsecure.value;

  void isObsecureText() {
    _isObsecure.value = !_isObsecure.value;
    update(['obsecure_widget']);
  }
}
