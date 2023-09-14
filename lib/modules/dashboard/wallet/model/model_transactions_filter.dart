class ModelTransactionsFilter {
  String? paymentType;
  String? fromDate;
  String? toDate;

  ModelTransactionsFilter({
    this.paymentType,
    this.fromDate,
    this.toDate,
  });

  ModelTransactionsFilter.fromJson(Map<String, dynamic> json) {
    paymentType = json['payment_type'];
    fromDate = json['from_date'];
    toDate = json['to_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['payment_type'] = paymentType;
    data['from_date'] = fromDate;
    data['to_date'] = toDate;

    return data;
  }
}
