import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:we_go/controller/app_controller.dart';
import 'package:we_go/theme/appTheme.dart';
import 'package:we_go/widgets/button.dart';
import 'package:we_go/widgets/template.dart';

class ChangePassword extends GetView<AppController> {
  const ChangePassword({super.key});
  @override
  Widget build(BuildContext context) {
    return Template(
      title: "Change Password",
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Form(
          key: controller.changePasswordKey,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: TextFormField(
                  controller: controller.oldPasswordController,
                  validator: (_) =>
                      _ == null || _.isEmpty ? "This field is required." : null,
                  decoration: InputDecoration(
                    hintText: "Old password",
                    hintStyle: AppTheme.normalTextStyle.copyWith(
                      color: AppTheme.hintColor,
                    ),
                  ),
                  onEditingComplete:
                      controller.newPasswordFocusNode.requestFocus,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: TextFormField(
                  controller: controller.newPasswordController,
                  focusNode: controller.newPasswordFocusNode,
                  validator: (_) => _ == null || _.isEmpty
                      ? "This field is required."
                      : _.length < 6
                          ? 'Password aleast have 6 characters !'
                          : null,
                  decoration: InputDecoration(
                    hintText: "New password",
                    hintStyle: AppTheme.normalTextStyle.copyWith(
                      color: AppTheme.hintColor,
                    ),
                  ),
                  onEditingComplete:
                      controller.confirmPasswordFocusNode.requestFocus,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: TextFormField(
                  validator: (_) => _ == null || _.isEmpty
                      ? "This field is required."
                      : _ != controller.newPasswordController.text
                          ? 'Password does not match.'
                          : null,
                  controller: controller.confrimPasswordController,
                  focusNode: controller.confirmPasswordFocusNode,
                  decoration: InputDecoration(
                    hintText: "Confirm new password",
                    hintStyle: AppTheme.normalTextStyle.copyWith(
                      color: AppTheme.hintColor,
                    ),
                  ),
                  onEditingComplete: controller.changePassword,
                ),
              ),
              Button(
                label: "Change Password",
                onPressed: controller.changePassword,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
