///[ModelChangePassword] is used for change password api result
class ModelChangePassword {
  bool? status;
  String? message;

  ModelChangePassword({this.status, this.message});

  ModelChangePassword.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;

    return data;
  }
}
