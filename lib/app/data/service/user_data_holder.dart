// user_singleton.dart

import '../../modules/profile_screen/model/user_model.dart';

class UserSingleton {
  // Private constructor
  UserSingleton._internal();

  // Singleton instance
  static final UserSingleton _instance = UserSingleton._internal();

  // Getter to access singleton instance
  static UserSingleton get instance => _instance;

  // Private variable to hold user data
  UserModel? _user;

  // Setter
  void setUser(UserModel? user) {
    _user = user;
  }

  // Getter
  UserModel? get user => _user;

  // Check if user is set
  bool get hasUser => _user != null;

  // Clear user
  void clearUser() {
    _user = null;
  }
}