///[ModeSocialLogin] This class use to Mode Social Login
class ModeSocialLogin {
  String? socialFirstName;
  String? socialLastName;
  int? socialLoginType;
  String? socialEmail;
  String? socialImage;
  String? socialUserName;

  ModeSocialLogin(
      {this.socialFirstName,
      this.socialLastName,
      this.socialLoginType,
      this.socialImage,
      this.socialEmail,
      this.socialUserName});

  ModeSocialLogin.fromJson(Map<String, dynamic> json) {
    socialFirstName = json['social_first_name'];
    socialLastName = json['social_last_name'];
    socialLoginType = json['social_login_type'];
    socialImage = json['social_image'];
    socialEmail = json['social_email'];
    socialUserName = json['social_user_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['social_first_name'] = socialFirstName;
    data['social_last_name'] = socialLastName;
    data['social_login_type'] = socialLoginType;
    data['social_image'] = socialImage;
    data['social_email'] = socialEmail;
    data['social_user_name'] = socialUserName;
    return data;
  }
}
