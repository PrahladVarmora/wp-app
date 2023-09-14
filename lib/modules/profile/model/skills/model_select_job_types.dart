class ModelJobTypes {
  String? status;
  int? totalRecords;
  List<JobTypesData>? jobTypes;

  ModelJobTypes({this.status, this.totalRecords, this.jobTypes});

  ModelJobTypes.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    totalRecords = json['total_records'];
    if (json['job_types'] != null) {
      jobTypes = <JobTypesData>[];
      json['job_types'].forEach((v) {
        jobTypes!.add(JobTypesData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['total_records'] = totalRecords;
    if (jobTypes != null) {
      data['job_types'] = jobTypes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class JobTypesData {
  String? id;
  String? name;
  String? industryId;
  String? carInfo;
  bool? isSelect;

  JobTypesData({this.id, this.name, this.carInfo});

  JobTypesData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    industryId = json['industryId'];
    carInfo = json['carInfo'];
    isSelect = json['is_select'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['industryId'] = industryId;
    data['carInfo'] = carInfo;
    data['is_select'] = isSelect;

    return data;
  }
}
