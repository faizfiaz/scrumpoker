class ResponseDetailOrder {
  DetailOrder? data;
  dynamic meta;

  ResponseDetailOrder({this.data, this.meta});

  ResponseDetailOrder.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? DetailOrder.fromJson(json['data']) : null;
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

class DetailOrder {
  int? id;
  String? receiptCode;
  String? totalAmount;
  String? deliveryFee;
  String? createdAt;
  String? updatedAt;
  String? notes;
  String? status;
  List<ItemsDetailOrder>? items;
  OrderPayment? orderPayment;
  UserClDetailOrder? userCl;
  String? deliveryReference;
  String? canceledReason;
  bool? canDisburse;
  String? disburseAmount;
  String? disburseData;
  int? voucherId;
  String? voucherName;
  String? voucherCode;
  String? voucherType;
  String? voucherValue;
  String? totalVoucherAmount;

  DetailOrder(
      {this.id,
      this.receiptCode,
      this.totalAmount,
      this.deliveryFee,
      this.createdAt,
      this.updatedAt,
      this.status,
      this.notes,
      this.items,
      this.orderPayment,
      this.userCl,
      this.deliveryReference,
      this.canceledReason,
      this.canDisburse,
      this.disburseAmount,
      this.disburseData,
      this.voucherId,
      this.voucherName,
      this.voucherCode,
      this.voucherType,
      this.voucherValue,
      this.totalVoucherAmount});

  DetailOrder.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    receiptCode = json['receipt_code'];
    totalAmount = json['total_amount'];
    deliveryFee = json['delivery_fee'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status = json['status'];
    notes = json['notes'];
    if (json['items'] != null) {
      items = <ItemsDetailOrder>[];
      json['items'].forEach((v) {
        items!.add(ItemsDetailOrder.fromJson(v));
      });
    }
    orderPayment = json['order_payment'] != null
        ? OrderPayment.fromJson(json['order_payment'])
        : null;
    userCl = json['user_cl'] != null
        ? UserClDetailOrder.fromJson(json['user_cl'])
        : null;
    deliveryReference = json['delivery_reference'];
    canceledReason = json['canceled_reason'];
    canDisburse = json['can_disburse'];
    disburseAmount = json['disburse_amount'];
    disburseData = json['disburse_data'];
    voucherId = json['voucher_id'];
    voucherName = json['voucher_name'];
    voucherCode = json['voucher_code'];
    voucherType = json['voucher_type'];
    voucherValue = json['voucher_value'];
    totalVoucherAmount = json['total_voucher_amount'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['receipt_code'] = receiptCode;
    data['total_amount'] = totalAmount;
    data['delivery_fee'] = deliveryFee;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['status'] = status;
    data['notes'] = notes;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    if (orderPayment != null) {
      data['order_payment'] = orderPayment!.toJson();
    }
    if (userCl != null) {
      data['user_cl'] = userCl!.toJson();
    }
    data['delivery_reference'] = deliveryReference;
    data['canceled_reason'] = canceledReason;
    data['can_disburse'] = canDisburse;
    data['disburse_amount'] = disburseAmount;
    data['disburse_data'] = disburseData;
    data['voucher_id'] = voucherId;
    data['voucher_name'] = voucherName;
    data['voucher_code'] = voucherCode;
    data['voucher_type'] = voucherType;
    data['voucher_value'] = voucherValue;
    data['total_voucher_amount'] = totalVoucherAmount;
    return data;
  }
}

class ItemsDetailOrder {
  int? id;
  ProductDetailOrder? product;
  int? qty;
  String? price;
  String? subtotal;
  List<ModifiedHistories>? modifiedHistories;

  ItemsDetailOrder(
      {this.id,
      this.product,
      this.qty,
      this.price,
      this.subtotal,
      this.modifiedHistories});

  ItemsDetailOrder.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    product = json['product'] != null
        ? ProductDetailOrder.fromJson(json['product'])
        : null;
    qty = json['qty'];
    price = json['price'];
    subtotal = json['subtotal'];
    if (json['modified_histories'] != null) {
      modifiedHistories = <ModifiedHistories>[];
      json['modified_histories'].forEach((v) {
        modifiedHistories!.add(ModifiedHistories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    if (product != null) {
      data['product'] = product!.toJson();
    }
    data['qty'] = qty;
    data['price'] = price;
    data['subtotal'] = subtotal;
    if (modifiedHistories != null) {
      data['modified_histories'] =
          modifiedHistories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ModifierHistories {
  List<ModifiedHistories>? modifiedHistories;

  ModifierHistories({this.modifiedHistories});

  ModifierHistories.fromJson(Map<String, dynamic> json) {
    if (json['modified_histories'] != null) {
      modifiedHistories = <ModifiedHistories>[];
      json['modified_histories'].forEach((v) {
        modifiedHistories!.add(ModifiedHistories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (modifiedHistories != null) {
      data['modified_histories'] =
          modifiedHistories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ModifiedHistories {
  int? oldQty;
  int? newQty;

  ModifiedHistories({this.oldQty, this.newQty});

  ModifiedHistories.fromJson(Map<String, dynamic> json) {
    oldQty = json['old_qty'];
    newQty = json['new_qty'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['old_qty'] = oldQty;
    data['new_qty'] = newQty;
    return data;
  }
}

class ProductDetailOrder {
  int? id;
  String? name;
  String? defaultImageUrl;
  String? pricePerGram;

  ProductDetailOrder(
      {this.id, this.name, this.defaultImageUrl, this.pricePerGram});

  ProductDetailOrder.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    defaultImageUrl = json['default_image_url'];
    pricePerGram = json['price_per_gram'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['default_image_url'] = defaultImageUrl;
    data['price_per_gram'] = pricePerGram;
    return data;
  }
}

class OrderPayment {
  int? id;
  String? name;
  String? billAmount;
  String? payAmount;
  String? paymentType;
  String? latestStatus;
  String? redirectUrl;

  OrderPayment(
      {this.id,
      this.name,
      this.billAmount,
      this.payAmount,
      this.paymentType,
      this.latestStatus});

  OrderPayment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    billAmount = json['bill_amount'];
    payAmount = json['pay_amount'];
    paymentType = json['payment_type'];
    latestStatus = json['latest_status'];
    redirectUrl = json['redirect_url'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['bill_amount'] = billAmount;
    data['pay_amount'] = payAmount;
    data['payment_type'] = paymentType;
    data['latest_status'] = latestStatus;
    data['redirect_url'] = redirectUrl;
    return data;
  }
}

class UserClDetailOrder {
  int? id;
  String? name;
  String? phoneNumber;
  String? address;
  int? provinceId;
  String? provinceName;
  int? cityId;
  String? cityName;
  int? storeId;

  UserClDetailOrder(
      {this.id,
      this.name,
      this.phoneNumber,
      this.address,
      this.provinceId,
      this.provinceName,
      this.cityId,
      this.cityName,
      this.storeId});

  UserClDetailOrder.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phoneNumber = json['phone_number'];
    address = json['address'];
    provinceId = json['province_id'];
    provinceName = json['province_name'];
    cityId = json['city_id'];
    cityName = json['city_name'];
    storeId = json['store_id'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['phone_number'] = phoneNumber;
    data['address'] = address;
    data['province_id'] = provinceId;
    data['province_name'] = provinceName;
    data['city_id'] = cityId;
    data['city_name'] = cityName;
    data['store_id'] = storeId;
    return data;
  }
}
