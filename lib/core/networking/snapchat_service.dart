import 'dart:convert';
import 'dart:developer';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class SnapchatService {
  static final SnapchatService instance = SnapchatService._();
  SnapchatService._();

  static const String _pixelId = "0d1ccbc7-2ff0-4fd3-8a62-9937245ccf81";
  static const String _endpoint = "https://tr.snapchat.com/v2/conversion";

  // TODO: Marketing team needs to provide this static long-lived token
  static const String _accessToken = "REPLACE_WITH_YOUR_SNAPCHAT_ACCESS_TOKEN";

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
