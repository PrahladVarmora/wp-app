///[ModelValidateUserResponse] is used for validate username response
class ModelValidateUserResponse {
  bool? usernameValid;
  bool? emailValid;
  bool? mobileValid;
  bool? referralCodeValid;
  bool? status;
  String? message;

  ModelValidateUserResponse({
    this.usernameValid,
    this.emailValid,
    this.mobileValid,
    this.referralCodeValid,
    this.message,
    this.status,
  });

  ModelValidateUserResponse.fromJson(Map<String, dynamic> json) {
    usernameValid = json['username_valid'];
    emailValid = json['email_valid'];
    mobileValid = json['mobile_valid'];
    referralCodeValid = json['referral_code_valid'];
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username_valid'] = usernameValid;
    data['email_valid'] = emailValid;
    data['mobile_valid'] = mobileValid;
    data['referral_code_valid'] = referralCodeValid;
    data['status'] = status;
    data['message'] = message;

    return data;
  }
}
