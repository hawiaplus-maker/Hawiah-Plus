class CategoriesModel {
  bool? success;
  List<Message>? message;

  CategoriesModel({this.success, this.message});

  CategoriesModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['message'] != null) {
      message = <Message>[];
      json['message'].forEach((v) {
        message!.add(new Message.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.message != null) {
      data['message'] = this.message!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Message {
  int? id;
  String? title;
  String? image;
  List<Services>? services;

  Message({this.id, this.title, this.image, this.services});

  Message.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image = json['image'];
    if (json['services'] != null) {
      services = <Services>[];
      json['services'].forEach((v) {
        services!.add(new Services.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['image'] = this.image;
    if (this.services != null) {
      data['services'] = this.services!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Services {
  int? id;
  String? title;
  String? description;
  int? dailyPrice;
  int? weeklyPrice;
  int? monthlyPrice;
  int? yearlyPrice;
  String? image;

  Services(
      {this.id,
      this.title,
      this.description,
      this.dailyPrice,
      this.weeklyPrice,
      this.monthlyPrice,
      this.yearlyPrice,
      this.image});

  Services.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    dailyPrice = json['daily_price'];
    weeklyPrice = json['weekly_price'];
    monthlyPrice = json['monthly_price'];
    yearlyPrice = json['yearly_price'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['daily_price'] = this.dailyPrice;
    data['weekly_price'] = this.weeklyPrice;
    data['monthly_price'] = this.monthlyPrice;
    data['yearly_price'] = this.yearlyPrice;
    data['image'] = this.image;
    return data;
  }
}
