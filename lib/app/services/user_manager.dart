class UserManager {
  static final UserManager _instance = UserManager._internal();

  factory UserManager() {
    return _instance;
  }

  UserManager._internal();

  Map<String, dynamic>? userDetails;

  void setUserDetails(Map<String, dynamic>? details) {
    userDetails = details;
  }

  Map<String, dynamic>? getUserDetails() {
    return userDetails;
  }
}
