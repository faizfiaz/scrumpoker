enum NotificationReferenceType { order, unknown }

class Notifications {
  int? id;
  String? notificationType;
  String? title;
  String? message;
  int? referenceId;
  String? referenceType;
  bool? isRead;
  String? createdAt;

  Notifications(
      {this.id,
      this.notificationType,
      this.title,
      this.message,
      this.referenceId,
      this.referenceType,
      this.createdAt,
      this.isRead});

  Notifications.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    notificationType = json['notification_type'];
    title = json['title'];
    message = json['message'];
    referenceId = json['reference_id'];
    referenceType = json['reference_type'];
    createdAt = json['created_at'];
    isRead = json['is_read'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['notification_type'] = notificationType;
    data['title'] = title;
    data['message'] = message;
    data['reference_id'] = referenceId;
    data['reference_type'] = referenceType;
    data['created_at'] = createdAt;
    data['is_read'] = isRead;
    return data;
  }
}
