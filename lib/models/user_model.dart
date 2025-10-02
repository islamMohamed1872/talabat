class UserModel {
  final String token;
  final int? isPhoneVerified;
  final int? isEmailVerified;
  final int? isPersonalInfo;
  final bool? isExistUser;
  final String loginType;
  final String email;
  final String phone;
  final String image;
  final String firstName;
  final String lastName;
  final int id;

  UserModel({
    required this.token,
    this.isPhoneVerified,
    this.isEmailVerified,
    this.isPersonalInfo,
    this.isExistUser,
    required this.loginType,
    required this.email,
    required this.phone,
    required this.id,
    required this.image,
    required this.firstName,
    required this.lastName,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      token: json['token'] ?? '',
      id: json['id'] ?? 0,
      phone: json['phone'] ?? '',
      firstName: json['f_name'] ?? '',
      lastName: json['l_name'] ?? '',
      image: json['image'] ?? '',
      isPhoneVerified: json['is_phone_verified'],
      isEmailVerified: json['is_email_verified'],
      isPersonalInfo: json['is_personal_info'],
      isExistUser: json['is_exist_user'] == null ? null : json['is_exist_user'] == 1,
      loginType: json['login_type'] ?? '',
      email: json['email'] ?? '',
    );
  }
}
