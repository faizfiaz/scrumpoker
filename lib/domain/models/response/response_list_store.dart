class ResponseListStore {
  ResponseListStore({
    required this.data,
    this.meta,
  });
  late final List<StoreData> data;
  late final dynamic meta;

  ResponseListStore.fromJson(Map<String, dynamic> json) {
    data = List.from(json['data']).map((e) => StoreData.fromJson(e)).toList();
    meta = null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['data'] = data.map((e) => e.toJson()).toList();
    _data['meta'] = meta;
    return _data;
  }
}

class StoreData {
  StoreData({
    required this.id,
    required this.name,
  });
  late final int id;
  late final String name;

  StoreData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    return _data;
  }
}
