import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:we_go/controller/trip_plan_controller.dart';
import 'package:we_go/global.dart';
import 'package:we_go/model/trip_plan_model.dart';
import 'package:we_go/theme/appTheme.dart';

class PlanListView extends GetView<TripPlanController> {
  final TripPlanModel model;
  final List<Plans>? plans;

  const PlanListView({
    super.key,
    required this.plans,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return plans == null
        ? const SizedBox()
        : Column(
            children: List.generate(
              plans!.length,
              (i) {
                plans!.sort((a, b) => a.createdAt!.compareTo(b.createdAt!));
                return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            plans![i].title,
                            style: AppTheme.normalTextStyle.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) => Container(
                                  padding: const EdgeInsets.all(20),
                                  width: context.width,
                                  height: context.height * 0.8,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      10,
                                    ),
                                    color: Colors.white,
                                  ),
                                  child: ListView(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                          vertical: 18.5,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              plans![i].title,
                                              style: AppTheme.welcomeTextStyle
                                                  .copyWith(
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                              plans![i].content,
                                              style: AppTheme.bottomNavTextStyle
                                                  .copyWith(
                                                color:
                                                    AppTheme.tripPlanTextColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                          vertical: 24,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Related link",
                                              style: AppTheme.welcomeTextStyle
                                                  .copyWith(
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                              plans![i].relatedLink ??
                                                  'No related link',
                                              style: AppTheme.bottomNavTextStyle
                                                  .copyWith(
                                                color: plans![i].relatedLink ==
                                                        null
                                                    ? AppTheme.textColor1
                                                    : AppTheme.likeColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (plans![i].photos != null &&
                                          plans![i].photos!.isNotEmpty) ...[
                                        SizedBox(
                                          width: 350,
                                          height: 230,
                                          child: Swiper(
                                            itemCount: plans![i].photos!.length,
                                            pagination:
                                                const SwiperPagination(),
                                            loop: false,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return CachedNetworkImage(
                                                imageUrl:
                                                    plans![i].photos![index],
                                                fit: BoxFit.contain,
                                              );
                                            },
                                          ),
                                        )
                                      ]
                                    ],
                                  ),
                                ),
                              );
                            },
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
                        plans![i].content,
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
                                    plans![i],
                                    plans![i].day.toString(),
                                  );
                                },
                                child: Container(
                                  color: Colors.transparent,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.thumb_up_alt_sharp,
                                        size: 20,
                                        color: plans![i].likes.contains(
                                                authService.auth.currentUser
                                                        ?.uid ??
                                                    '')
                                            ? AppTheme.likeColor
                                            : AppTheme.unlikeColor,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        '${plans![i].likes.length} likes',
                                        style: AppTheme.errorTextStyle.copyWith(
                                          color: plans![i].likes.contains(
                                                    authService.auth.currentUser
                                                            ?.uid ??
                                                        '',
                                                  )
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
                                    plans![i],
                                    plans![i].day.toString(),
                                  );
                                },
                                child: Container(
                                  color: Colors.transparent,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.thumb_down,
                                        size: 20,
                                        color: plans![i].unlikes.contains(
                                                  authService.auth.currentUser
                                                          ?.uid ??
                                                      '',
                                                )
                                            ? AppTheme.errorBorderColor
                                            : AppTheme.unlikeColor,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        '${plans![i].unlikes.length} dislikes',
                                        style: AppTheme.errorTextStyle.copyWith(
                                          color: plans![i].unlikes.contains(
                                                  authService.auth.currentUser
                                                          ?.uid ??
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
