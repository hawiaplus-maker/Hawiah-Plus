import 'dart:async';
import 'dart:developer';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';

class DeepLinkService {
  DeepLinkService._();
  static final DeepLinkService instance = DeepLinkService._();

  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  Future<void> init({required GlobalKey<NavigatorState> navKey}) async {
    _appLinks = AppLinks();

    // Check initial link if app was in cold state (terminated)
    try {
      final Uri? initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        log('Initial deep link found: $initialUri');
        _handleDeepLink(initialUri, navKey);
      }
    } catch (e) {
      log('Failed to get initial deep link: $e');
    }

    // Handle link when app is in warm state (foreground/background)
    _linkSubscription = _appLinks.uriLinkStream.listen(
      (Uri? uri) {
        if (uri != null) {
          log('Deep link received in stream: $uri');
          _handleDeepLink(uri, navKey);
        }
      },
      onError: (err) {
        log('Deep link error: $err');
      },
    );
  }

  void _handleDeepLink(Uri uri, GlobalKey<NavigatorState> navKey) {
    final ctx = navKey.currentContext;
    if (ctx != null) {
      log('Handling deep link in context: ${uri.path}');
      final segments = uri.pathSegments.where((s) => s.isNotEmpty).toList();

      if (segments.isNotEmpty) {
        final firstSegment = segments.first;
        if (firstSegment == 'marketing') {
          log('Deep link logic: User landed on marketing path');
          if (segments.length > 1) {
            final id = segments[1];
            log('Marketing ID: $id');
            // Navigator.pushNamed(ctx, '/marketing_details', arguments: id);
          } else {
            log('General marketing link opened');
          }
        }
      }
    } else {
      log('Context is still null, cannot navigate');
    }
  }

  void dispose() {
    _linkSubscription?.cancel();
  }
}
