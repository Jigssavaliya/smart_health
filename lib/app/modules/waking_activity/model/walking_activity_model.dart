class WalkingActivityModel {
  String? id;
  String? userId;
  String? date;
  int? steps;
  num? distanceKm;
  int? caloriesKcal;
  int? activeMinutes;
  num? paceMinPerKm;
  String? createdAt;

  WalkingActivityModel(
      {this.id, this.userId, this.date, this.steps, this.distanceKm, this.caloriesKcal, this.activeMinutes, this.paceMinPerKm, this.createdAt});

  WalkingActivityModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    date = json['date'];
    steps = json['steps'];
    distanceKm = json['distance_km'];
    caloriesKcal = json['calories_kcal'];
    activeMinutes = json['active_minutes'];
    paceMinPerKm = json['pace_min_per_km'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['date'] = date;
    data['steps'] = steps;
    data['distance_km'] = distanceKm;
    data['calories_kcal'] = caloriesKcal;
    data['active_minutes'] = activeMinutes;
    data['pace_min_per_km'] = paceMinPerKm;
    data['created_at'] = createdAt;
    return data;
  }
}


List<WalkingActivityModel> walkingRecordListFromJson(List<dynamic> jsonList) {
  return jsonList.map((json) => WalkingActivityModel.fromJson(json as Map<String, dynamic>)).toList();
}
