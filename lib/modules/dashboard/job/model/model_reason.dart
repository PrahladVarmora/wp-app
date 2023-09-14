/// A class that is used to store the reason for a model's prediction.
class ModelReason {
  String? reasonName;
  bool? isSelected;

  ModelReason({this.reasonName, this.isSelected});

  ModelReason.fromJson(Map<String, dynamic> json) {
    reasonName = json['reasonName'];
    isSelected = json['isSelected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['reasonName'] = reasonName;
    data['isSelected'] = isSelected;
    return data;
  }
}
