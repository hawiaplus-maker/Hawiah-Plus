import 'package:hawiah_client/core/hive/hive_methods.dart';

class ContainerTypesModel {
  final bool success;
  final List<ContainerFlowModel> types;

  const ContainerTypesModel({required this.success, required this.types});

  factory ContainerTypesModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    final rawTypes = data is Map ? data['types'] : json['types'];

    return ContainerTypesModel(
      success: json['success'] == true,
      types: rawTypes is List
          ? rawTypes
              .whereType<Map>()
              .map((item) => ContainerFlowModel.fromJson(
                    Map<String, dynamic>.from(item),
                  ))
              .toList()
          : const [],
    );
  }
}

class ContainerFlowModel {
  final String type;
  final String name;
  final List<ContainerItemModel> containers;

  const ContainerFlowModel({
    required this.type,
    required this.name,
    required this.containers,
  });

  factory ContainerFlowModel.fromJson(Map<String, dynamic> json) {
    final rawContainers = json['containers'];
    return ContainerFlowModel(
      type: _text(json['type']),
      name: _text(json['name']),
      containers: rawContainers is List
          ? rawContainers
              .whereType<Map>()
              .map((item) => ContainerItemModel.fromJson(
                    Map<String, dynamic>.from(item),
                  ))
              .toList()
          : const [],
    );
  }

  bool get isCleaning => type.toLowerCase().contains('clean');
}

class ContainerItemModel {
  final int id;
  final String title;
  final String description;
  final String size;
  final String sizeUnit;
  final String measurements;
  final String image;
  final String price;

  const ContainerItemModel({
    required this.id,
    required this.title,
    required this.description,
    required this.size,
    required this.sizeUnit,
    required this.measurements,
    required this.image,
    required this.price,
  });

  factory ContainerItemModel.fromJson(Map<String, dynamic> json) =>
      ContainerItemModel(
        id: int.tryParse('${json['id'] ?? 0}') ?? 0,
        title: _text(json['title'] ?? json['name']),
        description: _text(json['description']),
        size: _text(json['size']),
        sizeUnit: _text(json['size_unit']),
        measurements: _text(json['measurements']),
        image: _text(json['image']),
        price: _text(json['price']),
      );
}

String _text(dynamic value) {
  if (value == null) return '';
  if (value is Map) {
    final language = HiveMethods.getLang();
    return _text(value[language] ?? value['en'] ?? value['ar'] ?? '');
  }
  return value.toString();
}
