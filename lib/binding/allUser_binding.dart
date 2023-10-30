import 'package:get/get.dart';
import 'package:we_go/controller/users_controller.dart';

class AllUserBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UserController());
  }
}
