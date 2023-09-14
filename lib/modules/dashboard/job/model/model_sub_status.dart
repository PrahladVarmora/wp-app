/// [ModelJobSubStatus] this model used to Reason List
class ModelJobSubStatus {
  String? status;
  int? totalRecords;
  List<SubStatusData>? subStatusList;

  ModelJobSubStatus({this.status, this.totalRecords, this.subStatusList});

  ModelJobSubStatus.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    totalRecords = json['total_records'];
    subStatusList = <SubStatusData>[];
    if (json['sub_status'] != null && json['sub_status'] != false) {
      json['sub_status'].forEach((v) {
        subStatusList!.add(SubStatusData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['total_records'] = totalRecords;
    if (subStatusList != null) {
      data['sub_status'] = subStatusList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

/// [SubStatusData] this model used to Reason List of Object
class SubStatusData {
  String? jsId;
  String? parentId;
  String? reasonName;
  String? subStatus;

  SubStatusData({this.jsId, this.parentId, this.reasonName, this.subStatus});

  SubStatusData.fromJson(Map<String, dynamic> json) {
    jsId = json['jsId'];
    parentId = json['parentId'];
    reasonName = json['sub_status'];
    subStatus = json['subStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['jsId'] = jsId;
    data['parentId'] = parentId;
    data['sub_status'] = reasonName;
    data['subStatus'] = subStatus;
    return data;
  }
}
