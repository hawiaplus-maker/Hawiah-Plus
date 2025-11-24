class SliderModel {
  int? id;
  String? title;
  String? description;
  int? active;
  String? image;

  SliderModel({this.id, this.title, this.description, this.active, this.image});

  SliderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    active = json['active'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['active'] = this.active;
    data['image'] = this.image;
    return data;
  }
}
