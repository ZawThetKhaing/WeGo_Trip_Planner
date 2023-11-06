import 'package:get/get.dart';
import 'package:we_go/controller/trip_plan_controller.dart';

class TripPlanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TripPlanController());
  }
}
