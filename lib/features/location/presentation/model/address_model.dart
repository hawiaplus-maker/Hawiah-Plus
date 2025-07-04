class AddressModel {
  int? id;
  String? title;
  String? latitude;
  String? longitude;
  String? neighborhood;
  String? city;

  AddressModel(
      {this.id,
      this.title,
      this.latitude,
      this.longitude,
      this.neighborhood,
      this.city});

  AddressModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    neighborhood = json['neighborhood'];
    city = json['city'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['neighborhood'] = this.neighborhood;
    data['city'] = this.city;
    return data;
  }
}
