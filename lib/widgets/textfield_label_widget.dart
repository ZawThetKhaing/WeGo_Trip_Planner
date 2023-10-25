import 'package:flutter/material.dart';
import 'package:social_hub/theme/appTheme.dart';

class TextFieldLabel extends StatelessWidget {
  final String label;
  const TextFieldLabel({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Text(
          label,
          style: AppTheme.normalTextStyle,
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
