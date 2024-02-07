import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:we_go/controller/app_controller.dart';
import 'package:we_go/global.dart';
import 'package:we_go/theme/appTheme.dart';
import 'package:we_go/widgets/button.dart';
import 'package:we_go/widgets/template.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final AppController controller = Get.find<AppController>();
  final StreamController<bool> streamController = StreamController.broadcast();
  @override
  void initState() {
    controller.editProfileUserNameController.text =
        authService.auth.currentUser?.displayName ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Template(
      title: "Edit Profile",
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: controller.editProfilePicImagePicker,
                  child: GetBuilder<AppController>(
                    id: 'edit_profile_pic',
                    builder: (ctx) {
                      if (controller.editProfilePic.value.path.isNotEmpty) {
                        streamController.sink.add(true);
                      }
                      return Stack(
                        children: [
                          const SizedBox(
                            width: 95,
                            height: 110,
                          ),
                          Container(
                            width: 95,
                            height: 95,
                            margin: const EdgeInsets.only(right: 15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              color: AppTheme.boxColor2,
                            ),
                            child: controller
                                    .editProfilePic.value.path.isNotEmpty
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(24),
                                    child: SizedBox(
                                      width: 95,
                                      height: 95,
                                      child: Image.file(
                                        File(controller
                                            .editProfilePic.value.path),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                                : controller.loginUser.value.profilePhoto ==
                                        null
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
                                          imageUrl: controller
                                              .loginUser.value.profilePhoto!,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                          ),
                          Positioned(
                            bottom: 1,
                            left: 33,
                            child: Container(
                              alignment: Alignment.center,
                              height: 30,
                              width: 30,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color.fromRGBO(215, 232, 200, 1),
                              ),
                              child: const PhosphorIcon(
                                PhosphorIconsFill.camera,
                                color: AppTheme.textColor1,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: TextFormField(
                    style: AppTheme.normalTextStyle,
                    controller: controller.editProfileUserNameController,
                    onChanged: (value) {
                      if (value.isEmpty) streamController.sink.add(false);

                      if (controller.editProfileUserNameController.text ==
                          controller.loginUser.value.userName) {
                        streamController.sink.add(false);
                      } else if (controller
                          .editProfileUserNameController.text.isNotEmpty) {
                        streamController.sink.add(true);
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20,
                    bottom: 20,
                  ),
                  child: Container(
                    height: 50,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(243, 243, 243, 1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      controller.loginUser.value.email ?? '',
                      style: AppTheme.welcomeTextStyle.copyWith(
                        fontWeight: FontWeight.w400,
                        color: AppTheme.hintColor,
                      ),
                    ),
                  ),
                ),
                StreamBuilder<bool>(
                  initialData: false,
                  stream: streamController.stream,
                  builder: (context, snapshot) {
                    if (snapshot.data == null) {
                      return const SizedBox();
                    }

                    return Button(
                      label: "Save",
                      labelColor:
                          snapshot.data! ? Colors.white : AppTheme.unlikeColor,
                      color: snapshot.data!
                          ? AppTheme.brandColor
                          : AppTheme.boxColor2,
                      onPressed: snapshot.data! ? controller.editProfile : null,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
