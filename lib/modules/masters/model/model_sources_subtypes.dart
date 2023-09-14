class ModelSourcesSubtypes {
  String? status;
  int? totalRecords;
  String? typeId;
  String? nextSearch;
  String? subTypeLabel;
  String? fieldName;
  List<SubTypes>? subTypes;

  ModelSourcesSubtypes({
    this.status,
    this.totalRecords,
    this.typeId,
    this.nextSearch,
    this.subTypeLabel,
    this.fieldName,
    this.subTypes,
  });

  ModelSourcesSubtypes.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    totalRecords = json['total_records'];
    typeId = json['typeId'];
    nextSearch = json['nextSearch'];
    subTypeLabel = json['subTypeLabel'];
    fieldName = json['fieldName'];
    if (json['sub_types'] != null) {
      subTypes = <SubTypes>[];
      json['sub_types'].forEach((v) {
        subTypes!.add(SubTypes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['total_records'] = totalRecords;
    data['typeId'] = typeId;
    data['nextSearch'] = nextSearch;
    data['subTypeLabel'] = subTypeLabel;
    data['fieldName'] = fieldName;
    if (subTypes != null) {
      data['sub_types'] = subTypes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubTypes {
  String? jId;
  String? type;
  String? subTypeLabel;
  String? parentId;
  String? isSubtype;
  String? nextSearch;

  SubTypes({
    this.jId,
    this.type,
    this.subTypeLabel,
    this.parentId,
    this.isSubtype,
    this.nextSearch,
  });

  SubTypes.fromJson(Map<String, dynamic> json) {
    jId = json['jId'];
    type = json['type'];
    subTypeLabel = json['subTypeLabel'];
    parentId = json['parentId'];
    isSubtype = json['is_subtype'];
    nextSearch = json['nextSearch'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['jId'] = jId;
    data['type'] = type;
    data['subTypeLabel'] = subTypeLabel;
    data['parentId'] = parentId;
    data['is_subtype'] = isSubtype;
    data['nextSearch'] = nextSearch;
    return data;
  }
}
