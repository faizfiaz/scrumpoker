class ResponseCountNotification {
  CountNotification? data;
  dynamic meta;

  ResponseCountNotification({this.data, this.meta});

  ResponseCountNotification.fromJson(Map<String, dynamic> json) {
    data =
        json['data'] != null ? CountNotification.fromJson(json['data']) : null;
    meta = json['meta'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['meta'] = meta;
    return data;
  }
}

class CountNotification {
  int? totalUnreadNotification;

  CountNotification({this.totalUnreadNotification});

  CountNotification.fromJson(Map<String, dynamic> json) {
    totalUnreadNotification = json['total_unread_notification'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['total_unread_notification'] = totalUnreadNotification;
    return data;
  }
}
