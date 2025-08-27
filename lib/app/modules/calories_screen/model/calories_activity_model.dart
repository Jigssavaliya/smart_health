class CaloriesRecordModel {
  String? id;
  String? userId;
  String? date;
  int? caloriesIntake;
  int? caloriesBurned;
  int? caloriesGoal;
  String? createdAt;
  String? updatedAt;
  List<CaloriesSourceModel>? sources;
  int? goalCalories;

  CaloriesRecordModel(
      {this.id, this.userId, this.date, this.caloriesIntake, this.caloriesBurned, this.caloriesGoal, this.createdAt, this.updatedAt, this.sources});

  CaloriesRecordModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    date = json['date'];
    caloriesIntake = json['calories_intake'];
    caloriesBurned = json['calories_burned'];
    caloriesGoal = json['calories_goal'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    sources = (json["calorie_sources"] as List<dynamic>?)?.map((e) => CaloriesSourceModel.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['date'] = date;
    data['calories_intake'] = caloriesIntake;
    data['calories_burned'] = caloriesBurned;
    data['calories_goal'] = caloriesGoal;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class CaloriesSourceModel {
  String? id;
  String? calorieActivityId;
  String? mealType;
  String? mealName;
  String? time;
  int? calories;
  String? createdAt;

  CaloriesSourceModel({this.id, this.calorieActivityId, this.mealType, this.mealName, this.time, this.calories, this.createdAt});

  CaloriesSourceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    calorieActivityId = json['calorie_activity_id'];
    mealType = json['meal_type'];
    mealName = json['meal_name'];
    time = json['time'];
    calories = json['calories'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['calorie_activity_id'] = calorieActivityId;
    data['meal_type'] = mealType;
    data['meal_name'] = mealName;
    data['time'] = time;
    data['calories'] = calories;
    data['created_at'] = createdAt;
    return data;
  }
}
