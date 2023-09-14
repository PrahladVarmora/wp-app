class ModelMessageDetailResponse {
  String? status;
  String? totalRecords;
  String? page;
  String? limit;
  List<ChatDetail>? chats;

  ModelMessageDetailResponse(
      {this.status, this.totalRecords, this.page, this.limit, this.chats});

  ModelMessageDetailResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    totalRecords = json['total_records'];
    page = json['page'];
    limit = json['limit'];
    if (json['chats'] != null) {
      chats = <ChatDetail>[];
      json['chats'].forEach((v) {
        chats!.add(ChatDetail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['total_records'] = totalRecords;
    data['page'] = page;
    data['limit'] = limit;
    if (chats != null) {
      data['chats'] = chats!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ChatDetail {
  String? logId;
  String? jobId;
  String? message;
  String? img;
  String? date;
  String? direction;
  String? sourceTitle;

  ChatDetail(
      {this.logId,
      this.jobId,
      this.message,
      this.img,
      this.date,
      this.direction,
      this.sourceTitle});

  ChatDetail.fromJson(Map<String, dynamic> json) {
    logId = json['logId'];
    jobId = json['jobId'];
    message = json['message'];
    img = json['img'];
    date = json['date'];
    direction = json['direction'];
    sourceTitle = json['source_title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['logId'] = logId;
    data['jobId'] = jobId;
    data['message'] = message;
    data['img'] = img;
    data['date'] = date;
    data['direction'] = direction;
    data['source_title'] = sourceTitle;
    return data;
  }
}
