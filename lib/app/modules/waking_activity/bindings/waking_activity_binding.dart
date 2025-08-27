import 'package:get/get.dart';

import '../controllers/waking_activity_controller.dart';

class WakingActivityBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WakingActivityController>(
      () => WakingActivityController(),
    );
  }
}
