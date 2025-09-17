class UserModel {
  final String token;
  final int? isPhoneVerified;
  final int? isEmailVerified;
  final int? isPersonalInfo;
  final bool? isExistUser;
  final String loginType;
  final String email;

  UserModel({
    required this.token,
    this.isPhoneVerified,
    this.isEmailVerified,
    this.isPersonalInfo,
    this.isExistUser,
    required this.loginType,
    required this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      token: json['token'] ?? '',
      isPhoneVerified: json['is_phone_verified'],
      isEmailVerified: json['is_email_verified'],
      isPersonalInfo: json['is_personal_info'],
      isExistUser: json['is_exist_user'] == null ? null : json['is_exist_user'] == 1,
      loginType: json['login_type'] ?? '',
      email: json['email'] ?? '',
    );
  }
}
