import 'package:SuperNinja/domain/models/entity/banners.dart';

class ResponseListBanners {
  List<Banners>? data;
  dynamic meta;

  ResponseListBanners({this.data, this.meta});

  ResponseListBanners.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Banners>[];
      json['data'].forEach((v) {
        data!.add(Banners.fromJson(v));
      });
    }
    meta = json['meta'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['meta'] = meta;
    return data;
  }
}
