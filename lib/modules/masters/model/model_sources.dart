class ModelSourcesList {
  String? status;
  int? totalRecords;
  List<ModelSources>? sources;

  ModelSourcesList({this.status, this.totalRecords, this.sources});

  ModelSourcesList.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    totalRecords = json['total_records'];
    if (json['sources'] != null) {
      sources = <ModelSources>[];
      json['sources'].forEach((v) {
        sources!.add(ModelSources.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['total_records'] = totalRecords;
    if (sources != null) {
      data['sources'] = sources!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ModelSources {
  String? id;
  String? title;
  String? img;
  String? timezone;

  ModelSources({this.id, this.title, this.img, this.timezone});

  ModelSources.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    img = json['img'];
    timezone = json['timezone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['img'] = img;
    data['timezone'] = timezone;
    return data;
  }
}
