import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_health/app/modules/calories_screen/model/calories_activity_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../data/service/SupabaseService.dart';
import '../../../data/service/snackbar_helper.dart';

class CaloriesScreenController extends GetxController {
  var selectedDateFilter = "Today".obs;
  var customStartDate = DateTime.now().obs;
  RxBool isLoading = false.obs;
  Rxn<CaloriesRecordModel> records = Rxn();

  @override
  void onInit() {
    fetchCaloriesRecordData(isLoader: true);
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

    fetchCaloriesRecordData();
  }

  void fetchCaloriesRecordData({bool isLoader = true}) async {
    try {
      isLoading.value = isLoader;
      var goalValue = await SupabaseService.instance.getGoalBasedOnType("calories");
      var response = await SupabaseService.instance.getCaloriesRecordForDate(
        customStartDate.value,
      );
      response?.goalCalories=goalValue?["goal_value"];
      records.value = response;
    } on AuthException catch (error) {
      SnackBarHelper.showSnackBar(title: "SmartHealth", message: error.message);
    } finally {
      isLoading.value = false;
    }
  }

  IconData getSourceIcon(CaloriesSourceModel? model){
    if(model?.mealType=="Breakfast"){
      return Icons.breakfast_dining;
    }else if(model?.mealType=="Launch"){
      return Icons.lunch_dining;
    }else if(model?.mealType=="Snack"){
      return Icons.local_grocery_store;
    }else if(model?.mealType=="Dinner"){
      return Icons.dinner_dining;
    }else{
      return Icons.breakfast_dining;
    }
  }

  Color getSourceColor(CaloriesSourceModel? model){
    if(model?.mealType=="Breakfast"){
      return Colors.orange;
    }else if(model?.mealType=="Launch"){
      return  Colors.redAccent;
    }else if(model?.mealType=="Snack"){
      return Colors.green;
    }else if(model?.mealType=="Dinner"){
      return Colors.blueAccent;
    }else{
      return Colors.blueAccent;
    }
  }
}
