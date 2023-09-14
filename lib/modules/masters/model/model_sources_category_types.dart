class ModelSourcesCategoryTypes {
  String? status;
  int? totalRecords;
  String? catId;
  String? nextSearch;
  List<CategoryTypes>? categoryTypes;

  ModelSourcesCategoryTypes({
    this.status,
    this.totalRecords,
    this.catId,
    this.nextSearch,
    this.categoryTypes,
  });

  ModelSourcesCategoryTypes.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    totalRecords = json['total_records'];
    catId = json['catId'];
    nextSearch = json['nextSearch'];
    if (json['category_types'] != null) {
      categoryTypes = <CategoryTypes>[];
      json['category_types'].forEach((v) {
        categoryTypes!.add(CategoryTypes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['total_records'] = totalRecords;
    data['catId'] = catId;
    data['nextSearch'] = nextSearch;
    if (categoryTypes != null) {
      data['category_types'] = categoryTypes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CategoryTypes {
  String? jId;
  String? type;
  String? subTypeLabel;
  String? isSubtype;
  String? nextSearch;

  CategoryTypes({
    this.jId,
    this.type,
    this.subTypeLabel,
    this.isSubtype,
    this.nextSearch,
  });

  CategoryTypes.fromJson(Map<String, dynamic> json) {
    jId = json['jId'];
    type = json['type'];
    subTypeLabel = json['subTypeLabel'];
    isSubtype = json['is_subtype'];
    nextSearch = json['nextSearch'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['jId'] = jId;
    data['type'] = type;
    data['subTypeLabel'] = subTypeLabel;
    data['is_subtype'] = isSubtype;
    data['nextSearch'] = nextSearch;
    return data;
  }
}
