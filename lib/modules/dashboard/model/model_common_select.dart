class ModelCommonSelect {
  String? title;
  String? value;

  ModelCommonSelect({
    this.title,
    this.value,
  });

  ModelCommonSelect.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['title'] = title;
    data['value'] = value;
    return data;
  }
}
