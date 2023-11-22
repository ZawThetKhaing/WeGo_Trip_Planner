import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:we_go/controller/trip_plan_controller.dart';
import 'package:we_go/global.dart';
import 'package:we_go/model/trip_plan_model.dart';
import 'package:we_go/theme/appTheme.dart';

class PlanListView extends GetView<TripPlanController> {
  final TripPlanModel model;
  final List<Plans?> plans;

  final int indexForDayCheck;
  const PlanListView({
    super.key,
    required this.plans,
    required this.indexForDayCheck,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.width,
      height: plans.contains(
        plans.firstWhereOrNull((element) => element?.day == indexForDayCheck),
      )
          ? plans.length <= 2
              ? plans.length * 100
              : 200
          : 1,
      child: ListView.builder(
        itemCount: plans.length,
        itemBuilder: (_, i) {
          if (plans[i] == null) return const SizedBox();

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      plans[i]!.title,
                      style: AppTheme.normalTextStyle.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Row(
                        children: [
                          const Icon(
                            Icons.info,
                            size: 15,
                            color: AppTheme.brandColor,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Detail info",
                            style: AppTheme.welcomeTextStyle.copyWith(
                              color: AppTheme.brandColor,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  plans[i]!.content,
                  style: AppTheme.bottomNavTextStyle.copyWith(
                    color: AppTheme.tripPlanTextColor,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            controller.like(
                              model,
                              authService.auth.currentUser?.uid ?? '',
                              plans[i]!,
                            );
                          },
                          child: Container(
                            color: Colors.transparent,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.thumb_up_alt_sharp,
                                  size: 20,
                                  color: plans[i]!.likes.contains(
                                          authService.auth.currentUser?.uid ??
                                              '')
                                      ? AppTheme.likeColor
                                      : AppTheme.unlikeColor,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  '${plans[i]!.likes.length} likes',
                                  style: AppTheme.errorTextStyle.copyWith(
                                    color: plans[i]!.likes.contains(
                                            authService.auth.currentUser?.uid ??
                                                '')
                                        ? AppTheme.likeColor
                                        : AppTheme.unlikeColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            controller.disLike(
                              model,
                              authService.auth.currentUser?.uid ?? '',
                              plans[i]!,
                            );
                          },
                          child: Container(
                            color: Colors.transparent,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.thumb_down,
                                  size: 20,
                                  color: model.plans![i].unlikes.contains(
                                          authService.auth.currentUser?.uid ??
                                              '')
                                      ? AppTheme.errorBorderColor
                                      : AppTheme.unlikeColor,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  '${plans[i]!.unlikes.length} dislikes',
                                  style: AppTheme.errorTextStyle.copyWith(
                                    color: plans[i]!.unlikes.contains(
                                            authService.auth.currentUser?.uid ??
                                                '')
                                        ? AppTheme.errorBorderColor
                                        : AppTheme.unlikeColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
