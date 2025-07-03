// To parse this JSON data, do
//
//     final showCategoriesModel = showCategoriesModelFromJson(jsonString);

import 'dart:convert';

ShowCategoriesModel showCategoriesModelFromJson(String str) =>
    ShowCategoriesModel.fromJson(json.decode(str));

String showCategoriesModelToJson(ShowCategoriesModel data) =>
    json.encode(data.toJson());

class ShowCategoriesModel {
  bool success;
  Message message;

  ShowCategoriesModel({
    required this.success,
    required this.message,
  });

  factory ShowCategoriesModel.fromJson(Map<String, dynamic> json) =>
      ShowCategoriesModel(
        success: json["success"],
        message: Message.fromJson(json["message"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message.toJson(),
      };
}

class Message {
  int id;
  String title;
  String image;
  List<Service> services;

  Message({
    required this.id,
    required this.title,
    required this.image,
    required this.services,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json["id"],
        title: json["title"],
        image: json["image"],
        services: List<Service>.from(
            json["services"].map((x) => Service.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "image": image,
        "services": List<dynamic>.from(services.map((x) => x.toJson())),
      };
}

class Service {
  int id;
  String title;
  String description;
  int dailyPrice;
  int weeklyPrice;
  int monthlyPrice;
  int yearlyPrice;
  String image;

  Service({
    required this.id,
    required this.title,
    required this.description,
    required this.dailyPrice,
    required this.weeklyPrice,
    required this.monthlyPrice,
    required this.yearlyPrice,
    required this.image,
  });

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        dailyPrice: json["daily_price"],
        weeklyPrice: json["weekly_price"],
        monthlyPrice: json["monthly_price"],
        yearlyPrice: json["yearly_price"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "daily_price": dailyPrice,
        "weekly_price": weeklyPrice,
        "monthly_price": monthlyPrice,
        "yearly_price": yearlyPrice,
        "image": image,
      };
}
