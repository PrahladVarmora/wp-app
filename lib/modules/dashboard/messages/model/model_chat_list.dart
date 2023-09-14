class ModelChatList {
  String? status;
  int? totalRecords;
  String? totalUnreadAdmin;
  String? page;
  String? limit;

  List<Chats>? chats;

  ModelChatList(
      {this.status,
      this.totalRecords,
      this.page,
      this.limit,
      this.chats,
      this.totalUnreadAdmin});

  ModelChatList.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    totalRecords = json['total_records'];
    totalUnreadAdmin = json['totalUnreadAdmin'];
    page = json['page'];
    limit = json['limit'];

    if (json['chats'] != null) {
      chats = <Chats>[];
      json['chats'].forEach((v) {
        chats!.add(Chats.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['total_records'] = totalRecords;
    data['totalUnreadAdmin'] = totalUnreadAdmin;
    data['page'] = page;
    data['limit'] = limit;
    if (chats != null) {
      data['chats'] = chats!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Chats {
  String? logId;
  String? jobId;
  String? compId;
  String? message;
  String? chatType;
  String? direction;
  String? date;
  String? sourceTitle;
  String? isRead;
  String? img;
  String? clientName;
  String? company;
  String? unreadCnt;

  Chats(
      {this.logId,
      this.jobId,
      this.compId,
      this.message,
      this.chatType,
      this.direction,
      this.date,
      this.img,
      this.isRead,
      this.clientName,
      this.company,
      this.sourceTitle});

  Chats.fromJson(Map<String, dynamic> json) {
    logId = json['logId'];
    jobId = json['jobId'];
    compId = json['compId'];
    message = json['message'];
    chatType = json['chat_type'];
    direction = json['direction'];
    date = json['date'];
    img = json['img'];
    clientName = json['client_name'];
    sourceTitle = json['source_title'];
    isRead = json['isRead'];
    company = json['company'];
    unreadCnt = json['unreadCnt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['logId'] = logId;
    data['jobId'] = jobId;
    data['message'] = message;
    data['chat_type'] = chatType;
    data['img'] = img;
    data['direction'] = direction;
    data['date'] = date;
    data['client_name'] = clientName;
    data['source_title'] = sourceTitle;
    data['isRead'] = isRead;
    data['company'] = company;
    data['unreadCnt'] = unreadCnt;
    return data;
  }
}
