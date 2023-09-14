import 'package:we_pro/modules/dashboard/model/model_my_job.dart';

class ModelJobHistory {
  String? status;
  dynamic totalRecords;
  dynamic totalDone;
  dynamic totalCanceled;
  dynamic totalRejected;
  dynamic totalAccepted;
  dynamic totalJobs;
  dynamic totalEarning;
  String? page;
  String? limit;
  List<JobData>? data;

  ModelJobHistory(
      {this.status,
      this.totalRecords,
      this.totalDone,
      this.totalCanceled,
      this.totalRejected,
      this.totalAccepted,
      this.totalJobs,
      this.totalEarning,
      this.page,
      this.limit,
      this.data});

  ModelJobHistory.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    totalRecords = json['total_records'];
    totalDone = json['total_done'];
    totalCanceled = json['total_canceled'];
    totalRejected = json['total_rejected'];
    totalAccepted = json['total_accepted'] ?? "0";
    totalJobs = json['total_jobs'];
    totalEarning = json['total_earning'] ?? "0";
    page = json['page'];
    limit = json['limit'];
    if (json['data'] != null && json["data"]!.isNotEmpty) {
      data = <JobData>[];
      json['data'].forEach((v) {
        data!.add(JobData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['total_records'] = totalRecords;
    data['total_done'] = totalDone;
    data['total_canceled'] = totalCanceled;
    data['total_rejected'] = totalRejected;
    data['total_accepted'] = totalAccepted;
    data['total_jobs'] = totalJobs;
    data['total_earning'] = totalEarning;
    data['page'] = page;
    data['limit'] = limit;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
