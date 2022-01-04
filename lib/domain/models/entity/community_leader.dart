class CommunityLeader {
  int? id;
  String? name;
  String? displayName;
  String? address;

  CommunityLeader({this.id, this.name, this.displayName, this.address});

  CommunityLeader.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    displayName = json['display_name'];
    address = json['Address'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['display_name'] = displayName;
    data['Address'] = address;
    return data;
  }
}
