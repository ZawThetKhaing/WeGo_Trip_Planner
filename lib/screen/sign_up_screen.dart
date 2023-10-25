import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_hub/controller/login_controller.dart';
import 'package:social_hub/theme/appTheme.dart';
import 'package:social_hub/widgets/button.dart';
import 'package:social_hub/widgets/text_form_field.dart';
import 'package:social_hub/widgets/textfield_label_widget.dart';

class SignUpScreen extends GetView<LoginController> {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        children: [
          Form(
            key: controller.signUpKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ///Title
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Create new account",
                      style: AppTheme.largeTextStyle,
                    ),
                  ],
                ),

                ///Name Input Field
                const TextFieldLabel(label: "Name"),
                TextInputField(
                  controller: controller.userNameController,
                  hintText: "name@example",
                  validator: (_) =>
                      _?.isEmpty == true ? "Name is required" : null,
                  onEditingComplete: controller.emailFocusNode.requestFocus,
                ),

                ///Email Input Field
                const TextFieldLabel(label: "Email"),
                TextInputField(
                  controller: controller.emailController,
                  focusNode: controller.emailFocusNode,
                  hintText: "name@example.com",
                  validator: (_) => _?.isEmpty == true
                      ? "Email is Requried"
                      : _?.isEmail != true
                          ? "Invalid email address."
                          : null,
                  onEditingComplete: controller.phoneFocusNode.requestFocus,
                ),

                /// Phone Input Field
                const TextFieldLabel(label: "Phone(Optional)"),
                TextInputField(
                  controller: controller.phoneController,
                  focusNode: controller.phoneFocusNode,
                  keyboardType: TextInputType.phone,
                  onEditingComplete: controller.passwordFocusNode.requestFocus,
                ),

                /// Password Input Field
                const TextFieldLabel(label: "Password"),
                TextInputField(
                  controller: controller.passwordController,
                  focusNode: controller.passwordFocusNode,
                  suffixFunction: controller.isObsecureText,
                  suffixIconContain: true,
                  validator: (_) => _?.isEmpty == true
                      ? "Password is required"
                      : _!.length < 6
                          ? "Password require at least 6 characters"
                          : null,
                  onEditingComplete:
                      controller.confirmPasswordFocusNode.requestFocus,
                ),

                ///Confirm Password Input Field
                const TextFieldLabel(label: "Confirm password"),
                TextInputField(
                  controller: controller.confirmPasswordController,
                  focusNode: controller.confirmPasswordFocusNode,
                  suffixFunction: controller.isObsecureText,
                  suffixIconContain: true,
                  validator: (_) => _ != controller.passwordController.text
                      ? "Password does not match"
                      : null,
                  onEditingComplete: controller.signupWithEmail,
                ),

                const SizedBox(
                  height: 10,
                ),

                ///Create New Account Button
                Button(
                  label: "Create new Account",
                  onPressed: controller.signupWithEmail,
                ),

                const SizedBox(
                  height: 10,
                ),

                ///Text
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),

                const SizedBox(
                  height: 10,
                ),

                ///Navigate to Login
                Button(
                  label: "Login",
                  color: AppTheme.boxColor2,
                  labelColor: AppTheme.textColor1,
                  onPressed: Get.back,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
