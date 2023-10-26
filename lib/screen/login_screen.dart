import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:we_go/controller/login_controller.dart';
import 'package:we_go/routes/routes.dart';
import 'package:we_go/theme/appTheme.dart';
import 'package:we_go/widgets/button.dart';
import 'package:we_go/widgets/google_sign_in_button.dart';
import 'package:we_go/widgets/or_divider.dart';
import 'package:we_go/widgets/text_form_field.dart';
import 'package:we_go/widgets/textfield_label_widget.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          SizedBox(
            width: context.width,
            height: context.height * 0.3,
            child: Image.asset(
              "lib/assets/logo_photo.png",
              fit: BoxFit.cover,
            ),
          ),
          Form(
            key: controller.loginKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),

                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Login to your account",
                        style: AppTheme.largeTextStyle,
                      ),
                    ],
                  ),

                  ///Email Label
                  const TextFieldLabel(label: "Email"),

                  ///Email Form Field
                  TextInputField(
                    controller: controller.loginEmailController,
                    focusNode: controller.loginEmailFocusNode,
                    onEditingComplete:
                        controller.loginPasswordFocusNode.requestFocus,
                    validator: (_) => _?.isEmpty == true
                        ? "Email is Requried"
                        : _?.isEmail != true
                            ? "Invalid email address."
                            : null,
                  ),

                  ///Password Label
                  const TextFieldLabel(label: "Password"),

                  ///Password Form Field
                  TextInputField(
                    controller: controller.loginPasswordController,
                    focusNode: controller.loginPasswordFocusNode,
                    onEditingComplete: controller.loginWithEmail,
                    validator: (_) =>
                        _?.isEmpty == true ? "Password is required" : null,
                    suffixFunction: controller.isObsecureText,
                    suffixIconContain: true,
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  ///Divider
                  const OrDivider(),

                  const SizedBox(
                    height: 10,
                  ),

                  ///Google Signin Button
                  GoogleSigninButton(
                    onPressed: controller.signInWithGoogle,
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  ///Login Button
                  Button(
                    label: "Login",
                    onPressed: controller.loginWithEmail,
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  ///Create new Account
                  Button(
                    label: "Create new Account",
                    color: AppTheme.boxColor2,
                    labelColor: AppTheme.textColor1,
                    onPressed: () {
                      Get.toNamed(AppRoutes.signUp);
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
