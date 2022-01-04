import 'package:scrumpoker/domain/models/entity/product_detail.dart';

class ResponseDetailProduct {
  ProductDetail? data;
  dynamic meta;

  ResponseDetailProduct({this.data, this.meta});

  ResponseDetailProduct.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? ProductDetail.fromJson(json['data']) : null;
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
