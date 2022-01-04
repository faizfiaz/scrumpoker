import 'items.dart';

class Cart {
  int? cartId;
  String? totalPrice;
  List<Items>? items;

  Cart({this.cartId, this.totalPrice, this.items});

  Cart.fromJson(Map<String, dynamic> json) {
    cartId = json['cart_id'];
    totalPrice = json['total_price'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['cart_id'] = cartId;
    data['total_price'] = totalPrice;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
