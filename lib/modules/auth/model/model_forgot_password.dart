///[ModelForgotPassword] is used for forgot password api result
class ModelForgotPassword {
  String? status;
  String? msg;
  String? accessToken;

  ModelForgotPassword({this.status, this.msg, this.accessToken});

  ModelForgotPassword.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    accessToken = json['accessToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['msg'] = msg;
    data['accessToken'] = accessToken;
    return data;
  }
}
