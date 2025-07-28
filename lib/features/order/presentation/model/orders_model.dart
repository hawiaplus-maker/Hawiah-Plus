class OrdersModel {
  bool? success;
  String? message;
  List<Data>? data;

  OrdersModel({this.success, this.message, this.data});

  OrdersModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? referenceNumber;
  String? address;
  String? latitude;
  String? longitude;
  int? orderStatus;
  Status? status;
  int? priceId;
  int? duration;
  String? totalPrice;
  String? fromDate;
  String? toDate;
  int? discount;
  int? discountValue;
  String? createdAt;
  String? product;
  String? image;
  String? driver;
  String? driverMobile;
  List<Vehicles>? vehicles;
  String? otp;
  String? user;
  String? userMobile;
  String? contract;
  String? invoice;
  

  Data(
      {this.id,
      this.referenceNumber,
      this.address,
      this.latitude,
      this.longitude,
      this.orderStatus,
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
      this.otp,
      this.user,
      this.userMobile,
      this.contract,
      
      this.invoice});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    referenceNumber = json['reference_number'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    orderStatus = json['order_status'];
    status =
        json['status'] != null ? new Status.fromJson(json['status']) : null;
    priceId = json['price_id'];
    duration = json['duration'];
    totalPrice = json['total_price'];
    fromDate = json['from_date'];
    toDate = json['to_date'];
    discount = json['discount'];
    discountValue = json['discount_value'];
    createdAt = json['created_at'];
    product = json['product'];
    image = json['image'];
    driver = json['driver'];
    
    driverMobile = json['driver_mobile'];
    if (json['vehicles'] != null) {
      vehicles = <Vehicles>[];
      json['vehicles'].forEach((v) {
        vehicles!.add(new Vehicles.fromJson(v));
      });
    }
    otp = json['otp'];
    user = json['user'];
    userMobile = json['user_mobile'];
    contract = json['contract'];
    invoice = json['invoice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['reference_number'] = this.referenceNumber;
    data['address'] = this.address;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['order_status'] = this.orderStatus;
    if (this.status != null) {
      data['status'] = this.status!.toJson();
    }
    data['price_id'] = this.priceId;
    data['duration'] = this.duration;
    data['total_price'] = this.totalPrice;
    data['from_date'] = this.fromDate;
    data['to_date'] = this.toDate;
    data['discount'] = this.discount;
    data['discount_value'] = this.discountValue;
    data['created_at'] = this.createdAt;
    data['product'] = this.product;
    data['image'] = this.image;
    data['driver'] = this.driver;
    data['driver_mobile'] = this.driverMobile;
    if (this.vehicles != null) {
      data['vehicles'] = this.vehicles!.map((v) => v.toJson()).toList();
    }
    data['otp'] = this.otp;
    data['user'] = this.user;
    data['user_mobile'] = this.userMobile;
    data['contract'] = this.contract;
    data['invoice'] = this.invoice;
    return data;
  }
}

class Status {
  String? en;
  String? ar;

  Status({this.en, this.ar});

  Status.fromJson(Map<String, dynamic> json) {
    en = json['en'];
    ar = json['ar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['en'] = this.en;
    data['ar'] = this.ar;
    return data;
  }
}

class Vehicles {
  String? plateLetters;
  String? plateNumbers;
  String? carType;
  String? carBrand;
  String? carModel;
  String? carYear;

  Vehicles(
      {this.plateLetters,
      this.plateNumbers,
      this.carType,
      this.carBrand,
      this.carModel,
      this.carYear});

  Vehicles.fromJson(Map<String, dynamic> json) {
    plateLetters = json['plate_letters'];
    plateNumbers = json['plate_numbers'];
    carType = json['car_type'];
    carBrand = json['car_brand'];
    carModel = json['car_model'];
    carYear = json['car_year'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['plate_letters'] = this.plateLetters;
    data['plate_numbers'] = this.plateNumbers;
    data['car_type'] = this.carType;
    data['car_brand'] = this.carBrand;
    data['car_model'] = this.carModel;
    data['car_year'] = this.carYear;
    return data;
  }
}
