import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:we_go/controller/app_controller.dart';
import 'package:we_go/global.dart';
import 'package:we_go/model/user_model.dart';
import 'package:we_go/theme/appTheme.dart';
import 'package:we_go/utils/collection.dart';
import 'package:we_go/views/plan_view.dart';
import 'package:we_go/views/menu_view.dart';
import 'package:we_go/views/my_trip_view.dart';
import 'package:we_go/views/notification_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final StreamController<UserModel> profileStream =
      StreamController.broadcast();

  @override
  void initState() {
    if (authService.auth.currentUser != null) {
      fireStoreService
          .watchOnly(Collections.user, authService.auth.currentUser!.uid)
          .listen(
        (event) {
          if (event.exists == true) {
            profileStream.sink.add(
              UserModel.fromJson(
                event.data(),
                event.id,
              ),
            );
          }
        },
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<UserModel>(
          stream: profileStream.stream,
          builder: (context, snapshot) {
            return GetBuilder<AppController>(
              id: 'app_bottom_nav_bar',
              builder: (controller) {
                if (snapshot.data == null) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return [
                  PlanView(
                    userModel: snapshot.data!,
                  ),
                  const MyTripView(),
                  const NotificationView(),
                  MenuView(
                    userModel: snapshot.data!,
                  ),
                ][controller.homeNaveIndex];
              },
            );
          }),
      bottomNavigationBar: GetBuilder<AppController>(
        id: 'app_bottom_nav_bar',
        builder: (controller) {
          // print(controller.notificationReceived.value);
          return BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppTheme.focusBorderColor,
            unselectedItemColor: AppTheme.btmNavUnselectedColor,
            showUnselectedLabels: true,
            selectedLabelStyle: AppTheme.bottomNavTextStyle,
            unselectedLabelStyle: AppTheme.bottomNavTextStyle,
            onTap: controller.bottomNav,
            currentIndex: controller.homeNaveIndex,
            items: [
              const BottomNavigationBarItem(
                icon: PhosphorIcon(
                  PhosphorIconsFill.mapTrifold,
                  size: 30,
                ),
                label: "Plan",
              ),
              const BottomNavigationBarItem(
                icon: PhosphorIcon(
                  PhosphorIconsFill.suitcaseRolling,
                  size: 30,
                ),
                label: "My Trips",
              ),
              BottomNavigationBarItem(
                icon: Stack(
                  children: [
                    const PhosphorIcon(
                      PhosphorIconsFill.bell,
                      size: 30,
                    ),
                    controller.notificationReceived.value
                        ? Positioned(
                            top: 2,
                            left: 17,
                            child: Container(
                              width: 9.6,
                              height: 9.6,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
                label: "Notification",
              ),
              const BottomNavigationBarItem(
                icon: Icon(
                  Icons.menu,
                  size: 30,
                ),
                label: "Menu",
              )
            ],
          );
        },
      ),
    );
  }
}
