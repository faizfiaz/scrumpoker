import 'package:scrumpoker/domain/models/entity/city.dart';

class ResponseListCity {
  List<City>? data;
  dynamic meta;

  ResponseListCity({this.data, this.meta});

  ResponseListCity.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <City>[];
      json['data'].forEach((v) {
        data!.add(City.fromJson(v));
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
