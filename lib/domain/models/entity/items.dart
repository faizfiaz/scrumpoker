import 'package:scrumpoker/domain/models/entity/product.dart';

class Items {
  int? id;
  Product? product;
  int? qty;
  bool? isChecked = false;
  bool isNotValid = false;

  Items({this.id, this.product, this.qty});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    product =
        json['product'] != null ? Product.fromJson(json['product']) : null;
    qty = json['qty'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    if (product != null) {
      data['product'] = product!.toJson();
    }
    data['qty'] = qty;
    return data;
  }
}
