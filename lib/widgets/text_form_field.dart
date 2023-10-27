import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:we_go/controller/login_controller.dart';
import 'package:we_go/theme/appTheme.dart';

class TextInputField extends StatelessWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool suffixIconContain;
  final void Function()? onEditingComplete;
  final String? Function(String?)? validator;
  final String? hintText;
  final TextInputType? keyboardType;
  final String? index;
  final bool? obsecureText;

  const TextInputField({
    super.key,
    this.controller,
    this.focusNode,
    this.onEditingComplete,
    this.validator,
    this.hintText,
    this.keyboardType,
    this.suffixIconContain = false,
    this.index,
    this.obsecureText,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      id: 'obsecure_widget $index',
      builder: (ctx) {
        return TextFormField(
          keyboardType: keyboardType,
          obscureText: obsecureText ?? ctx.isObsecure,
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
                    onPressed: () {
                      ctx.isObsecureText(index ?? "");
                    },
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
