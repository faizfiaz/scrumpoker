class ResponseListOrder {
  DataOrder? data;
  dynamic meta;

  ResponseListOrder({this.data, this.meta});

  ResponseListOrder.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? DataOrder.fromJson(json['data']) : null;
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

class DataOrder {
  int? totalRecord;
  int? totalPage;
  int? offset;
  int? limit;
  int? page;
  int? prevPage;
  int? nextPage;
  List<Order>? data;

  DataOrder(
      {this.totalRecord,
      this.totalPage,
      this.offset,
      this.limit,
      this.page,
      this.prevPage,
      this.nextPage,
      this.data});

  DataOrder.fromJson(Map<String, dynamic> json) {
    totalRecord = json['total_record'];
    totalPage = json['total_page'];
    offset = json['offset'];
    limit = json['limit'];
    page = json['page'];
    prevPage = json['prev_page'];
    nextPage = json['next_page'];
    if (json['data'] != null) {
      data = <Order>[];
      json['data'].forEach((v) {
        data!.add(Order.fromJson(v));
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

class Order {
  int? id;
  String? totalAmount;
  String? receiptCode;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? paymentType;
  String? paymentLastStatus;

  Order(
      {this.id,
      this.totalAmount,
      this.receiptCode,
      this.status,
      this.paymentType,
      this.paymentLastStatus});

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    totalAmount = json['total_amount'];
    receiptCode = json['receipt_code'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    paymentType = json['payment_type'];
    paymentLastStatus = json['payment_last_status'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['total_amount'] = totalAmount;
    data['receipt_code'] = receiptCode;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['payment_type'] = paymentType;
    data['payment_last_status'] = paymentLastStatus;
    return data;
  }
}
