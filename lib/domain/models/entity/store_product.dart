class StoreProduct {
  int? storeId;

  StoreProduct({this.storeId});

  StoreProduct.fromJson(Map<String, dynamic> json) {
    storeId = json['store_id'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['store_id'] = storeId;
    return data;
  }
}
