///[ModelSendOtpResponse] is used for send otp response data
class ModelSendOtpResponse {
  String? email;
  String? otpEmail;
  String? mobile;
  String? otpMobile;
  String? message;
  bool? status;

  ModelSendOtpResponse({
    this.email,
    this.otpEmail,
    this.mobile,
    this.otpMobile,
    this.message,
    this.status,
  });

  ModelSendOtpResponse.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    otpEmail = json['otp_email'];
    mobile = json['mobile'];
    otpMobile = json['otp_mobile'];
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['otp_email'] = otpEmail;
    data['mobile'] = mobile;
    data['otp_mobile'] = otpMobile;
    data['message'] = message;
    data['status'] = status;

    return data;
  }
}
