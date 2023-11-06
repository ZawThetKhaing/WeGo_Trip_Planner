import 'package:flutter/material.dart';
import 'package:we_go/theme/appTheme.dart';

class PeopleListTile extends StatelessWidget {
  final String name;
  final String status;
  final bool isCreator;
  final void Function()? remove;
  const PeopleListTile({
    super.key,
    required this.name,
    required this.status,
    this.isCreator = false,
    this.remove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 17,
                ),
                const SizedBox(
                  width: 5,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: AppTheme.welcomeTextStyle.copyWith(
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Text(
                      status,
                      style: AppTheme.welcomeTextStyle.copyWith(
                        fontSize: 10,
                        color: AppTheme.tripPlanTextColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            isCreator
                ? GestureDetector(
                    onTap: remove,
                    child: Text(
                      "Remove",
                      style: AppTheme.bottomNavTextStyle.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.errorBorderColor,
                      ),
                    ),
                  )
                : const SizedBox(),
          ],
        ),
        const Divider(
          height: 1,
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
