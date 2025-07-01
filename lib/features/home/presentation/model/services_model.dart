// To parse this JSON data, do
//
//     final servicesModel = servicesModelFromJson(jsonString);

import 'dart:convert';

ServicesModel servicesModelFromJson(String str) =>
    ServicesModel.fromJson(json.decode(str));

String servicesModelToJson(ServicesModel data) => json.encode(data.toJson());

class ServicesModel {
  bool success;
  List<Message> message;

  ServicesModel({
    required this.success,
    required this.message,
  });

  factory ServicesModel.fromJson(Map<String, dynamic> json) => ServicesModel(
        success: json["success"],
        message:
            List<Message>.from(json["message"].map((x) => Message.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": List<dynamic>.from(message.map((x) => x.toJson())),
      };
}

class Message {
  int id;
  String title;
  String description;
  int dailyPrice;
  int weeklyPrice;
  int monthlyPrice;
  int yearlyPrice;
  String image;

  Message({
    required this.id,
    required this.title,
    required this.description,
    required this.dailyPrice,
    required this.weeklyPrice,
    required this.monthlyPrice,
    required this.yearlyPrice,
    required this.image,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
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
