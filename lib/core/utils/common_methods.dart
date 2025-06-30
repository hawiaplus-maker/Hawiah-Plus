import 'dart:async';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class CommonMethods {
   static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static Future<bool> hasConnection() async {
    // Check for an active internet connection
    bool result = await InternetConnection().hasInternetAccess;

    if (!result) {
      // Subscribe to changes and wait for a reconnection
      final completer = Completer<bool>();
      final subscription = InternetConnection().onStatusChange.listen((status) {
        if (status == InternetStatus.connected) {
          completer.complete(true); // Internet is now connected
        }
      });

      // Add a timeout to prevent indefinite waiting
      Future.delayed(const Duration(seconds: 5), () {
        if (!completer.isCompleted) {
          completer.complete(false); // No internet after timeout
        }
        subscription.cancel(); // Clean up the listener
      });

      // Return the result after either timeout or reconnection
      result = await completer.future;
    }

    return result;
  }
}
