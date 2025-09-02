class DailyVitalModel {
  String? id;
  String? userId;
  String? date;
  num? oxygenLevel;
  num? bodyTemperature;
  num? heartRate;
  String? createdAt;
  String? updatedAt;

  DailyVitalModel(
      {this.id,
        this.userId,
        this.date,
        this.oxygenLevel,
        this.bodyTemperature,
        this.heartRate,
        this.createdAt,
        this.updatedAt});

  DailyVitalModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    date = json['date'];
    oxygenLevel = json['oxygen_level'];
    bodyTemperature = json['body_temperature'];
    heartRate = json['heart_rate'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['date'] = date;
    data['oxygen_level'] = oxygenLevel;
    data['body_temperature'] = bodyTemperature;
    data['heart_rate'] = heartRate;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
