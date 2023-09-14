class ModelIndustry {
  String? status;
  int? totalRecords;
  List<IndustryData>? industry;

  ModelIndustry({this.status, this.totalRecords, this.industry});

  ModelIndustry.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    totalRecords = json['total_records'];
    if (json['industry'] != null) {
      industry = <IndustryData>[];
      json['industry'].forEach((v) {
        industry!.add(IndustryData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['total_records'] = totalRecords;
    if (industry != null) {
      data['industry'] = industry!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class IndustryData {
  String? id;
  String? name;
  bool? isSelect;

  IndustryData({this.id, this.name, this.isSelect});

  IndustryData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isSelect = json['is_select'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['is_select'] = isSelect;
    return data;
  }
}
