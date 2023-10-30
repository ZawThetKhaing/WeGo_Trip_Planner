import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:we_go/controller/users_controller.dart';
import 'package:we_go/model/user_model.dart';
import 'package:we_go/theme/appTheme.dart';

class InviteFriendScreen extends StatefulWidget {
  const InviteFriendScreen({super.key});

  @override
  State<InviteFriendScreen> createState() => _InviteFriendScreenState();
}

class _InviteFriendScreenState extends State<InviteFriendScreen> {
  final UserController userController = Get.find<UserController>();

  final StreamController<List<UserModel>> _streamController =
      StreamController.broadcast();

  void searchUser(String name) {
    _streamController.sink.add(
      userController.allUser
          .where(
            (element) =>
                element.userName!.replaceAll(' ', '').toUpperCase().contains(
                      name.replaceAll(' ', '').toUpperCase(),
                    ),
          )
          .toList(),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleTextStyle: AppTheme.welcomeTextStyle.copyWith(
          fontWeight: FontWeight.w600,
        ),
        title: const Text("Choose people"),
        leadingWidth: 70,
        centerTitle: true,
        leading: TextButton(
          onPressed: Get.back,
          child: const Text("Cancel", style: AppTheme.welcomeTextStyle),
        ),
        actions: [
          Obx(
            () => userController.selectedUserList.isNotEmpty == true
                ? TextButton(
                    onPressed: () {},
                    child: Text(
                      "Add",
                      style: AppTheme.welcomeTextStyle.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.brandColor,
                      ),
                    ),
                  )
                : const SizedBox(),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        children: [
          TextFormField(
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.search_rounded,
                color: AppTheme.textColor1,
                size: 20,
              ),
              hintText: "Search",
              hintStyle: AppTheme.bottomNavTextStyle.copyWith(
                color: AppTheme.hintColor,
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (value) {
              searchUser(value);
              if (value.isEmpty == true) {
                _streamController.sink.add(<UserModel>[]);
              }
            },
          ),
          StreamBuilder(
            initialData: const <UserModel>[],
            stream: _streamController.stream,
            builder: (_, snapshot) {
              if (snapshot.data == null) return const SizedBox();
              final List<UserModel> foundUser = [];
              if (snapshot.data != null) {
                foundUser.addAll(snapshot.data!.toList());
              }

              return SizedBox(
                height: context.height,
                child: ListView.builder(
                  itemCount: foundUser.length,
                  itemBuilder: (_, i) {
                    return Column(
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
                                SizedBox(
                                  height: 34,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        foundUser[i].userName ?? "",
                                        style:
                                            AppTheme.welcomeTextStyle.copyWith(
                                          fontSize: 13,
                                        ),
                                      ),
                                      Text(
                                        foundUser[i].email ?? "",
                                        style: AppTheme.bottomNavTextStyle
                                            .copyWith(
                                          fontSize: 10,
                                          color: AppTheme.tripPlanTextColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GetBuilder<UserController>(
                                    id: 'radio_button $i',
                                    builder: (ctx) {
                                      return Checkbox(
                                        activeColor: AppTheme.brandColor,
                                        shape: const CircleBorder(),
                                        value: ctx.selectedUserList.contains(
                                          foundUser[i],
                                        ),
                                        onChanged: (value) {
                                          ctx.selectFriend(foundUser[i], i);
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Divider(
                          height: 1,
                        ),
                      ],
                    );
                  },
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
