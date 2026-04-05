import 'dart:convert';
import 'dart:developer';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class SnapchatService {
  static final SnapchatService instance = SnapchatService._();
  SnapchatService._();

  static const String _pixelId = "2227c0a3-a147-480e-8359-638db9004c06";
  static const String _endpoint = "https://tr.snapchat.com/v2/conversion";

  static const String _accessToken = "eyJhbGciOiJIUzI1NiIsImtpZCI6IkNhbnZhc1MyU0hNQUNQcm9kIiwidHlwIjoiSldUIn0.eyJhdWQiOiJjYW52YXMtY2FudmFzYXBpIiwiaXNzIjoiY2FudmFzLXMyc3Rva2VuIiwibmJmIjoxNzc1Mzk4OTU0LCJzdWIiOiJmMjcyOGU0MC04MTVjLTQ3OGQtOWY0NC03MDg5MWIxYjU2N2Z-UFJPRFVDVElPTn5lNmExNTgwYi1kZDZlLTRhNzAtYjM5MC03NGFiMjhiN2VmYWEifQ.srmzDS-K1McyAhPHO0Ex9L1XPxoEEw6mXjr0afQ6TaI";

  final Dio _dio = Dio();

  String _hash(String? data) {
    if (data == null || data.isEmpty) return "";
    final bytes = utf8.encode(data.trim().toLowerCase());
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<void> trackEvent(String eventType,
      {String? email, String? phoneNumber, Map<String, dynamic>? customData}) async {
    try {
      final body = {
        "pixel_id": _pixelId,
        "event_type": eventType,
        "timestamp": DateTime.now().millisecondsSinceEpoch,
        if (email != null && email.isNotEmpty) "hashed_email": _hash(email),
        if (phoneNumber != null && phoneNumber.isNotEmpty) "hashed_phone": _hash(phoneNumber),
        if (customData != null) ...customData,
      };

      if (kDebugMode) {
        log("Snapchat Event: $eventType Body: $body");
      }

      final response = await _dio.post(
        _endpoint,
        data: body,
        options: Options(
          headers: {
            "Authorization": "Bearer $_accessToken",
            "Content-Type": "application/json",
          },
          validateStatus: (status) => true,
        ),
      );

      if (kDebugMode) {
        log("Snapchat Event $eventType Response: ${response.statusCode} - ${response.data}");
      }
    } catch (e) {
      if (kDebugMode) {
        log("Snapchat Event Error: $e");
      }
    }
  }

  void trackPageView() => trackEvent("PAGE_VIEW");

  void trackSignUp({String? email, String? phoneNumber}) =>
      trackEvent("SIGN_UP", email: email, phoneNumber: phoneNumber);

  void trackLogin({String? email, String? phoneNumber}) =>
      trackEvent("LOGIN", email: email, phoneNumber: phoneNumber);

  void trackPurchase({double? price, String? currency, String? email, String? phoneNumber}) =>
      trackEvent("PURCHASE", email: email, phoneNumber: phoneNumber, customData: {
        if (price != null) "price": price,
        if (currency != null) "currency": currency,
      });
}
