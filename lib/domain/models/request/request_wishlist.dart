class RequestWishlist {
  int? productId;
  int? storeId;

  RequestWishlist({this.productId, this.storeId});

  RequestWishlist.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    storeId = json['store_id'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['product_id'] = productId;
    data['store_id'] = storeId;
    return data;
  }
}
