class UserCl {
  int? id;
  String? name;
  String? address;
  String? phoneNumber;

  UserCl({this.id, this.name, this.address, this.phoneNumber});

  UserCl.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    phoneNumber = json['phone_number'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['address'] = address;
    data['phone_number'] = phoneNumber;
    return data;
  }
}
