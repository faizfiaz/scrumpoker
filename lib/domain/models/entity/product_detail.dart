import 'package:SuperNinja/domain/models/entity/product_images.dart';
import 'package:SuperNinja/domain/models/entity/store_product.dart';

import 'category.dart';

class ProductDetail {
  int? id;
  String? name;
  String? plu;
  String? description;
  Category? productCategory;
  Category? productPackage;
  Category? productDivision;
  String? sellingPrice;
  String? discountPrice;
  int? discount;
  int? qty;
  int? weight;
  String? unit;
  StoreProduct? storeProduct;
  List<ProductImages>? productImages;
  int? maxPurchase;
  String? pricePerGram;
  int? minWeight;

  ProductDetail(
      {this.id,
      this.name,
      this.plu,
      this.description,
      this.productCategory,
      this.productPackage,
      this.productDivision,
      this.sellingPrice,
      this.discountPrice,
      this.discount,
      this.qty,
      this.weight,
      this.unit,
      this.storeProduct,
      this.productImages,
      this.maxPurchase,
      this.pricePerGram,
      this.minWeight});

  ProductDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    plu = json['plu'];
    description = json['description'];
    productCategory = json['product_category'] != null
        ? Category.fromJson(json['product_category'])
        : null;
    productPackage = json['product_package'] != null
        ? Category.fromJson(json['product_package'])
        : null;
    productDivision = json['product_division'] != null
        ? Category.fromJson(json['product_division'])
        : null;
    sellingPrice = json['selling_price'];
    discountPrice = json['discount_price'];
    discount = json['discount'];
    qty = json['qty'];
    weight = json['weight'];
    unit = json['unit'];
    storeProduct = json['store_product'] != null
        ? StoreProduct.fromJson(json['store_product'])
        : null;
    if (json['product_images'] != null) {
      productImages = <ProductImages>[];
      json['product_images'].forEach((v) {
        productImages!.add(ProductImages.fromJson(v));
      });
    }
    maxPurchase = json['max_purchase'];
    pricePerGram = json['price_per_gram'];
    minWeight = json['min_weight'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['plu'] = plu;
    data['description'] = description;
    if (productCategory != null) {
      data['product_category'] = productCategory!.toJson();
    }
    if (productPackage != null) {
      data['product_package'] = productPackage!.toJson();
    }
    if (productDivision != null) {
      data['product_division'] = productDivision!.toJson();
    }
    data['selling_price'] = sellingPrice;
    data['discount_price'] = discountPrice;
    data['discount'] = discount;
    data['qty'] = qty;
    data['weight'] = weight;
    data['unit'] = unit;
    if (storeProduct != null) {
      data['store_product'] = storeProduct!.toJson();
    }
    if (productImages != null) {
      data['product_images'] = productImages!.map((v) => v.toJson()).toList();
    }
    data['max_purchase'] = maxPurchase;
    data['price_per_gram'] = pricePerGram;
    data['min_weight'] = minWeight;
    return data;
  }
}
