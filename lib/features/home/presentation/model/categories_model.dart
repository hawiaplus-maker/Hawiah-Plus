class CategoriesModel {
  bool? success;
  List<SingleCategoryModel>? message;

  CategoriesModel({this.success, this.message});

  CategoriesModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['message'] != null) {
      message = <SingleCategoryModel>[];
      json['message'].forEach((v) {
        message!.add(new SingleCategoryModel.fromJson(v));
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

class SingleCategoryModel {
  int? id;
  String? title;
  String? subtitle;
  String? image;
  List<Services>? services;

  SingleCategoryModel({this.id, this.title, this.image, this.services, this.subtitle});

  SingleCategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image = json['image'];
    subtitle = json['subtitle'];
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
    data['subtitle'] = this.subtitle;
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
    this.image,
    this.unit,
    this.size,
    this.length,
    this.width,
    this.height,
  });

  Services.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    image = json['image'];
    unit = json['unit'];
    size = json['size'];
    length = json['length'];
    width = json['width'];
    height = json['height'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['image'] = image;
    data['unit'] = unit;
    data['size'] = size;
    data['length'] = length;
    data['width'] = width;
    data['height'] = height;
    return data;
  }
}
