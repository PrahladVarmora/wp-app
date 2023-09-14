class ModelSetUpStripe {
  String? status;
  String? stripeUrl;

  ModelSetUpStripe({this.status, this.stripeUrl});

  ModelSetUpStripe.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    stripeUrl = json['stripe_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['stripe_url'] = stripeUrl;
    return data;
  }
}
