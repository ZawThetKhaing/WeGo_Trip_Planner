import 'package:get/get.dart';
import 'package:we_go/controller/app_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AppController());
  }
}
