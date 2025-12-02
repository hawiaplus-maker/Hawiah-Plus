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

  // --- الحقول المالية الجديدة ---
  String? totalPrice;
  String? priceBeforeTax; // جديد
  num? vat; // جديد (num يقبل int و double)
  String? vatValue; // جديد
  // ---------------------------

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

  // --- حقول مقدم الخدمة الجديدة ---
  int? serviceProviderId; // جديد
  String? serviceProvider;
  String? serviceProviderMobile;
  num? serviceProviderRating; // جديد
  // ------------------------------

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
    this.priceBeforeTax,
    this.vat,
    this.vatValue,
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
    this.serviceProviderId,
    this.serviceProvider,
    this.serviceProviderMobile,
    this.serviceProviderRating,
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
      otp: json['otp']?.toString(), // تحويل آمن لسترينج
      referenceNumber: json['reference_number'],
      address: json['address'],
      // تحويل آمن للإحداثيات سواء كانت سترينج أو رقم
      latitude: double.tryParse(json['latitude']?.toString() ?? ''),
      longitude: double.tryParse(json['longitude']?.toString() ?? ''),
      orderStatus: int.tryParse(json['order_status']?.toString() ?? ''),
      paidStatus: json['paid_status']?.toString(),
      status: json['status'] != null ? StatusModel.fromJson(json['status']) : null,
      priceId: json['price_id']?.toString(),
      duration: int.tryParse(json['duration']?.toString() ?? ''),

      // الحقول المالية
      totalPrice: json['total_price']?.toString(),
      priceBeforeTax: json['price_before_tax']?.toString(),
      vat: json['vat'], // num يقبل (15) أو (15.0)
      vatValue: json['vat_value']?.toString(),

      fromDate: json['from_date'],
      toDate: json['to_date'],
      discount: json['discount']?.toString(),
      discountValue: json['discount_value']?.toString(),
      createdAt: json['created_at'],
      product: json['product'],
      image: json['image'],

      driver: json['driver'],
      driverMobile: json['driver_mobile']?.toString(),

      vehicles: (json['vehicles'] as List?)?.map((e) => VehicleModel.fromJson(e)).toList() ?? [],

      // حقول مقدم الخدمة
      serviceProviderId: json['service_provider_id'],
      serviceProvider: json['service_provider'],
      serviceProviderMobile: json['service_provider_mobile']?.toString(),
      serviceProviderRating: json['service_provider_rating'], // num يقبل (4.25)

      user: json['user'],
      userMobile: json['user_mobile']?.toString(),

      driverFcmToken: json['driver_fcm_token'],
      userFcmToken: json['user_fcm_token'],
      serviceProviderFcmToken: json['service_provider_fcm_token'],

      contract: json['contract'],
      invoice: json['invoice'],
      support: json['support']?.toString(),
    );
  }
}

// الكلاسات الفرعية كما هي، فقط تأكدنا من صحتها
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
      plateLetters: json['plate_letters']?.toString() ?? '',
      plateNumbers: json['plate_numbers']?.toString() ?? '',
      carType: json['car_type']?.toString() ?? '',
      carBrand: json['car_brand']?.toString() ?? '',
      carModel: json['car_model']?.toString() ?? '',
      carYear: json['car_year']?.toString() ?? '',
    );
  }
}
