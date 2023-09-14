class ModelFilterJobHistory {
  String? duration = "";
  String? startDate = "";
  String? endDate = "";
  String? jobType = "";
  String? jobStatus = "";

  ModelFilterJobHistory(
      {this.duration,
      this.jobType,
      this.endDate,
      this.jobStatus,
      this.startDate});

  ModelFilterJobHistory.fromJson(Map<String, dynamic> json) {
    duration = json['duration'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    jobType = json['job_type'];
    jobStatus = json['job_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['duration'] = duration ?? "";
    data['start_date'] = startDate ?? "";
    data['end_date'] = endDate ?? "";
    data['job_type'] = jobType ?? "";
    data['job_status'] = jobStatus ?? "";
    return data;
  }
}
