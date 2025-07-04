class NeighborhoodModel {
  int? id;
  String? title;
  String? latitude;
  String? longitude;
  String? city;

  NeighborhoodModel(
      {this.id, this.title, this.latitude, this.longitude, this.city});

  NeighborhoodModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    city = json['city'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['city'] = this.city;
    return data;
  }
}
