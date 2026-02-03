class PaymentMethoudModel {
  int? id;
  String? name;
  double fees; // This is non-nullable

  // 1. Update the default constructor with a default value
  PaymentMethoudModel({
    this.id,
    this.name,
    this.fees = 0.0,
  });

  // 2. Use an initializer list (the part after the colon)
  // to ensure 'fees' is set before the constructor body runs
  PaymentMethoudModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        fees = json['fees'] == null ? 0.0 : (double.tryParse(json['fees'].toString()) ?? 0.0);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['fees'] = fees;
    return data;
  }
}
