///[ModelChatNotification] is used for chat notification model
class ModalNotificationData {
  String? notificationType;
  String? alert;
  String? typeId;
  String? sound;
  String? notificationId;
  String? priority;
  String? title;
  String? clickAction;
  String? message;
  String? actions;

  ModalNotificationData(
      {this.notificationType,
      this.alert,
      this.typeId,
      this.sound,
      this.notificationId,
      this.priority,
      this.title,
      this.clickAction,
      this.message,
      this.actions});

  ModalNotificationData.fromJson(Map<String, dynamic> json) {
    notificationType = json['notification_type'];
    alert = json['alert'];
    typeId = json['type_id'];
    sound = json['sound'];
    notificationId = json['notification_id'];
    priority = json['priority'];
    title = json['title'];
    clickAction = json['click_action'];
    message = json['message'];
    actions = json['actions'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['notification_type'] = notificationType;
    data['alert'] = alert;
    data['type_id'] = typeId;
    data['sound'] = sound;
    data['notification_id'] = notificationId;
    data['priority'] = priority;
    data['title'] = title;
    data['click_action'] = clickAction;
    data['message'] = message;
    data['actions'] = actions;
    return data;
  }
}
