import 'package:scrumpoker/domain/models/entity/category.dart';

class ResponseListCategory {
  List<Category>? data;
  dynamic meta;

  ResponseListCategory({this.data, this.meta});

  ResponseListCategory.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Category>[];
      json['data'].forEach((v) {
        data!.add(Category.fromJson(v));
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
