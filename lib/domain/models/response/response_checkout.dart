import 'dart:convert';

import 'package:scrumpoker/domain/models/entity/user_cl.dart';

class ResponseCheckout {
  Checkout? data;
  dynamic meta;

  ResponseCheckout({this.data, this.meta});

  ResponseCheckout.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Checkout.fromJson(json['data']) : null;
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

class Checkout {
  int? cartId;
  String? totalPrice;
  String? deliveryFee;
  List<ItemsCheckout>? items;
  UserCl? userCl;
  String? notes;
  String? totalPriceBeforeVoucher;
  VoucherDetail? voucherDetail;
  StoreCheckout? storeCheckout;

  Checkout(
      {this.cartId,
      this.totalPrice,
      this.deliveryFee,
      this.items,
      this.userCl,
      this.totalPriceBeforeVoucher,
      this.voucherDetail});

  Checkout.fromJson(Map<String, dynamic> json) {
    cartId = json['cart_id'];
    totalPrice = json['total_price'];
    deliveryFee = json['delivery_fee'];
    if (json['items'] != null) {
      items = <ItemsCheckout>[];
      json['items'].forEach((v) {
        items!.add(ItemsCheckout.fromJson(v));
      });
    }
    userCl = json['user_cl'] != null ? UserCl.fromJson(json['user_cl']) : null;
    totalPriceBeforeVoucher = json['total_price_before_voucher'];
    voucherDetail = json['voucher_detail'] != null
        ? VoucherDetail.fromJson(json['voucher_detail'])
        : null;
    storeCheckout =
        json['store'] != null ? StoreCheckout.fromMap(json['store']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['cart_id'] = cartId;
    data['total_price'] = totalPrice;
    data['delivery_fee'] = deliveryFee;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    if (userCl != null) {
      data['user_cl'] = userCl!.toJson();
    }
    data['total_price_before_voucher'] = totalPriceBeforeVoucher;
    data['voucher_detail'] = voucherDetail!.toJson();
    if (storeCheckout != null) {
      data['store'] = storeCheckout?.toJson();
    }
    return data;
  }
}

class ItemsCheckout {
  int? id;
  ProductCheckout? product;
  int? qty;

  ItemsCheckout({this.id, this.product, this.qty});

  ItemsCheckout.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    product = json['product'] != null
        ? ProductCheckout.fromJson(json['product'])
        : null;
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

class ProductCheckout {
  int? id;
  String? name;
  String? sellingPrice;
  String? discountPrice;
  int? discount;
  String? defaultImageUrl;
  int? maxPurchase;
  String? pricePerGram;
  String? unit;
  int? minWeight;
  int? weight;

  ProductCheckout(
      {this.id,
      this.name,
      this.sellingPrice,
      this.discountPrice,
      this.discount,
      this.defaultImageUrl,
      this.maxPurchase,
      this.pricePerGram,
      this.unit,
      this.minWeight,
      this.weight});

  ProductCheckout.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    sellingPrice = json['selling_price'];
    discountPrice = json['discount_price'];
    discount = json['discount'];
    defaultImageUrl = json['default_image_url'];
    maxPurchase = json['max_purchase'];
    pricePerGram = json['price_per_gram'];
    unit = json['unit'];
    minWeight = json['min_weight'];
    weight = json['weight'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['selling_price'] = sellingPrice;
    data['discount_price'] = discountPrice;
    data['discount'] = discount;
    data['default_image_url'] = defaultImageUrl;
    data['max_purchase'] = maxPurchase;
    data['price_per_gram'] = pricePerGram;
    data['unit'] = unit;
    data['min_weight'] = minWeight;
    data['weight'] = weight;
    return data;
  }
}

class VoucherDetail {
  Voucher? voucher;
  String? amountOfVoucher;
  String? errValidation;

  VoucherDetail({this.voucher, this.amountOfVoucher, this.errValidation});

  VoucherDetail.fromJson(Map<String, dynamic> json) {
    voucher =
        json['voucher'] != null ? Voucher.fromJson(json['voucher']) : null;
    amountOfVoucher = json['amount_of_voucher'];
    errValidation = json['err_validation'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['voucher'] = voucher!.toJson();
    data['amount_of_voucher'] = amountOfVoucher;
    data['err_validation'] = errValidation;
    return data;
  }
}

class Voucher {
  int? id;
  String? name;
  String? code;
  String? type;
  String? value;
  String? maxDiscount;
  String? minTransactionAmount;

  Voucher(
      {this.id,
      this.name,
      this.code,
      this.type,
      this.value,
      this.maxDiscount,
      this.minTransactionAmount});

  Voucher.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    type = json['type'];
    value = json['value'];
    maxDiscount = json['max_discount'];
    minTransactionAmount = json['min_transaction_amount'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['code'] = code;
    data['type'] = type;
    data['value'] = value;
    data['max_discount'] = maxDiscount;
    data['min_transaction_amount'] = minTransactionAmount;
    return data;
  }
}

class StoreCheckout {
  int? id;
  String? name;
  String? address;
  String? phoneNumber;

  StoreCheckout({this.id, this.name, this.address, this.phoneNumber});

  factory StoreCheckout.fromMap(Map<String, dynamic> data) => StoreCheckout(
        id: data['id'] as int?,
        name: data['name'] as String?,
        address: data['address'] as String?,
        phoneNumber: data['phone_number'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'address': address,
        'phone_number': phoneNumber,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [StoreCheckout].
  factory StoreCheckout.fromJson(String data) {
    return StoreCheckout.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [StoreCheckout] to a JSON string.
  String toJson() => json.encode(toMap());
}
