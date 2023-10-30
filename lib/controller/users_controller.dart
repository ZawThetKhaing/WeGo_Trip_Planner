import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:we_go/global.dart';
import 'package:we_go/model/user_model.dart';
import 'package:we_go/utils/collection.dart';

class UserController extends GetxController {
  late StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
      allUserSubScription;
  final RxList<UserModel> _allUser = <UserModel>[].obs;
  List<UserModel> get allUser => _allUser;

  final RxList<UserModel> _selectedUserList = <UserModel>[].obs;
  List<UserModel> get selectedUserList => _selectedUserList;

  void selectFriend(UserModel model, int i) {
    if (_selectedUserList.contains(model)) {
      _selectedUserList.remove(model);
    } else {
      _selectedUserList.add(model);
    }
    update(['radio_button $i']);
  }

  @override
  void onInit() {
    super.onInit();
    allUserSubScription = fireStoreService.watchAll(Collections.user).listen(
      (event) {
        _allUser.value =
            event.docs.map((e) => UserModel.fromJson(e.data(), e.id)).toList();
      },
    );
  }

  @override
  void onClose() {
    allUserSubScription?.cancel();
    allUserSubScription = null;
    super.onClose();
  }
}
