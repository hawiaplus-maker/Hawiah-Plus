class OrderDetailsModel {
  int? id;
  String? otp;
  int? referenceNumber;
  String? address;
  double? latitude;
  double? longitude;
  int? orderStatus;
  String? paidStatus;
  StatusModel? status;
  String? priceId;
  int? duration;
  String? totalPrice;
  String? fromDate;
  String? toDate;
  String? discount;
  String? discountValue;
  String? createdAt;
  String? product;
  String? image;

  String? driver;
  String? driverMobile;

  List<VehicleModel>? vehicles;

  String? serviceProvider;
  String? serviceProviderMobile;

  String? user;
  String? userMobile;

  String? driverFcmToken;
  String? userFcmToken;
  String? serviceProviderFcmToken;

  String? contract;
  String? invoice;
  String? support;

  OrderDetailsModel({
    this.id,
    this.otp,
    this.referenceNumber,
    this.address,
    this.latitude,
    this.longitude,
    this.orderStatus,
    this.paidStatus,
    this.status,
    this.priceId,
    this.duration,
    this.totalPrice,
    this.fromDate,
    this.toDate,
    this.discount,
    this.discountValue,
    this.createdAt,
    this.product,
    this.image,
    this.driver,
    this.driverMobile,
    this.vehicles,
    this.serviceProvider,
    this.serviceProviderMobile,
    this.user,
    this.userMobile,
    this.driverFcmToken,
    this.userFcmToken,
    this.serviceProviderFcmToken,
    this.contract,
    this.invoice,
    this.support,
  });

  factory OrderDetailsModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailsModel(
      id: json['id'],
      otp: json['otp'],
      referenceNumber: json['reference_number'],
      address: json['address'],
      latitude: double.tryParse(json['latitude']?.toString() ?? ''),
      longitude: double.tryParse(json['longitude']?.toString() ?? ''),
      orderStatus: json['order_status'],
      paidStatus: json['paid_status']?.toString(),
      status: json['status'] != null ? StatusModel.fromJson(json['status']) : null,
      priceId: json['price_id']?.toString(),
      duration: json['duration'],
      totalPrice: json['total_price'],
      fromDate: json['from_date'],
      toDate: json['to_date'],
      discount: json['discount']?.toString(),
      discountValue: json['discount_value']?.toString(),
      createdAt: json['created_at'],
      product: json['product'],
      image: json['image'],
      driver: json['driver'],
      driverMobile: json['driver_mobile'],
      vehicles: (json['vehicles'] as List?)?.map((e) => VehicleModel.fromJson(e)).toList() ?? [],
      serviceProvider: json['service_provider'],
      serviceProviderMobile: json['service_provider_mobile'],
      user: json['user'],
      userMobile: json['user_mobile'],
      driverFcmToken: json['driver_fcm_token'],
      userFcmToken: json['user_fcm_token'],
      serviceProviderFcmToken: json['service_provider_fcm_token'],
      contract: json['contract'],
      invoice: json['invoice'],
      support: json['support'],
    );
  }
}

class StatusModel {
  String? en;
  String? ar;

  StatusModel({this.en, this.ar});

  factory StatusModel.fromJson(Map<String, dynamic> json) {
    return StatusModel(
      en: json['en'],
      ar: json['ar'],
    );
  }

  Map<String, dynamic> toJson() => {
        'en': en,
        'ar': ar,
      };
}

class VehicleModel {
  final String plateLetters;
  final String plateNumbers;
  final String carType;
  final String carBrand;
  final String carModel;
  final String carYear;

  VehicleModel({
    required this.plateLetters,
    required this.plateNumbers,
    required this.carType,
    required this.carBrand,
    required this.carModel,
    required this.carYear,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      plateLetters: json['plate_letters'] ?? '',
      plateNumbers: json['plate_numbers'] ?? '',
      carType: json['car_type'] ?? '',
      carBrand: json['car_brand'] ?? '',
      carModel: json['car_model'] ?? '',
      carYear: json['car_year'] ?? '',
    );
  }
}
