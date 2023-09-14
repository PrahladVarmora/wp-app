///[ModelVerifyOtpResponse is used for verify otp response
class ModelVerifyOtpResponse {
  bool? isVerified;
  String? message;
  bool? status;
  String? id;

  ModelVerifyOtpResponse({this.isVerified, this.message, this.status, this.id});

  ModelVerifyOtpResponse.fromJson(Map<String, dynamic> json) {
    isVerified = json['is_verified'];
    message = json['message'];
    status = json['status'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['is_verified'] = isVerified;
    data['message'] = message;
    data['status'] = status;
    data['id'] = id;
    return data;
  }
}
