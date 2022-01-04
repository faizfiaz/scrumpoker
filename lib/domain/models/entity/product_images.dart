class ProductImages {
  int? id;
  String? imageUrl;

  ProductImages({this.id, this.imageUrl});

  ProductImages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['image_url'] = imageUrl;
    return data;
  }
}
