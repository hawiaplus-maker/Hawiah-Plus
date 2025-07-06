class NearbyServiceProviderModel {
  int? id;
  int? productId;
  String? dailyPrice;
  String? yearlyPrice;
  int? duration;
  dynamic serviceProviderId;
  String? serviceProviderName;

  NearbyServiceProviderModel(
      {this.id,
      this.productId,
      this.dailyPrice,
      this.yearlyPrice,
      this.duration,
      this.serviceProviderId,
      this.serviceProviderName});

  NearbyServiceProviderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    dailyPrice = json['daily_price'];
    yearlyPrice = json['yearly_price'];
    duration = json['duration'];
    serviceProviderId = json['service_provider_id'];
    serviceProviderName = json['service_provider_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_id'] = this.productId;
    data['daily_price'] = this.dailyPrice;
    data['yearly_price'] = this.yearlyPrice;
    data['duration'] = this.duration;
    data['service_provider_id'] = this.serviceProviderId;
    data['service_provider_name'] = this.serviceProviderName;
    return data;
  }
}
