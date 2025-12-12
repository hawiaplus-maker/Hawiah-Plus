class NearbyServiceProviderModel {
  int? id;
  int? productId;
  String? image;
  String? price;

  int? duration;

  int? active;
  dynamic serviceProviderId;
  String? serviceProviderName;
  num? serviceProviderRating;

  NearbyServiceProviderModel({
    this.id,
    this.productId,
    this.image,
    this.price,
    this.duration,
    this.active,
    this.serviceProviderId,
    this.serviceProviderName,
    this.serviceProviderRating,
  });

  NearbyServiceProviderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    image = json['image'];
    price = json['price'];

    duration = json['duration'];

    active = json['active'];
    serviceProviderId = json['service_provider_id'];
    serviceProviderName = json['service_provider_name'];
    serviceProviderRating = json['service_provider_rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['product_id'] = productId;
    data['image'] = image;
    data['price'] = price;

    data['duration'] = duration;

    data['active'] = active;
    data['service_provider_id'] = serviceProviderId;
    data['service_provider_name'] = serviceProviderName;
    data['service_provider_rating'] = serviceProviderRating;
    return data;
  }
}
