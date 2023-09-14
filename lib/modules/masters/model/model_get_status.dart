/// [ModelGetStatus] this class used to Get Status
class ModelGetStatus {
  String? status;
  int? totalRecords;
  List<JobStatus>? jobStatus;

  ModelGetStatus({this.status, this.totalRecords, this.jobStatus});

  ModelGetStatus.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    totalRecords = json['total_records'];
    if (json['job_status'] != null) {
      jobStatus = <JobStatus>[];
      json['job_status'].forEach((v) {
        jobStatus!.add(JobStatus.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['total_records'] = totalRecords;
    if (jobStatus != null) {
      data['job_status'] = jobStatus!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

/// [JobStatus] this class used to list of status like Pending, Rejected etc.
class JobStatus {
  String? jsId;
  String? status;
  String? isSubStatus;
  String? removeMyJob;

  JobStatus({
    this.jsId,
    this.status,
    this.isSubStatus,
    this.removeMyJob,
  });

  JobStatus.fromJson(Map<String, dynamic> json) {
    jsId = json['jsId'];
    status = json['status'];
    isSubStatus = json['is_substatus'];
    removeMyJob = json['removeMyJob'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['jsId'] = jsId;
    data['status'] = status;
    data['is_substatus'] = isSubStatus;
    data['removeMyJob'] = removeMyJob;
    return data;
  }
}
