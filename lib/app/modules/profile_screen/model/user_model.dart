class UserModel {
  String? id;
  String? fullName;
  String? email;
  String? profilePictureUrl;
  num? weight;
  num? height;
  int? age;
  num? bmi;
  String? createdAt;
  String? updatedAt;

  UserModel(
      {this.id,
        this.fullName,
        this.email,
        this.profilePictureUrl,
        this.weight,
        this.height,
        this.age,
        this.bmi,
        this.createdAt,
        this.updatedAt});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['full_name'];
    email = json['email'];
    profilePictureUrl = json['profile_picture_url'];
    weight = json['weight'];
    height = json['height'];
    age = json['age'];
    bmi = json['bmi'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['full_name'] = fullName;
    data['email'] = email;
    data['profile_picture_url'] = profilePictureUrl;
    data['weight'] = weight;
    data['height'] = height;
    data['age'] = age;
    data['bmi'] = bmi;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
