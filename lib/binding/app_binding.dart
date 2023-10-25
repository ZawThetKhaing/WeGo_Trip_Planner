import 'package:get/get.dart';
import 'package:social_hub/controller/app_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AppController());
  }
}
