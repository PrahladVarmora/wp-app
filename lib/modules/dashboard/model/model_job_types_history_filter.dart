class ModelJobTypesHistoryFilter {
  String? status;
  int? totalRecords;
  List<JobTypeFilter>? jobTypeFilter;

  ModelJobTypesHistoryFilter(
      {this.status, this.totalRecords, this.jobTypeFilter});

  ModelJobTypesHistoryFilter.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    totalRecords = json['total_records'];
    if (json['jobType'] != null) {
      jobTypeFilter = <JobTypeFilter>[];
      json['jobType'].forEach((v) {
        jobTypeFilter!.add(JobTypeFilter.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['total_records'] = totalRecords;
    if (jobTypeFilter != null) {
      data['jobType'] = jobTypeFilter!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class JobTypeFilter {
  String? jId;
  String? name;

  JobTypeFilter({this.jId, this.name});

  JobTypeFilter.fromJson(Map<String, dynamic> json) {
    jId = json['jId'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['jId'] = jId;
    data['name'] = name;
    return data;
  }
}
