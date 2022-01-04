import 'package:scrumpoker/domain/models/entity/notifications.dart';

class ResponseListNotification {
  DataNotification? data;
  dynamic meta;

  ResponseListNotification({this.data, this.meta});

  ResponseListNotification.fromJson(Map<String, dynamic> json) {
    data =
        json['data'] != null ? DataNotification.fromJson(json['data']) : null;
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

class DataNotification {
  int? totalRecord;
  int? totalPage;
  int? offset;
  int? limit;
  int? page;
  int? prevPage;
  int? nextPage;
  List<Notifications>? data;

  DataNotification(
      {this.totalRecord,
      this.totalPage,
      this.offset,
      this.limit,
      this.page,
      this.prevPage,
      this.nextPage,
      this.data});

  DataNotification.fromJson(Map<String, dynamic> json) {
    totalRecord = json['total_record'];
    totalPage = json['total_page'];
    offset = json['offset'];
    limit = json['limit'];
    page = json['page'];
    prevPage = json['prev_page'];
    nextPage = json['next_page'];
    if (json['data'] != null) {
      data = <Notifications>[];
      json['data'].forEach((v) {
        data!.add(Notifications.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['total_record'] = totalRecord;
    data['total_page'] = totalPage;
    data['offset'] = offset;
    data['limit'] = limit;
    data['page'] = page;
    data['prev_page'] = prevPage;
    data['next_page'] = nextPage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
