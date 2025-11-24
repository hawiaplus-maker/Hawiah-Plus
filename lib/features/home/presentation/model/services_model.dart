import 'dart:convert';

ServicesModel servicesModelFromJson(String str) => ServicesModel.fromJson(json.decode(str));

String servicesModelToJson(ServicesModel data) => json.encode(data.toJson());

class ServicesModel {
  bool success;
  List<Message> message;

  ServicesModel({
    required this.success,
    required this.message,
  });

  factory ServicesModel.fromJson(Map<String, dynamic> json) => ServicesModel(
        success: json["success"] ?? false,
        message: List<Message>.from((json["message"] ?? []).map((x) => Message.fromJson(x))),
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
  String unit;
  int size;
  int length;
  int width;
  int height;
  List<int> categoryId;
  String image;

  Message({
    required this.id,
    required this.title,
    required this.description,
    required this.unit,
    required this.size,
    required this.length,
    required this.width,
    required this.height,
    required this.categoryId,
    required this.image,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json["id"] ?? 0,
        title: json["title"] ?? '',
        description: json["description"] ?? '',
        unit: json["unit"] ?? '',
        size: json["size"] ?? 0,
        length: json["length"] ?? 0,
        width: json["width"] ?? 0,
        height: json["height"] ?? 0,
        categoryId: List<int>.from(json["category_id"] ?? []),
        image: json["image"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "unit": unit,
        "size": size,
        "length": length,
        "width": width,
        "height": height,
        "category_id": List<dynamic>.from(categoryId.map((x) => x)),
        "image": image,
      };
}
