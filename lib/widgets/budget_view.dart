import 'package:flutter/material.dart';
import 'package:we_go/theme/appTheme.dart';

class BudgetPaidList extends StatelessWidget {
  final String? photo;
  final String name;

  const BudgetPaidList({
    super.key,
    required this.name,
    this.photo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      height: 40,
      child: Column(
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
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        name,
                        style: AppTheme.welcomeTextStyle.copyWith(
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),

                      ///ToDo:::
                      Text(
                        "Paid",
                        style: AppTheme.bottomNavTextStyle.copyWith(
                          color: AppTheme.brandColor,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              Row(
                children: [
                  const Text("170,000"),
                  Container(
                    margin: const EdgeInsets.only(
                      left: 10,
                    ),
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: 1 == 2 ? AppTheme.boxColor2 : AppTheme.brandColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    alignment: Alignment.center,
                    child: IconButton(
                      onPressed: () {},
                      splashRadius: 20,
                      icon: const Icon(
                        Icons.notifications_active_sharp,
                        color:

                            ///ToDo ::
                            1 == 2 ? AppTheme.textColor1 : Colors.white,
                        size: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Divider(
            height: 1,
          ),
        ],
      ),
    );
  }
}
