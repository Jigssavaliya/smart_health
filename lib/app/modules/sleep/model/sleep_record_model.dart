class SleepRecordModel {
  String? id;
  String? userId;
  String? date;
  int? durationMinutes;
  String? quality;
  String? bedtimeConsistency;
  String? createdAt;
  String? updatedAt;

  SleepRecordModel({this.id, this.userId, this.date, this.durationMinutes, this.quality, this.bedtimeConsistency, this.createdAt, this.updatedAt});

  SleepRecordModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    date = json['date'];
    durationMinutes = json['duration_minutes'];
    quality = json['quality'];
    bedtimeConsistency = json['bedtime_consistency'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['date'] = date;
    data['duration_minutes'] = durationMinutes;
    data['quality'] = quality;
    data['bedtime_consistency'] = bedtimeConsistency;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

List<SleepRecordModel> sleepRecordListFromJson(List<dynamic> jsonList) {
  return jsonList.map((json) => SleepRecordModel.fromJson(json as Map<String, dynamic>)).toList();
}

class AlertModel {
  String? type;
  String? message;

  AlertModel({
    this.type,
    this.message,
  });

  AlertModel.fromJson(Map<String, dynamic> json) {
    type = json['alert_type'];
    message = json['alert_message'];
  }
}
