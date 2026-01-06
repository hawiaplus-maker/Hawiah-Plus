class UserProfileModel {
  final int id;
  final String name;
  final String username;

  final String mobile;
  final String email;
  final String city;
  final String nationalId;
  final String walletLimit;
  final String image;
  final String type;
  final UserCompany? userCompany;

  UserProfileModel({
    required this.id,
    required this.name,
    required this.username,
    required this.mobile,
    required this.email,
    required this.city,
    required this.nationalId,
    required this.walletLimit,
    required this.image,
    required this.type,
    this.userCompany,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    final data = json['message'];
    return UserProfileModel(
      id: data['id'],
      name: data['name'] ?? '',
      username: data['username'] ?? '',
      mobile: data['mobile'] ?? '',
      email: data['email'] ?? '',
      city: data['city'] ?? '',
      nationalId: data['national_id'] ?? '',
      walletLimit: data['wallet_limit'] ?? '',
      image: data['image'] ?? '',
      type: data['type'] ?? '',
      userCompany: data['user_company'] != null ? UserCompany.fromJson(data['user_company']) : null,
    );
  }

  UserProfileModel copyWithField(String field, String value) {
    switch (field) {
      case 'name':
        return _copy(name: value);
      case 'username':
        return _copy(username: value);
      case 'mobile':
        return _copy(mobile: value);
      case 'email':
        return _copy(email: value);
      default:
        return this;
    }
  }

  UserProfileModel _copy({
    String? name,
    String? username,
    String? mobile,
    String? email,
  }) {
    return UserProfileModel(
      id: id,
      name: name ?? this.name,
      username: username ?? this.username,
      mobile: mobile ?? this.mobile,
      email: email ?? this.email,
      city: city,
      nationalId: nationalId,
      walletLimit: walletLimit,
      image: image,
      type: type,
      userCompany: userCompany,
    );
  }
}

class UserCompany {
  final String commercialRecord;
  final String taxNumber;
  final String taxNumberFile;

  UserCompany({
    required this.commercialRecord,
    required this.taxNumber,
    required this.taxNumberFile,
  });

  factory UserCompany.fromJson(Map<String, dynamic> json) {
    return UserCompany(
      commercialRecord: json['commercial_record'] ?? '',
      taxNumber: json['tax_number'] ?? '',
      taxNumberFile: json['tax_number_file'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'commercial_record': commercialRecord,
      'tax_number': taxNumber,
      'tax_number_file': taxNumberFile,
    };
  }
}
