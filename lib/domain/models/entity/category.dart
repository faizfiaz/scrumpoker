class Category {
  int? id;
  String? name;
  String? iconUrl;

  Category({this.id, this.name, this.iconUrl});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    iconUrl = json['icon_url'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['icon_url'] = iconUrl;
    return data;
  }
}
