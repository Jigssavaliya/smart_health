import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../data/service/SupabaseService.dart';
import '../../../data/service/user_data_holder.dart';

class HomeController extends GetxController {
  final supabase = Supabase.instance.client;

  RxInt currentTabIndex = 0.obs;
  RxInt burnedCalories = 0.obs;
  RxnNum walkingKm = RxnNum(0);
  RxnNum waterIntakeGoal = RxnNum(0);

  RxList<double> sleepMinutes = <double>[0, 0, 0, 0, 0, 0, 0].obs;
  RxList<double> walkingKms = <double>[0, 0, 0, 0, 0, 0, 0].obs;



  @override
  void onInit() {
    getUserInfo();
    fetchSleepRecordForThisWeek();
    fetchWalkingRecordForThisWeek();
    fetchCaloriesData();
    fetchWalkingData();
    fetchWaterIntakeGoal();
    super.onInit();
  }

  void onTabChange(int index) {
    currentTabIndex.value = index;
  }

  void getUserInfo() async {
    var response = await SupabaseService.instance.getUserInfo();
    UserSingleton.instance.setUser(response);
  }

  void fetchSleepRecordForThisWeek() async {
    try {
      var response = await SupabaseService.instance.getSleepMinutesForWeek();

      sleepMinutes.value = response;
    } catch (_) {}
  }

  void fetchWalkingRecordForThisWeek() async {
    try {
      var response = await SupabaseService.instance.getWalkingDataForWeak();

      walkingKms.value = response;
    } catch (_) {}
  }

  void fetchCaloriesData() async {
    var response = await SupabaseService.instance.getCaloriesRecordForDate(DateTime.now());
    burnedCalories.value = response?.caloriesBurned ?? 0;
  }

  void fetchWalkingData() async {
    var response = await SupabaseService.instance.getWalkingRecordForDate(DateTime.now());
    walkingKm.value = response?.distanceKm ?? 0;
  }

  void fetchWaterIntakeGoal() async{
    var response = await SupabaseService.instance.getGoalBasedOnType("water");
    waterIntakeGoal.value=response?["goal_value"];
  }
}
