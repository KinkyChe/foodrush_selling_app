class Address {
  String? name;
  String? phoneNumber;
  String? flatNumber;
  String? city;
  String? state;
  String? fullAddress;
  double? lat;
  double? lng;

  Address({
    this.name,
    this.fullAddress,
    this.city,
    this.flatNumber,
    this.lat,
    this.lng,
    this.phoneNumber,
    this.state
  });

  Address.fromJson(Map<String, dynamic> json){
    name = json['name'];
    fullAddress = json['fullAddress'];
    city = json['city'];
    flatNumber = json['flatNumber'];
    lat = json['lat'];
    lng = json['lng'];
    phoneNumber = json['phoneNumber'];
    state = json['state'];
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = name;
    data['fullAddress'] = fullAddress;
    data['city'] = city;
    data['flatNumber'] = flatNumber;
    data['lat'] = lat;
    data['lng'] = lng;
    data['phoneNumber'] = phoneNumber;
    data['state'] = state;

    return data;
  }
}