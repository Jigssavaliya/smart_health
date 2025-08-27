class SleepTipsModel {
  String? id;
  String? tipText;
  String? icon;
  String? createdAt;

  SleepTipsModel({this.id, this.tipText, this.icon, this.createdAt});

  SleepTipsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tipText = json['tip_text'];
    icon = json['icon'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['tip_text'] = tipText;
    data['icon'] = icon;
    data['created_at'] = createdAt;
    return data;
  }
}

List<SleepTipsModel> sleepTipsListFromJson(List<dynamic> jsonList) {
  return jsonList.map((json) => SleepTipsModel.fromJson(json as Map<String, dynamic>)).toList();
}
