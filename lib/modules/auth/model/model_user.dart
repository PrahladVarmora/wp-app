///[ModelUser] is used for login api result
class ModelUser {
  String? status;
  String? msg;
  String? accessToken;

  ModelUser({this.status, this.msg, this.accessToken});

  ModelUser.fromJson(Map<String, dynamic> json) {
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
