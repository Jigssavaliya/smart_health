import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_health/app/modules/home/model/dialy_vital_model.dart';
import 'package:smart_health/app/modules/sleep/model/sleep_record_model.dart';
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

  RxList<AlertModel> alerts = <AlertModel>[].obs;

  final CarouselController carouselController = CarouselController();

  var vitalData = Rxn<DailyVitalModel>();

  var oxygenLevel = 98.obs; // in %
  var bodyTemperature = 36.5.obs; // in °C
  var heartBeat = 72.obs; // bpm
  RxInt alertCurrentIndex = 0.obs;

  @override
  void onInit() {
    getUserInfo();
    fetchSleepRecordForThisWeek();
    fetchWalkingRecordForThisWeek();
    fetchCaloriesData();
    fetchWalkingData();
    fetchWaterIntakeGoal();
    fetchAlerts();
    fetchDailyVital();
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

  void fetchWaterIntakeGoal() async {
    var response = await SupabaseService.instance.getGoalBasedOnType("water");
    waterIntakeGoal.value = response?["goal_value"];
  }

  void fetchAlerts() async {
    var response = await SupabaseService.instance.getAlert();
    if (response != null) {
      alerts.value = response;
      alerts.refresh();
    }
  }

  void fetchDailyVital() async {
    var response = await SupabaseService.instance.getDailyVital(DateTime.now());
    if (response != null) {
      vitalData.value = response;
    }
  }
}
