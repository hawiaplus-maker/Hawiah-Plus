// To parse this JSON data, do
//
//     final showservicesModel = showservicesModelFromJson(jsonString);

import 'dart:convert';

ShowservicesModel showservicesModelFromJson(String str) =>
    ShowservicesModel.fromJson(json.decode(str));

String showservicesModelToJson(ShowservicesModel data) =>
    json.encode(data.toJson());

class ShowservicesModel {
  bool success;
  Message message;

  ShowservicesModel({
    required this.success,
    required this.message,
  });

  factory ShowservicesModel.fromJson(Map<String, dynamic> json) =>
      ShowservicesModel(
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
