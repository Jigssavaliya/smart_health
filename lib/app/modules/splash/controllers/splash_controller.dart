import 'package:get/get.dart';
import 'package:smart_health/app/data/service/SupabaseService.dart';
import 'package:smart_health/app/routes/app_pages.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    Future.delayed(
      Duration(seconds: 2),
      () async {
        var response = Supabase.instance.client.auth.currentUser;
        if (response != null) {
          await _insertMissingData();
          Get.offAllNamed(Routes.HOME);
        } else {
          Get.offAllNamed(Routes.LOGIN);
        }
      },
    );
    super.onInit();
  }

  Future<void> _insertMissingData() async {
    await SupabaseService.instance.insertSleepRecords();
  }
}
