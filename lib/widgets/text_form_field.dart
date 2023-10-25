import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_hub/controller/login_controller.dart';
import 'package:social_hub/theme/appTheme.dart';

class TextInputField extends StatelessWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool suffixIconContain;
  final void Function()? onEditingComplete;
  final String? Function(String?)? validator;
  final void Function()? suffixFunction;
  final String? hintText;
  final TextInputType? keyboardType;

  const TextInputField({
    super.key,
    this.controller,
    this.focusNode,
    this.onEditingComplete,
    this.validator,
    this.hintText,
    this.keyboardType,
    this.suffixFunction,
    this.suffixIconContain = false,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      id: 'obsecure_widget',
      builder: (ctx) {
        return TextFormField(
          keyboardType: keyboardType,
          obscureText: ctx.isObsecure,
          style: AppTheme.normalTextStyle,
          controller: controller,
          focusNode: focusNode,
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onEditingComplete: onEditingComplete,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppTheme.normalTextStyle.copyWith(
              color: AppTheme.hintColor,
              fontWeight: FontWeight.w400,
            ),
            suffixIcon: suffixIconContain
                ? IconButton(
                    splashRadius: 20,
                    onPressed: suffixFunction,
                    icon: Icon(
                      ctx.isObsecure ? Icons.visibility_off : Icons.visibility,
                    ),
                    color: AppTheme.hintColor,
                  )
                : const SizedBox(),
          ),
        );
      },
    );
  }
}
