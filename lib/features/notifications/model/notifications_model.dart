import 'dart:convert';

NotificationsModel notificationsModelFromJson(String str) =>
    NotificationsModel.fromJson(json.decode(str));

String notificationsModelToJson(NotificationsModel data) => json.encode(data.toJson());

class NotificationsModel {
  bool success;
  List<Datum> notifications;

  NotificationsModel({
    required this.success,
    required this.notifications,
  });

  factory NotificationsModel.fromJson(Map<String, dynamic> json) => NotificationsModel(
        success: json["success"] ?? false,
        notifications: json["message"] != null
            ? List<Datum>.from(json["message"].map((x) => Datum.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": List<dynamic>.from(notifications.map((x) => x.toJson())),
      };
}

class Datum {
  int id;
  Message title;
  Message message;
  String? notifiableType;
  int? notifiableId;
  String? modelType;
  int? modelId;
  int seen;
  int seenByAdmin;
  int userId;
  Data? data;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? showClient;
  int? showCompany;
  int? showPuncher;
  int? showEmployee;

  Datum({
    required this.id,
    required this.title,
    required this.message,
    required this.notifiableType,
    required this.notifiableId,
    required this.modelType,
    required this.modelId,
    required this.seen,
    required this.seenByAdmin,
    required this.userId,
    this.data,
    this.createdAt,
    this.updatedAt,
    this.showClient,
    this.showCompany,
    this.showPuncher,
    this.showEmployee,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        title: Message.fromJson(json["title"] ?? {}),
        message: Message.fromJson(json["message"] ?? {}),
        notifiableType: json["notifiable_type"],
        notifiableId: json["notifiable_id"],
        modelType: json["model_type"],
        modelId: json["model_id"],
        seen: json["seen"] ?? 0,
        seenByAdmin: json["seen_by_admin"] ?? 0,
        userId: json["user_id"] ?? 0,
        data: json["data"] != null && json["data"] != ""
            ? Data.fromJson(jsonDecode(json["data"]))
            : null,
        createdAt: json["created_at"] != null ? DateTime.parse(json["created_at"]) : null,
        updatedAt: json["updated_at"] != null ? DateTime.parse(json["updated_at"]) : null,
        showClient: json["show_client"],
        showCompany: json["show_company"],
        showPuncher: json["show_puncher"],
        showEmployee: json["show_employee"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title.toJson(),
        "message": message.toJson(),
        "notifiable_type": notifiableType,
        "notifiable_id": notifiableId,
        "model_type": modelType,
        "model_id": modelId,
        "seen": seen,
        "seen_by_admin": seenByAdmin,
        "user_id": userId,
        "data": data != null ? jsonEncode(data!.toJson()) : null,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "show_client": showClient,
        "show_company": showCompany,
        "show_puncher": showPuncher,
        "show_employee": showEmployee,
      };
}

class Data {
  String? type;

  Data({this.type});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
      };
}

class Message {
  String en;
  String ar;

  Message({
    required this.en,
    required this.ar,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        en: json["en"] ?? "",
        ar: json["ar"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "en": en,
        "ar": ar,
      };
}
