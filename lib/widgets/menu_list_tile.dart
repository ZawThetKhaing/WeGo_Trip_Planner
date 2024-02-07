import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:we_go/theme/appTheme.dart';

class MenuListTile extends StatelessWidget {
  final PhosphorIconData iconData;
  final String label;
  final void Function() onTap;
  const MenuListTile({
    super.key,
    required this.iconData,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(
          vertical: 15,
        ),
        margin: const EdgeInsets.only(
          bottom: 7,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            PhosphorIcon(
              iconData,
              color: AppTheme.brandColor,
              size: 32,
            ),
            const SizedBox(
              width: 15,
            ),
            Text(
              label,
              style: AppTheme.welcomeTextStyle,
            ),
          ],
        ),
      ),
    );
  }
}
