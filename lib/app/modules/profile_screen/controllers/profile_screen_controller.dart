import 'package:get/get.dart';
import 'package:smart_health/app/data/service/SupabaseService.dart';

class ProfileScreenController extends GetxController {
  RxMap<String, dynamic> userGoal = <String, dynamic>{}.obs;

  @override
  void onInit() {
    getUserGoal();
    super.onInit();
  }

  Future<void> getUserGoal() async {
    var response = await SupabaseService.instance.getUserGoal();
    if (response != null) {
      userGoal.value = response;
    }
  }
}
