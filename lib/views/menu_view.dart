import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:we_go/controller/app_controller.dart';
import 'package:we_go/model/user_model.dart';
import 'package:we_go/routes/routes.dart';
import 'package:we_go/theme/appTheme.dart';
import 'package:we_go/widgets/button.dart';
import 'package:we_go/widgets/menu_list_tile.dart';

class MenuView extends GetView<AppController> {
  final UserModel userModel;
  const MenuView({
    super.key,
    required this.userModel,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        alignment: Alignment.center,
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Menu",
              style: AppTheme.largeTextStyle.copyWith(
                color: AppTheme.textColor1,
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            ///Profile box
            Container(
              padding: const EdgeInsets.only(bottom: 20),
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 1,
                    color: AppTheme.textColor1.withOpacity(
                      0.1,
                    ),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 95,
                    height: 95,
                    margin: const EdgeInsets.only(right: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: AppTheme.boxColor2,
                    ),
                    child: userModel.profilePhoto == null ||
                            userModel.profilePhoto!.isEmpty
                        ? const Icon(
                            Icons.person,
                            size: 40,
                            color: AppTheme.textColor1,
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: CachedNetworkImage(
                              width: 95,
                              height: 95,
                              imageUrl: userModel.profilePhoto!,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userModel.userName ?? '',
                        style: AppTheme.largeTextStyle.copyWith(
                          color: AppTheme.textColor1,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            userModel.email == null
                                ? ''
                                : userModel.email!.length > 21
                                    ? "${userModel.email!.substring(0, 21)}..."
                                    : userModel.email!,
                            style: AppTheme.welcomeTextStyle.copyWith(
                              fontWeight: FontWeight.w400,
                              color: AppTheme.tripPlanTextColor,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          GestureDetector(
                            onTap: controller.copyEmail,
                            child: const PhosphorIcon(
                              PhosphorIconsRegular.copy,
                              size: 18,
                              color: AppTheme.tripPlanTextColor,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),

                      ///Edit Button
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(
                            AppRoutes.editProfile,
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                          ),
                          width: 64,
                          height: 29,
                          decoration: BoxDecoration(
                            color: AppTheme.boxColor2,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Row(
                            children: [
                              PhosphorIcon(
                                PhosphorIconsFill.pencilSimple,
                                size: 15,
                                color: AppTheme.textColor1,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Edit",
                                style: AppTheme.welcomeTextStyle,
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),

            MenuListTile(
              iconData: PhosphorIconsFill.lockKeyOpen,
              label: "Change Password",
              onTap: () {
                controller.oldPasswordController.clear();
                controller.newPasswordController.clear();
                controller.confrimPasswordController.clear();
                Get.toNamed(AppRoutes.changePassword);
              },
            ),
            MenuListTile(
              iconData: PhosphorIconsFill.phone,
              label: "Contact us",
              onTap: controller.contactUs,
            ),

            MenuListTile(
              iconData: PhosphorIconsFill.info,
              label: "About WeGo",
              onTap: () {
                Get.toNamed(AppRoutes.about);
              },
            ),

            const SizedBox(
              height: 20,
            ),
            Button(
              label: "Log out",
              onPressed: controller.logout,
            ),
            const SizedBox(
              height: 115,
            ),
            Column(
              children: [
                Text(
                  '2023 WeGo',
                  style: AppTheme.bottomNavTextStyle.copyWith(
                    color: AppTheme.unlikeColor,
                    fontSize: 12,
                  ),
                ),
                Text(
                  'All rights reserved',
                  style: AppTheme.bottomNavTextStyle.copyWith(
                    color: AppTheme.unlikeColor,
                    fontSize: 12,
                  ),
                ),
                Text(
                  'Version 1.0.0',
                  style: AppTheme.bottomNavTextStyle.copyWith(
                    color: AppTheme.unlikeColor,
                    fontSize: 12,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
