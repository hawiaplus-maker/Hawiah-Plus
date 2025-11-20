class QuickSelectionCardModel {
  String? day;
  int? days;

  QuickSelectionCardModel({this.day, this.days});

  QuickSelectionCardModel.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    days = json['days'];
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'days': days,
    };
  }
}
