import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:we_go/model/trip_plan_model.dart';
import 'package:we_go/theme/appTheme.dart';

class MyTripsGridCard extends StatelessWidget {
  final TripPlanModel model;
  final void Function()? onTap;
  const MyTripsGridCard({
    super.key,
    required this.model,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // print(model.owner.userName![0]);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 168,
        height: 167,
        margin: const EdgeInsets.all(0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(7),
              child: model.backGroundPhoto == null
                  ? Image.asset(
                      'lib/assets/trip_plan_default_photo.png',
                      fit: BoxFit.cover,
                      width: 168,
                      height: 167,
                    )
                  : CachedNetworkImage(
                      imageUrl: model.backGroundPhoto!,
                      fit: BoxFit.cover,
                      width: 168,
                      height: 167,
                    ),
            ),
            Positioned(
              child: Container(
                width: 168,
                height: 167,
                padding: const EdgeInsets.only(
                  left: 15,
                  right: 10,
                  top: 15,
                ),
                decoration: BoxDecoration(
                  gradient: AppTheme.myTripViewGradient,
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            ///ToDo :::
                          },
                          child: const Icon(
                            Icons.more_vert,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 35,
                    ),
                    Text(
                      model.tripName,
                      style: AppTheme.normalTextStyle.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 10,
                          color: Color.fromRGBO(255, 255, 255, 0.75),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          model.destination,
                          style: AppTheme.errorTextStyle.copyWith(
                              color: const Color.fromRGBO(255, 255, 255, 0.75),
                              fontWeight: FontWeight.w400),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Row(
                      children: [
                        const PhosphorIcon(
                          PhosphorIconsFill.calendarBlank,
                          color: Color.fromRGBO(255, 255, 255, 0.75),
                          size: 10,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          "${DateFormat.MMMd().format(
                            DateTime.parse(model.startDate),
                          )} to ${DateFormat.MMMd().format(
                            DateTime.parse(model.endDate),
                          )}",
                          style: AppTheme.errorTextStyle.copyWith(
                            color: const Color.fromRGBO(255, 255, 255, 0.75),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Stack(
                          children: [
                            const SizedBox(
                              width: 50,
                              height: 20,
                            ),

                            ///To DO
                            /// Trip Creator Photo
                            Container(
                              width: 20,
                              height: 20,
                              padding: const EdgeInsets.all(1.5),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: Container(
                                width: 18,
                                height: 18,
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppTheme.brandColor,
                                ),
                                child: model.owner.profilePhoto == null
                                    ? Text(
                                        model.owner.userName![0].toUpperCase(),
                                        style: AppTheme.bottomNavTextStyle
                                            .copyWith(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: AppTheme.textColor1,
                                        ),
                                      )
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(9),
                                        child: CachedNetworkImage(
                                          imageUrl: model.owner.profilePhoto!,
                                          placeholder: (context, url) =>
                                              const CircularProgressIndicator(),
                                          fit: BoxFit.cover,
                                          width: 18,
                                          height: 18,
                                        ),
                                      ),
                              ),
                            ),

                            /// Participant Photo
                            model.participants != null &&
                                    model.participants!.isNotEmpty
                                ? Positioned(
                                    left: 10,
                                    child: Container(
                                      width: 20,
                                      height: 20,
                                      padding: const EdgeInsets.all(1.5),
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                      ),

                                      ///Check participant profile photo not null
                                      child: model.participants![0]
                                                  .profilePhoto ==
                                              null
                                          ? Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: AppTheme.brandColor
                                                    .withOpacity(0.5),
                                              ),
                                              alignment: Alignment.center,
                                              child: Text(
                                                model.participants![0]
                                                    .userName![0]
                                                    .toUpperCase(),
                                                style: AppTheme
                                                    .bottomNavTextStyle
                                                    .copyWith(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppTheme.textColor1,
                                                ),
                                              ),
                                            )
                                          : ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(9),
                                              child: CachedNetworkImage(
                                                imageUrl: model.participants![0]
                                                    .profilePhoto!,
                                                placeholder: (context, url) =>
                                                    const CircularProgressIndicator(),
                                                fit: BoxFit.cover,
                                                width: 18,
                                                height: 18,
                                              ),
                                            ),
                                    ),
                                  )
                                : const SizedBox(),

                            /// Remain length
                            model.participants != null &&
                                    model.participants!.length >= 2
                                ? Positioned(
                                    left: 20,
                                    child: Container(
                                      width: 20,
                                      height: 20,
                                      padding: const EdgeInsets.all(1.5),
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                      ),
                                      child: CircleAvatar(
                                        radius: 9,
                                        backgroundColor: AppTheme.brandColor,
                                        child: Text(
                                          model.participants == null ||
                                                  model.participants!.isEmpty
                                              ? ''
                                              : '+${model.participants!.length - 1}',
                                          style: AppTheme.bottomNavTextStyle
                                              .copyWith(
                                            fontSize: 8,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
