import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:we_go/controller/trip_plan_controller.dart';
import 'package:we_go/model/trip_plan_model.dart';
import 'package:we_go/model/user_model.dart';
import 'package:we_go/theme/appTheme.dart';
import 'package:we_go/utils/collection.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class BudgetPaidList extends GetView<TripPlanController> {
  final UserModel userModel;
  final TripPlanModel tripPlanModel;
  final bool isTripCreater;
  const BudgetPaidList({
    super.key,
    required this.userModel,
    required this.tripPlanModel,
    this.isTripCreater = false,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      // Specify a key if the Slidable is dismissible.
      key: const ValueKey(0),
      enabled: isTripCreater,

      endActionPane: ActionPane(
        extentRatio: 0.75,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              controller.paidBudget(
                tripPlanModel,
                userModel,
                Collections.paid,
              );
            },
            backgroundColor: AppTheme.brandColor,
            foregroundColor: Colors.white,
            icon: PhosphorIconsFill.checkCircle,
            spacing: 5,
            label: 'Paid',
          ),
          SlidableAction(
            autoClose: true,
            onPressed: (context) {
              Get.defaultDialog(
                title: "Enter paid amount",
                content: TextFormField(
                  controller: controller.budgetEntryController,
                  decoration: InputDecoration(
                    hintText: "Amount",
                    hintStyle: AppTheme.bottomNavTextStyle.copyWith(
                      color: AppTheme.hintColor,
                    ),
                    prefixIcon: const PhosphorIcon(
                      PhosphorIconsFill.piggyBank,
                      color: Colors.black,
                    ),
                  ),
                ),
                confirm: SizedBox(
                  width: context.width,
                  height: 50,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        AppTheme.brandColor,
                      ),
                    ),
                    onPressed: () {
                      controller.paidBudget(
                        tripPlanModel,
                        userModel,
                        Collections.halfPaid,
                      );
                    },
                    child: Text(
                      "Save",
                      style: AppTheme.welcomeTextStyle.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                contentPadding: const EdgeInsets.all(20),
              );
            },
            backgroundColor: AppTheme.hintColor,
            foregroundColor: Colors.white,
            icon: PhosphorIconsFill.circleHalf,
            spacing: 5,
            label: 'Half-Paid',
          ),
          SlidableAction(
            onPressed: (context) {
              controller.paidBudget(
                tripPlanModel,
                userModel,
                Collections.unPaid,
              );
            },
            backgroundColor: AppTheme.errorBorderColor,
            foregroundColor: Colors.white,
            icon: PhosphorIconsBold.circle,
            spacing: 5,
            label: 'Unpaid',
          ),
        ],
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        height: 40,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      child: userModel.profilePhoto == null
                          ? Container(
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppTheme.brandColor,
                              ),
                              width: 34,
                              height: 34,
                              child: Text(
                                userModel.userName![0].toUpperCase(),
                                style: AppTheme.normalTextStyle.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(17),
                              child: CachedNetworkImage(
                                imageUrl: userModel.profilePhoto!,
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                fit: BoxFit.cover,
                                width: 34,
                                height: 34,
                              ),
                            ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          userModel.userName!.length > 15
                              ? "${userModel.userName!.substring(0, 15)}..."
                              : userModel.userName!,
                          style: AppTheme.welcomeTextStyle.copyWith(
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          userModel.budgetPaidStatus ?? 'Unpaid',
                          style: AppTheme.bottomNavTextStyle.copyWith(
                            color: userModel.budgetPaidStatus == null
                                ? AppTheme.errorBorderColor
                                : userModel.budgetPaidStatus ==
                                        Collections.halfPaid
                                    ? AppTheme.halfPaidColor
                                    : userModel.budgetPaidStatus ==
                                            Collections.unPaid
                                        ? AppTheme.errorBorderColor
                                        : AppTheme.brandColor,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                Row(
                  children: [
                    Text("${userModel.budgetPaid ?? 0}"),
                    Container(
                      margin: const EdgeInsets.only(
                        left: 10,
                      ),
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: userModel.budgetPaidStatus == Collections.paid
                            ? AppTheme.boxColor2
                            : AppTheme.brandColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      alignment: Alignment.center,
                      child: IconButton(
                        onPressed: () {
                          controller.budgetNotification(
                              tripPlanModel, userModel);
                        },
                        splashRadius: 20,
                        icon: Icon(
                          Icons.notifications_active_sharp,
                          color: userModel.budgetPaidStatus == Collections.paid
                              ? AppTheme.textColor1
                              : Colors.white,
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
      ),
    );
  }
}
