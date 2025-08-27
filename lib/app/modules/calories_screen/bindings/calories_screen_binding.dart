import 'package:get/get.dart';

import '../controllers/calories_screen_controller.dart';

class CaloriesScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CaloriesScreenController>(
      () => CaloriesScreenController(),
    );
  }
}
