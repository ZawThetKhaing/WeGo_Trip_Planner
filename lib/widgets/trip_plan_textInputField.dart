import 'package:flutter/material.dart';
import 'package:we_go/theme/appTheme.dart';

class TripPlanTextInputField extends StatelessWidget {
  final TextEditingController? controller;
  final FocusNode focusNode;
  final String? hintText;
  final Widget? prefix;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final void Function()? onEditingComplete;
  final AutovalidateMode? autovalidateMode;
  const TripPlanTextInputField({
    super.key,
    required this.controller,
    required this.focusNode,
    this.hintText,
    this.prefix,
    this.validator,
    this.keyboardType,
    this.onEditingComplete,
    this.autovalidateMode,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: TextFormField(
        onEditingComplete: onEditingComplete,
        keyboardType: keyboardType,
        cursorColor: AppTheme.boxColor2,
        controller: controller,
        focusNode: focusNode,
        style: AppTheme.bottomNavTextStyle.copyWith(
          color: AppTheme.textColor1,
        ),
        autovalidateMode: autovalidateMode,
        validator: validator ??
            (_) => _?.isEmpty == true ? "This field is required" : null,
        decoration: InputDecoration(
          errorStyle: AppTheme.errorTextStyle,
          prefixIconConstraints:
              const BoxConstraints.expand(width: 40, height: 35),
          prefixIconColor: AppTheme.textColor1,
          prefixIcon: prefix,
          hintText: hintText,
          hintStyle: AppTheme.bottomNavTextStyle.copyWith(
            color: AppTheme.btmNavUnselectedColor,
          ),
          filled: false,
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: AppTheme.btmNavUnselectedColor),
          ),
          border: const UnderlineInputBorder(
            borderSide: BorderSide(color: AppTheme.btmNavUnselectedColor),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: AppTheme.brandColor,
            ),
          ),
          focusedErrorBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              width: 1,
              color: AppTheme.errorBorderColor,
            ),
          ),
        ),
      ),
    );
  }
}
