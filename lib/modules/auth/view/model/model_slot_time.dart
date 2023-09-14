class WeekDayModel {
  String? weekName;
  int? weekId;
  bool? isSelected;

  WeekDayModel({this.weekName, this.isSelected});

  WeekDayModel.fromJson(Map<String, dynamic> json) {
    weekName = json['weekName'];
    weekId = json['weekId'];
    isSelected = json['isSelected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['weekName'] = weekName;
    data['weekId'] = weekId;
    data['isSelected'] = isSelected;
    return data;
  }
}
