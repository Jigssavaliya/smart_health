import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_health/app/modules/waking_activity/model/walking_activity_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../data/service/SupabaseService.dart';
import '../../../data/service/snackbar_helper.dart';

class WakingActivityController extends GetxController {
  RxBool isLoading = false.obs;
  Rxn<WalkingActivityModel> records = Rxn();
  var selectedDateFilter = "Today".obs;

  var customStartDate = DateTime.now().obs;

  RxList<Map<String,dynamic>> tips=<Map<String,dynamic>>[].obs;

  @override
  void onInit() {
    fetchWalkingRecordData(isLoader: true);
    super.onInit();
  }

  void changeFilter(String filter, {DateTime? date}) {
    selectedDateFilter.value = filter;

    if (date != null) {
      customStartDate.value = date;
    } else if (selectedDateFilter.value == "Today") {
      customStartDate.value = DateTime.now();
    } else {
      var date = DateTime.now().toUtc();
      date = date.subtract(Duration(days: 1));
      customStartDate.value = date;
    }

    fetchWalkingRecordData();
  }

  void fetchWalkingRecordData({bool isLoader = true}) async {
    try {
      isLoading.value = isLoader;
      var response = await SupabaseService.instance.getWalkingRecordForDate(
        customStartDate.value,
      );
      records.value = response;
      _generateTips();
    } on AuthException catch (error) {
      SnackBarHelper.showSnackBar(title: "SmartHealth", message: error.message);
    } finally {
      isLoading.value = false;
    }
  }

  void _generateTips() {
    final tipsResponse = <Map<String, dynamic>>[];

    // Distance tips
    if ((records.value?.distanceKm ?? 0) < 2) {
      tipsResponse.add({"icon": Icons.directions_walk, "text": "Try to walk at least 2 km daily for better stamina."});
    } else {
      tipsResponse.add({"icon": Icons.emoji_events, "text": "Great! You’re maintaining a healthy walking distance."});
    }

    // Calories tips
    if ((records.value?.caloriesKcal ?? 0) < 100) {
      tipsResponse.add({"icon": Icons.local_fire_department, "text": "Increase your pace to burn more calories."});
    } else {
      tipsResponse.add({"icon": Icons.local_fire_department_outlined, "text": "Good calorie burn! Keep it consistent."});
    }

    // Pace tips
    if ((records.value?.paceMinPerKm ?? 0) > 12) {
      tipsResponse.add({"icon": Icons.speed, "text": "Try to walk a little faster for better results."});
    } else {
      tipsResponse.add({"icon": Icons.speed_outlined, "text": "Nice pace! You’re walking efficiently."});
    }

    // Active time tips
    if ((records.value?.activeMinutes ?? 0) < 20) {
      tipsResponse.add({"icon": Icons.timer, "text": "Aim for at least 20 minutes of active walking daily."});
    } else {
      tipsResponse.add({"icon": Icons.timer_outlined, "text": "Good job! You’re staying active enough."});
    }

    // Hydration tip always
    tipsResponse.add({"icon": Icons.water_drop, "text": "Don’t forget to drink water before and after your walk."});

    tips.value=tipsResponse;
  }
}
