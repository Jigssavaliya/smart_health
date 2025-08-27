import 'package:get/get.dart';
import 'package:smart_health/app/data/service/SupabaseService.dart';
import 'package:smart_health/app/data/service/snackbar_helper.dart';
import 'package:smart_health/app/modules/sleep/model/sleep_record_model.dart';
import 'package:smart_health/app/modules/sleep/model/sleep_tips_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SleepController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<SleepTipsModel> tips = <SleepTipsModel>[].obs;
  Rxn<SleepRecordModel> records = Rxn();
  var selectedDateFilter = "Today".obs;

  var customStartDate = DateTime.now().obs;

  RxList<String> sleepSuggestion=<String>[].obs;

  @override
  void onInit() {
    initData();
    super.onInit();
  }

  Future<void> initData({bool isLoading = true}) async {
    fetchSleepRecordData(isLoader: isLoading);
    fetchSleepTipsData(isLoader: isLoading);
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

    fetchSleepRecordData();
  }

  void fetchSleepTipsData({bool isLoader = true}) async {
    try {
      isLoading.value = isLoader;
      var response = await SupabaseService.instance.getSleepTips();
      tips.value = response;
    } on AuthException catch (error) {
      SnackBarHelper.showSnackBar(title: "SmartHealth", message: error.message);
    } finally {
      isLoading.value = false;
    }
  }

  void fetchSleepRecordData({bool isLoader = true}) async {
    try {
      isLoading.value = isLoader;
      var response = await SupabaseService.instance.getSleepRecordForDate(
        customStartDate.value,
      );
      records.value = response;
      sleepSuggestion.value = await getSleepSuggestion();
    } on AuthException catch (error) {
      SnackBarHelper.showSnackBar(title: "SmartHealth", message: error.message);
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<String>> getSleepSuggestion() async {
    final record = records.value;
    if (record == null) return [];

    List<String> suggestionList = [];

    // Get user goal from Supabase
    var goalValue = await SupabaseService.instance.getGoalBasedOnType("sleep");
    int userSleepGoalMinutes = goalValue?["goal_value"] ?? 0;
    final duration = record.durationMinutes ?? 0;

    final goalHours = (userSleepGoalMinutes ~/ 60);
    final actualHours = (duration ~/ 60);

    // 💤 Duration check against goal
    if (userSleepGoalMinutes > 0) {
      if (duration < userSleepGoalMinutes - 30) {
        suggestionList.add(
            "⏰ You’re sleeping only ${actualHours}h, less than your goal of ${goalHours}h. Try going to bed earlier."
        );
      } else if (duration > userSleepGoalMinutes + 30) {
        suggestionList.add(
            "😴 You’re sleeping about ${actualHours}h, which is more than your goal of ${goalHours}h. Focus on maintaining consistency."
        );
      } else {
        suggestionList.add(
            "✅ Great! Your sleep duration (~${actualHours}h) is close to your goal of ${goalHours}h."
        );
      }
    }

    // 🌙 Quality
    switch (record.quality) {
      case "Good":
        suggestionList.add(
            "✨ Your sleep quality is good. Keep your bedtime habits consistent."
        );
        break;
      case "Average":
        suggestionList.add(
            "⚠️ Your sleep quality is average. Try reducing screen time or caffeine late in the evening."
        );
        break;
      default:
        suggestionList.add(
            "💤 Work on improving your sleep quality with relaxation or a calm bedtime routine."
        );
    }

    // 📅 Consistency
    if (record.bedtimeConsistency == "Low") {
      suggestionList.add(
          "📌 Your bedtime is irregular. Going to bed and waking up at fixed times can improve sleep quality."
      );
    } else {
      suggestionList.add(
          "👏 Your bedtime consistency looks great! Keep it steady."
      );
    }

    return suggestionList;
  }
}
