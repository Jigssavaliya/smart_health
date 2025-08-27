import 'package:get/get.dart';
import 'package:smart_health/app/modules/calories_screen/controllers/calories_screen_controller.dart';
import 'package:smart_health/app/modules/profile_screen/controllers/profile_screen_controller.dart';
import 'package:smart_health/app/modules/waking_activity/controllers/waking_activity_controller.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
    Get.put(ProfileScreenController());
    Get.put(CaloriesScreenController());
    Get.put(WakingActivityController());
  }
}
