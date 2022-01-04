class XenditBank {
  String? name;
  String? code;
  bool? canDisburse;
  bool? canNameValidate;

  XenditBank({this.name, this.code, this.canDisburse, this.canNameValidate});

  XenditBank.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    code = json['code'];
    canDisburse = json['can_disburse'];
    canNameValidate = json['can_name_validate'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['code'] = code;
    data['can_disburse'] = canDisburse;
    data['can_name_validate'] = canNameValidate;
    return data;
  }
}
