import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:we_go/global.dart';
import 'package:we_go/model/notification_model.dart';
import 'package:we_go/theme/appTheme.dart';
import 'package:we_go/utils/collection.dart';
import 'package:we_go/utils/utils.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? allNotiSubScription;
  final StreamController<List<NotificationModel>> streamController =
      StreamController.broadcast();
  @override
  void initState() {
    allNotiSubScription =
        fireStoreService.watchAll(Collections.notification).listen((event) {
      List<NotificationModel> allNoti = event.docs.map((e) {
        return NotificationModel.fromJson(e.data(), e.id);
      }).toList();

      List<NotificationModel> finalNoti = allNoti
          .where(
            (element) =>
                element.receivers.contains(authService.auth.currentUser!.uid),
          )
          .toList();

      streamController.sink.add(finalNoti);
    });
    super.initState();
  }

  @override
  void dispose() {
    allNotiSubScription?.cancel();
    allNotiSubScription = null;
    streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: streamController.stream,
      builder: (_, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snap.data == null || snap.data!.isEmpty) {
          return const Center(
            child: Text('No notification'),
          );
        }
        final List<NotificationModel> allNoti = snap.data!;
        final List<NotificationModel> newNoti = allNoti
            .where(
              (e) =>
                  e.createdAt.day == DateTime.now().day &&
                  e.createdAt.month == DateTime.now().month &&
                  e.createdAt.year == DateTime.now().year,
            )
            .toList();
        final List<NotificationModel> previousNoti = allNoti
            .where(
              (e) => DateTime.now().compareTo(e.createdAt) == 1,
            )
            .toList();

        return SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 15.0,
              vertical: 15.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Notifications",
                  style: AppTheme.largeTextStyle.copyWith(
                    color: AppTheme.textColor1,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                allNoti.isEmpty
                    ? const Center(
                        child: Text('No notification'),
                      )
                    : Expanded(
                        child: ListView(
                          children: [
                            newNoti.isNotEmpty
                                ? Text(
                                    "New",
                                    style: AppTheme.normalTextStyle.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                : const SizedBox(),
                            SizedBox(
                              height: newNoti.length * 88,
                              child: Column(
                                children: List.generate(
                                  newNoti.length,
                                  (i) {
                                    newNoti.sort(
                                      (a, b) =>
                                          b.createdAt.compareTo(a.createdAt),
                                    );
                                    return Container(
                                      margin: const EdgeInsets.only(top: 20),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 37,
                                            height: 37,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: AppTheme.brandColor,
                                            ),
                                            child: const Icon(
                                              Icons.notifications,
                                              color: Colors.white,
                                              size: 19,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: 300,
                                                child: RichText(
                                                  text: TextSpan(
                                                    text: newNoti[i].senderName,
                                                    style: AppTheme
                                                        .normalTextStyle
                                                        .copyWith(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                    children: [
                                                      TextSpan(
                                                        text:
                                                            newNoti[i].message,
                                                        style: AppTheme
                                                            .normalTextStyle,
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            newNoti[i].content,
                                                        style: AppTheme
                                                            .normalTextStyle
                                                            .copyWith(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: '.',
                                                        style: AppTheme
                                                            .normalTextStyle
                                                            .copyWith(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                style: AppTheme.agoTextStyle,
                                                "${Utils.ago(newNoti[i].createdAt)} ago",
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            previousNoti.isNotEmpty
                                ? Text(
                                    "Previous",
                                    style: AppTheme.normalTextStyle.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                : const SizedBox(),
                            SizedBox(
                              height: previousNoti.length * 88,
                              child: Column(
                                children: List.generate(
                                  previousNoti.length > 20
                                      ? 20
                                      : previousNoti.length,
                                  (i) {
                                    previousNoti.sort(
                                      (a, b) =>
                                          b.createdAt.compareTo(a.createdAt),
                                    );
                                    return Container(
                                      margin: const EdgeInsets.only(top: 20),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 37,
                                            height: 37,
                                            decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: AppTheme.brandColor),
                                            child: const Icon(
                                              Icons.notifications,
                                              color: Colors.white,
                                              size: 19,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: 300,
                                                child: RichText(
                                                  text: TextSpan(
                                                    text: previousNoti[i]
                                                        .senderName,
                                                    style: AppTheme
                                                        .normalTextStyle
                                                        .copyWith(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                    children: [
                                                      TextSpan(
                                                        text: previousNoti[i]
                                                            .message,
                                                        style: AppTheme
                                                            .normalTextStyle,
                                                      ),
                                                      TextSpan(
                                                        text: previousNoti[i]
                                                            .content,
                                                        style: AppTheme
                                                            .normalTextStyle
                                                            .copyWith(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: '.',
                                                        style: AppTheme
                                                            .normalTextStyle
                                                            .copyWith(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                "${Utils.ago(previousNoti[i].createdAt)} ago",
                                                style: AppTheme.agoTextStyle,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
              ],
            ),
          ),
        );
      },
    );
  }
}
