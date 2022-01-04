class ResponseListAddress {
  ResponseListAddress({
    required this.data,
    this.meta,
  });
  late final List<UserAddress> data;
  late final dynamic meta;

  ResponseListAddress.fromJson(Map<String, dynamic> json) {
    data = List.from(json['data']).map((e) => UserAddress.fromJson(e)).toList();
    meta = null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['data'] = data.map((e) => e.toJson()).toList();
    _data['meta'] = meta;
    return _data;
  }
}

class UserAddress {
  UserAddress(
      {this.id,
      this.provinceId,
      this.provinceName,
      this.cityId,
      this.cityName,
      this.receiverName,
      this.addressLabel,
      this.address,
      this.latitude,
      this.longitude,
      this.postalCode,
      this.isDefaultAddress});
  int? id;
  int? provinceId;
  String? provinceName;
  int? cityId;
  String? cityName;
  String? receiverName;
  String? addressLabel;
  String? address;
  double? latitude;
  double? longitude;
  String? postalCode;
  bool? isDefaultAddress;

  UserAddress.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    provinceId = json['province_id'];
    provinceName = json['province_name'];
    cityId = json['city_id'];
    cityName = json['city_name'];
    receiverName = json['receiver_name'];
    addressLabel = json['address_label'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    postalCode = json['postal_code'];
    isDefaultAddress = json['is_default_address'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['province_id'] = provinceId;
    _data['province_name'] = provinceName;
    _data['city_id'] = cityId;
    _data['city_name'] = cityName;
    _data['receiver_name'] = receiverName;
    _data['address_label'] = addressLabel;
    _data['address'] = address;
    _data['latitude'] = latitude;
    _data['longitude'] = longitude;
    _data['postal_code'] = postalCode;
    _data['is_default_address'] = isDefaultAddress;
    return _data;
  }
}
