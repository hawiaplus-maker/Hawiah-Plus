class NearbyServiceProviderModel {
  int? id;
  int? productId;
  String? image;
  String? dailyPrice;
  String? yearlyPrice;
  int? duration;
  int? deliveryTime;
  String? responseSpeed;
  int? active;
  dynamic serviceProviderId;
  String? serviceProviderName;

  NearbyServiceProviderModel({
    this.id,
    this.productId,
    this.image,
    this.dailyPrice,
    this.yearlyPrice,
    this.duration,
    this.deliveryTime,
    this.responseSpeed,
    this.active,
    this.serviceProviderId,
    this.serviceProviderName,
  });

  NearbyServiceProviderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    image = json['image'];
    dailyPrice = json['daily_price'];
    yearlyPrice = json['yearly_price'];
    duration = json['duration'];
    deliveryTime = json['delivery_time'];
    responseSpeed = json['response_speed'];
    active = json['active'];
    serviceProviderId = json['service_provider_id'];
    serviceProviderName = json['service_provider_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['product_id'] = productId;
    data['image'] = image;
    data['daily_price'] = dailyPrice;
    data['yearly_price'] = yearlyPrice;
    data['duration'] = duration;
    data['delivery_time'] = deliveryTime;
    data['response_speed'] = responseSpeed;
    data['active'] = active;
    data['service_provider_id'] = serviceProviderId;
    data['service_provider_name'] = serviceProviderName;
    return data;
  }
}
