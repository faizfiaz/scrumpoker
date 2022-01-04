class ResponseListPayment {
  List<Payment>? data;
  dynamic meta;

  ResponseListPayment({this.data, this.meta});

  ResponseListPayment.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Payment>[];
      json['data'].forEach((v) {
        data!.add(Payment.fromJson(v));
      });
    }
    meta = json['meta'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['meta'] = meta;
    return data;
  }
}

class Payment {
  int? id;
  String? name;
  String? code;
  String? icon;
  String? paymentType;

  Payment({this.id, this.name, this.code, this.icon, this.paymentType});

  Payment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    icon = json['icon'];
    paymentType = json['payment_type'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['code'] = code;
    data['icon'] = icon;
    data['payment_type'] = paymentType;
    return data;
  }
}
