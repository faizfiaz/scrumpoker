import 'package:SuperNinja/domain/models/entity/province.dart';

class ResponseListProvince {
  List<Province>? data;
  dynamic meta;

  ResponseListProvince({this.data, this.meta});

  ResponseListProvince.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Province>[];
      json['data'].forEach((v) {
        data!.add(Province.fromJson(v));
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
