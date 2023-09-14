class ModelCollectPayment {
  String? status;
  String? msg;
  String? payUrl;

  ModelCollectPayment({this.status, this.msg, this.payUrl});

  ModelCollectPayment.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    payUrl = json['payUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['msg'] = msg;
    data['payUrl'] = payUrl;
    return data;
  }
}
