import 'package:flutter/material.dart';
import 'package:we_go/theme/appTheme.dart';

class Button extends StatelessWidget {
  final String label;
  final Color? color;
  final Color? labelColor;
  final void Function()? onPressed;
  const Button({
    super.key,
    required this.label,
    this.color,
    this.labelColor,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 50,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  color ?? AppTheme.brandColor,
                ),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              onPressed: onPressed,
              child: Text(
                label,
                style: AppTheme.normalTextStyle.copyWith(
                  color: labelColor ?? Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
