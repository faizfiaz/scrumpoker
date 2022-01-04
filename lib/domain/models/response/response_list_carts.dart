import 'package:scrumpoker/domain/models/entity/cart.dart';

class ResponseListCarts {
  Cart? data;
  dynamic meta;

  ResponseListCarts({this.data, this.meta});

  ResponseListCarts.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Cart.fromJson(json['data']) : null;
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
