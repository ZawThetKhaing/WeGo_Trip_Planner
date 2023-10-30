import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:we_go/controller/app_controller.dart';
import 'package:we_go/theme/appTheme.dart';
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
  late final AppController controller = Get.find<AppController>();
  List<Widget> views = [
    const PlanView(),
    const MyTripView(),
    const NotificationView(),
    const MenuView(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => views[controller.homeNaveIndex],
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppTheme.focusBorderColor,
          unselectedItemColor: AppTheme.btmNavUnselectedColor,
          showUnselectedLabels: true,
          selectedLabelStyle: AppTheme.bottomNavTextStyle,
          unselectedLabelStyle: AppTheme.bottomNavTextStyle,
          onTap: controller.bottomNav,
          currentIndex: controller.homeNaveIndex,
          items: [
            BottomNavigationBarItem(
              icon: Image.asset(
                "lib/assets/MapTrifold.png",
                width: 30,
                height: 30,
                color: controller.homeNaveIndex == 0
                    ? AppTheme.brandColor
                    : AppTheme.btmNavUnselectedColor,
              ),
              label: "Plan",
            ),
            const BottomNavigationBarItem(
              icon: Icon(
                Icons.luggage,
                size: 30,
              ),
              label: "My Trips",
            ),
            const BottomNavigationBarItem(
              icon: Icon(
                Icons.notifications,
                size: 30,
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
        ),
      ),
    );
  }
}
