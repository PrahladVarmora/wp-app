class ModelSourcesCategories {
  String? status;
  int? totalRecords;
  String? defaultCategoryId;
  String? sourceId;
  List<SourcesCategories>? categories;

  ModelSourcesCategories(
      {this.status,
      this.totalRecords,
      this.defaultCategoryId,
      this.sourceId,
      this.categories});

  ModelSourcesCategories.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    totalRecords = json['total_records'];
    defaultCategoryId = json['default_categoryId'];
    sourceId = json['sourceId'];
    categories = <SourcesCategories>[];
    if (json['categories'] != null && json['categories'] != false) {
      json['categories'].forEach((v) {
        categories!.add(SourcesCategories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['total_records'] = totalRecords;
    data['default_categoryId'] = defaultCategoryId;
    data['sourceId'] = sourceId;
    if (categories != null) {
      data['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SourcesCategories {
  String? catId;
  String? name;

  SourcesCategories({this.catId, this.name});

  SourcesCategories.fromJson(Map<String, dynamic> json) {
    catId = json['catId'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['catId'] = catId;
    data['name'] = name;
    return data;
  }
}
