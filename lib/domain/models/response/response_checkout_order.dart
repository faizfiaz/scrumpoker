class ResponseCheckoutOrder {
  CheckoutOrder? data;
  dynamic meta;

  ResponseCheckoutOrder({this.data, this.meta});

  ResponseCheckoutOrder.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? CheckoutOrder.fromJson(json['data']) : null;
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

class CheckoutOrder {
  int? orderId;
  String? redirectUrl;

  CheckoutOrder({this.redirectUrl, this.orderId});

  CheckoutOrder.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    redirectUrl = json['redirect_url'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['order_id'] = orderId;
    data['redirect_url'] = redirectUrl;
    return data;
  }
}
