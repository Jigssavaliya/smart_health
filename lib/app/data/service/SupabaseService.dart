import 'dart:io';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smart_health/app/modules/calories_screen/model/calories_activity_model.dart';
import 'package:smart_health/app/modules/profile_screen/model/user_model.dart';
import 'package:smart_health/app/modules/sleep/model/sleep_record_model.dart';
import 'package:smart_health/app/modules/sleep/model/sleep_tips_model.dart';
import 'package:smart_health/app/modules/waking_activity/model/walking_activity_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseService {
  SupabaseService._();

  static final SupabaseService _supabaseService = SupabaseService._();

  static SupabaseService get instance => _supabaseService;

  Future<void> databaseConnection() async {
    await Supabase.initialize(url: dotenv.env["DATABASE_URL"] ?? "", anonKey: dotenv.env["DATABASE_PUBLIC_KEY"] ?? "");
  }

  Future<String> uploadImage(File file, String buket, String filename) async {
    try {
      // Create a unique file path (e.g., timestamped filename)
      final String fileName = 'upload/${DateTime.now().millisecondsSinceEpoch}$filename';

      // Upload
      final response = await Supabase.instance.client.storage
          .from(buket) // your bucket name
          .upload(fileName, file);

      return response;
    } catch (e) {
      throw "Something went wrong, please upload file again!";
    }
  }

  Future<void> insertLoginEntry(String? userId) async {
    if (userId == null) return;
    await Supabase.instance.client.from("user_login_activity").insert({"user_id": userId});
  }

  Future<UserModel?> getUserInfo() async {
    var response = await Supabase.instance.client.from("user").select("").eq("id", Supabase.instance.client.auth.currentUser?.id ?? "");
    if (response.isNotEmpty) {
      return UserModel.fromJson(response.first);
    } else {
      return null;
    }
  }

  Future<List<SleepTipsModel>> getSleepTips() async {
    var response = await Supabase.instance.client.from("sleep_tips").select("*");
    if (response.isNotEmpty) {
      return sleepTipsListFromJson(response);
    } else {
      return [];
    }
  }

  Future<SleepRecordModel?> getSleepRecordForDate(DateTime date) async {
    final supabase = Supabase.instance.client;

    // Always work in UTC
    final startDate = DateTime.utc(date.year, date.month, date.day);
    final endDate = startDate.add(const Duration(days: 1));

    final dateFormater = "yyyy-MM-dd'T'HH:mm:ss'Z'";

    final startDateStr = DateFormat(dateFormater).format(startDate);
    final endDateStr = DateFormat(dateFormater).format(endDate);

    final response = await supabase
        .from("sleep_records")
        .select("*")
        .eq('user_id', Supabase.instance.client.auth.currentUser?.id ?? "")
        .gte("date", startDateStr) // start of the day
        .lt("date", endDateStr) // strictly before next day
        .order("date", ascending: false);

    if (response.isNotEmpty) {
      return SleepRecordModel.fromJson(response.first);
    } else {
      return null;
    }
  }

  Future<CaloriesRecordModel?> getCaloriesRecordForDate(DateTime date) async {
    final supabase = Supabase.instance.client;

    // Always work in UTC
    final startDate = DateTime.utc(date.year, date.month, date.day);
    final endDate = startDate.add(const Duration(days: 1));

    final dateFormater = "yyyy-MM-dd'T'HH:mm:ss'Z'";

    final startDateStr = DateFormat(dateFormater).format(startDate);
    final endDateStr = DateFormat(dateFormater).format(endDate);

    final response = await supabase
        .from("calorie_activity")
        .select("""
      *,
      calorie_sources(*)
    """)
        .eq('user_id', Supabase.instance.client.auth.currentUser?.id ?? "")
        .gte("date", startDateStr) // start of the day
        .lt("date", endDateStr) // strictly before next day
        .order("date", ascending: false);

    if (response.isNotEmpty) {
      return CaloriesRecordModel.fromJson(response.first);
    } else {
      return null;
    }
  }

  Future<WalkingActivityModel?> getWalkingRecordForDate(DateTime date) async {
    final supabase = Supabase.instance.client;

    // Always work in UTC
    final startDate = DateTime.utc(date.year, date.month, date.day);
    final endDate = startDate.add(const Duration(days: 1));

    final dateFormater = "yyyy-MM-dd'T'HH:mm:ss'Z'";

    final startDateStr = DateFormat(dateFormater).format(startDate);
    final endDateStr = DateFormat(dateFormater).format(endDate);

    final response = await supabase
        .from("walking_activity")
        .select('*')
        .eq('user_id', Supabase.instance.client.auth.currentUser?.id ?? "")
        .gte("date", startDateStr) // start of the day
        .lt("date", endDateStr) // strictly before next day
        .order("date", ascending: false);

    if (response.isNotEmpty) {
      return WalkingActivityModel.fromJson(response.first);
    } else {
      return null;
    }
  }

  Future<List<double>> getSleepMinutesForWeek() async {
    final now = DateTime.now();
    final startOfWeek = DateTime.utc(now.year, now.month, now.day).subtract(Duration(days: now.weekday - 1)); // Monday UTC

    final endOfToday = now.add(Duration(days: 6));

    final response = await Supabase.instance.client
        .from('sleep_records')
        .select()
        .eq('user_id', Supabase.instance.client.auth.currentUser?.id ?? "")
        .gte('date', startOfWeek.toIso8601String())
        .lte('date', endOfToday.toIso8601String())
        .order('date');

    List<double> dailyMinutes = List.filled(7, 0.0);

    if (response.isNotEmpty) {
      final records = sleepRecordListFromJson(response);
      for (var record in records) {
        final recordDate = DateTime.parse(record.date!).toUtc();
        final dayIndex = recordDate.weekday - 1; // Monday = 0
        dailyMinutes[dayIndex] += (record.durationMinutes ?? 0).toDouble();
      }
    }

    return dailyMinutes;
  }

  Future<List<double>> getWalkingDataForWeak() async {
    final now = DateTime.now();
    final startOfWeek = DateTime.utc(now.year, now.month, now.day).subtract(Duration(days: now.weekday - 1)); // Monday UTC

    final endOfToday = now.add(Duration(days: 6));

    final response = await Supabase.instance.client
        .from('walking_activity')
        .select()
        .eq('user_id', Supabase.instance.client.auth.currentUser?.id ?? "")
        .gte('date', startOfWeek.toIso8601String())
        .lte('date', endOfToday.toIso8601String())
        .order('date');

    List<double> dailyKms = List.filled(7, 0.0);

    if (response.isNotEmpty) {
      final records = walkingRecordListFromJson(response);
      for (var record in records) {
        final recordDate = DateTime.parse(record.date!).toUtc();
        final dayIndex = recordDate.weekday - 1; // Monday = 0
        dailyKms[dayIndex] += (record.distanceKm ?? 0).toDouble();
      }
    }

    return dailyKms;
  }

  Future<Map<String, dynamic>?> getUserGoal() async {
    List<String> target = ["water", "steps", "calories", "sleep"];
    var response = await Supabase.instance.client.from("daily_goals").select("").eq("user_id", Supabase.instance.client.auth.currentUser?.id ?? "");
    if (response.isNotEmpty) {
      Map<String, dynamic>? data = {};
      for (var element in target) {
        var targetData = response.firstWhereOrNull((e) => e["goal_type"] == element);
        if (targetData != null) {
          data[element] = targetData["goal_value"];
        }
      }
      return data;
    } else {
      return null;
    }
  }

  Future<void> insertSleepRecords() async {
    final supabase = Supabase.instance.client;

    try {
      // Call the Postgres function
      final response = await supabase.rpc('insert_missing_daily_data');

      print("✅ Missing records inserted successfully");
      print(response); // Function returns void, so response will be null
    } catch (e) {
      print("❌ Error inserting missing records: $e");
    }
  }

  Future<Map<String, dynamic>?> getGoalBasedOnType(String type) async {
    var response = await Supabase.instance.client
        .from("daily_goals")
        .select("")
        .eq("user_id", Supabase.instance.client.auth.currentUser?.id ?? "")
        .eq("goal_type", type)
        .maybeSingle();
    return response;
  }
}
