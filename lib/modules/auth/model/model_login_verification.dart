///[ModelLoginVerification] is used for login verification api response
class ModelLoginVerification {
  dynamic isRegistered;
  String? mobile;
  String? otpMobile;
  String? userToken;
  String? message;
  bool? status;

  ModelLoginVerification({
    this.mobile,
    this.isRegistered,
    this.otpMobile,
    this.userToken,
    this.message,
    this.status,
  });

  ModelLoginVerification.fromJson(Map<String, dynamic> json) {
    isRegistered = json['is_registered'];
    mobile = json['mobile'];
    otpMobile = json['otp_mobile'];
    userToken = json['user_token'];
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['is_registered'] = isRegistered;
    data['mobile'] = mobile;
    data['otp_mobile'] = otpMobile;
    data['user_token'] = userToken;
    data['message'] = message;
    data['status'] = status;

    return data;
  }
}
