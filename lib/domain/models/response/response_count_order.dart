class ResponseCountOrder {
  CountOrder? data;
  dynamic meta;

  ResponseCountOrder({this.data, this.meta});

  ResponseCountOrder.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? CountOrder.fromJson(json['data']) : null;
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

class CountOrder {
  int? totalArrived;
  int? totalDelivery;
  int? totalInprogress;
  int? totalWaitingPayment;

  CountOrder(
      {this.totalArrived,
      this.totalDelivery,
      this.totalInprogress,
      this.totalWaitingPayment});

  CountOrder.fromJson(Map<String, dynamic> json) {
    totalArrived = json['total_arrived'];
    totalDelivery = json['total_delivery'];
    totalInprogress = json['total_inprogress'];
    totalWaitingPayment = json['total_waiting_payment'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['total_arrived'] = totalArrived;
    data['total_delivery'] = totalDelivery;
    data['total_inprogress'] = totalInprogress;
    data['total_waiting_payment'] = totalWaitingPayment;
    return data;
  }
}
