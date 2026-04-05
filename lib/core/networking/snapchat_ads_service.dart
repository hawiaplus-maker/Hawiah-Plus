import 'dart:developer';
import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/services.dart';

class SnapchatAdsService {
  static final SnapchatAdsService instance = SnapchatAdsService._();
  SnapchatAdsService._();

  static const MethodChannel _channel = MethodChannel('com.hawiah.plus/snapchat_ads');

  // Standard Snapchat Event Names
  static const String eventAppOpen = "APP_OPEN";
  static const String eventInstall = "INSTALL";
  static const String eventSignUp = "SIGN_UP";
  static const String eventLogin = "LOGIN";
  static const String eventPurchase = "PURCHASE";
  static const String eventPageView = "PAGE_VIEW";
  static const String eventAddToCart = "ADD_CART";
  static const String eventViewContent = "VIEW_CONTENT";

  /// Tracks a specific event to Snapchat.
  /// On iOS, it checks for Tracking Authorization before sending.
  Future<void> trackEvent(String eventName) async {
    try {
      if (Platform.isIOS) {
        final status = await AppTrackingTransparency.trackingAuthorizationStatus;
        if (status != TrackingStatus.authorized) {
          log("SnapchatAdsService: Skipping trace '$eventName' - Tracking not authorized ($status)");
          return;
        }
      }

      await _channel.invokeMethod('trackEvent', {'eventName': eventName});
      log("SnapchatAdsService: Event '$eventName' tracked successfully.");
    } on PlatformException catch (e) {
      log("SnapchatAdsService: Error tracking event '$eventName': ${e.message}");
    }
  }

  // Helper methods for common events
  Future<void> trackAppOpen() => trackEvent(eventAppOpen);
  Future<void> trackInstall() => trackEvent(eventInstall);
  Future<void> trackSignUp() => trackEvent(eventSignUp);
  Future<void> trackLogin() => trackEvent(eventLogin);
  Future<void> trackPurchase() => trackEvent(eventPurchase);
  Future<void> trackPageView() => trackEvent(eventPageView);
}
