import 'category.dart';
import 'division.dart';

class Product {
  int? id;
  String? name;
  String? plu;
  Category? productCategory;
  Division? productDivision;
  int? productDivisionId;
  String? sellingPrice;
  String? discountPrice;
  double? discount;
  int? qty;
  String? defaultImageUrl;
  int? storeId;
  bool? isWishlist;
  bool? isRoutineShop;
  int? maxPurchase;
  String? pricePerGram;
  String? unit;
  int? minWeight;

  Product(
      {this.id,
      this.name,
      this.plu,
      this.productCategory,
      this.productDivision,
      this.productDivisionId,
      this.sellingPrice,
      this.discountPrice,
      this.discount,
      this.qty,
      this.defaultImageUrl,
      this.storeId,
      this.isWishlist,
      this.isRoutineShop,
      this.maxPurchase,
      this.pricePerGram,
      this.unit,
      this.minWeight});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productDivisionId = json['product_division_id'];
    name = json['name'];
    plu = json['plu'];
    productCategory = json['product_category'] != null
        ? Category.fromJson(json['product_category'])
        : null;
    productDivision = json['product_division'] != null
        ? Division.fromJson(json['product_division'])
        : null;
    sellingPrice = json['selling_price'];
    discountPrice = json['discount_price'];
    discount = json['discount'] is int
        ? (json['discount'] as int).toDouble()
        : json['discount'];
    qty = json['qty'];
    defaultImageUrl = json['default_image_url'];
    storeId = json['store_id'];
    isWishlist = json['is_wishlist'];
    isRoutineShop = json['is_routine_shopping_list'];
    maxPurchase = json['max_purchase'];
    pricePerGram = json['price_per_gram'];
    unit = json['unit'];
    minWeight = json['min_weight'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['product_division_id'] = productDivisionId;
    data['name'] = name;
    data['plu'] = plu;
    if (productCategory != null) {
      data['product_category'] = productCategory!.toJson();
    }
    if (productDivision != null) {
      data['product_division'] = productDivision!.toJson();
    }
    data['selling_price'] = sellingPrice;
    data['discount_price'] = discountPrice;
    data['discount'] = discount;
    data['qty'] = qty;
    data['default_image_url'] = defaultImageUrl;
    data['store_id'] = storeId;
    data['is_wishlist'] = isWishlist;
    data['is_routine_shopping_list'] = isRoutineShop;
    data['max_purchase'] = maxPurchase;
    data['price_per_gram'] = pricePerGram;
    data['unit'] = unit;
    data['min_weight'] = minWeight;
    return data;
  }
}
