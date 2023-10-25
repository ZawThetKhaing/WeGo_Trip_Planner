import 'package:flutter/material.dart';
import 'package:social_hub/theme/appTheme.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Divider(
            height: 1,
            color: Color.fromRGBO(226, 226, 226, 1),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Text(
            "Or",
            style: AppTheme.normalTextStyle.copyWith(
              color: const Color.fromRGBO(226, 226, 226, 1),
            ),
          ),
        ),
        const Expanded(
          child: Divider(
            height: 1,
            color: Color.fromRGBO(226, 226, 226, 1),
          ),
        ),
      ],
    );
  }
}
