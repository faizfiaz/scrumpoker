class ResponseCountCart {
  CountCarts? data;
  dynamic meta;

  ResponseCountCart({this.data, this.meta});

  ResponseCountCart.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? CountCarts.fromJson(json['data']) : null;
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

class CountCarts {
  int? total;

  CountCarts({this.total});

  CountCarts.fromJson(Map<String, dynamic> json) {
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['total'] = total;
    return data;
  }
}
