import 'package:foodapp/models/user_model.dart';

class UserSession {
  static final UserSession _instance = UserSession._internal();
  factory UserSession() => _instance;
  UserSession._internal();

  UserModel? user;
  String? token;

  void clear() {
    token = null;
    user = null;
  }

  bool get isLoggedIn => user != null && token != null;

  Future<void> loadFromResponse({
    required dynamic response,
  }) async {
    print(response.data);

    // Parse user data
    user = UserModel.fromJson(response.data);

    // Updated: token is inside "data.token" not "data.access_token"
    token = response.data['token'];
  }
}
