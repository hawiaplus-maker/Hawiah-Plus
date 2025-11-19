class ShowCategoriesModel {
  bool? success;
  Message? message;

  ShowCategoriesModel({this.success, this.message});

  ShowCategoriesModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'] != null ? Message.fromJson(json['message']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['success'] = success;
    if (message != null) data['message'] = message!.toJson();
    return data;
  }
}

class Message {
  int? id;
  String? title;
  String? subtitle; 
  String? image;
  List<Services>? services;

  Message({this.id, this.title, this.subtitle, this.image, this.services});

  Message.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    subtitle = json['subtitle']; 
    image = json['image'];
    if (json['services'] != null) {
      services = <Services>[];
      json['services'].forEach((v) {
        services!.add(Services.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['subtitle'] = subtitle; 
    data['image'] = image;
    if (services != null) data['services'] = services!.map((v) => v.toJson()).toList();
    return data;
  }
}

class Services {
  int? id;
  String? title;
  String? description; 
  String? unit; 
  int? size; 
  int? length; 
  int? width; 
  int? height; 
  String? image;

  Services({
    this.id,
    this.title,
    this.description,
    this.unit,
    this.size,
    this.length,
    this.width,
    this.height,
    this.image,
  });

  Services.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description']; 
    unit = json['unit']; 
    size = json['size']; 
    length = json['length']; 
    width = json['width']; 
    height = json['height']; 
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['unit'] = unit;
    data['size'] = size;
    data['length'] = length;
    data['width'] = width;
    data['height'] = height;
    data['image'] = image;
    return data;
  }
}
