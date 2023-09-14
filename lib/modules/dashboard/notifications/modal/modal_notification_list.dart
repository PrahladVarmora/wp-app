class ModelNotificationsList {
  String? status;
  String? totalRecords;
  String? page;
  String? limit;
  List<ModalNotificationData>? notificationDataList;

  ModelNotificationsList(
      {this.status,
      this.totalRecords,
      this.page,
      this.limit,
      this.notificationDataList});

  ModelNotificationsList.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    totalRecords = json['total_records'];
    page = json['page'];
    limit = json['limit'];
    if (json['data'] != null && json['data'] != false) {
      notificationDataList = <ModalNotificationData>[];
      json['data'].forEach((v) {
        notificationDataList!.add(ModalNotificationData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['total_records'] = totalRecords;
    data['page'] = page;
    data['limit'] = limit;
    if (notificationDataList != null) {
      data['data'] = notificationDataList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ModalNotificationData {
  String? id;
  String? title;
  String? content;
  String? type;
  String? compId;
  String? company;
  String? typeId;
  String? actions;
  String? date;

  ModalNotificationData(
      {this.id,
      this.title,
      this.content,
      this.type,
      this.compId,
      this.company,
      this.typeId,
      this.actions,
      this.date});

  ModalNotificationData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    content = json['content'];
    type = json['type'];
    compId = json['compId'];
    company = json['company'];
    typeId = json['type_id'];
    actions = json['actions'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['content'] = content;
    data['type'] = type;
    data['compId'] = compId;
    data['company'] = company;
    data['type_id'] = typeId;
    data['actions'] = actions;
    data['date'] = date;
    return data;
  }
}
