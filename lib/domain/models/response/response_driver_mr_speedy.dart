class ResponseDriverMrSpeedy {
  bool? isSuccessful;
  Courier? courier;

  ResponseDriverMrSpeedy({this.isSuccessful, this.courier});

  ResponseDriverMrSpeedy.fromJson(Map<String, dynamic> json) {
    isSuccessful = json['is_successful'];
    courier =
        json['courier'] != null ? Courier.fromJson(json['courier']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['is_successful'] = isSuccessful;
    if (courier != null) {
      data['courier'] = courier!.toJson();
    }
    return data;
  }
}

class Courier {
  int? courierId;
  String? surname;
  String? name;
  String? middlename;
  String? phone;
  String? photoUrl;
  double? latitude;
  double? longitude;

  Courier(
      {this.courierId,
      this.surname,
      this.name,
      this.middlename,
      this.phone,
      this.photoUrl,
      this.latitude,
      this.longitude});

  Courier.fromJson(Map<String, dynamic> json) {
    courierId = json['courier_id'];
    surname = json['surname'];
    name = json['name'];
    middlename = json['middlename'];
    phone = json['phone'];
    photoUrl = json['photo_url'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['courier_id'] = courierId;
    data['surname'] = surname;
    data['name'] = name;
    data['middlename'] = middlename;
    data['phone'] = phone;
    data['photo_url'] = photoUrl;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }
}
