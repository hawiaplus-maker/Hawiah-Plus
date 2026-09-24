import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateChecker {
  static Future<void> checkForUpdate(BuildContext context) async {
    final newVersion = NewVersionPlus(
      androidId: 'com.hawiah.plus',
      iOSId: '6756757283',
    );

    try {
      final status = await newVersion.getVersionStatus();

      if (status == null) {
        return;
      }

      debugPrint('Local version: ${status.localVersion}');
      debugPrint('Store version: ${status.storeVersion}');
      debugPrint('Can update: ${status.canUpdate}');

      if (!status.canUpdate) {
        return;
      }

      if (!context.mounted) {
        return;
      }

      _showUpdateDialog(
        context,
        status,
      );
    } catch (e, stackTrace) {
      debugPrint('Update check error: $e');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  static void _showUpdateDialog(
    BuildContext context,
    dynamic status,
  ) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            title: Text(
              AppLocaleKey.updateTitle.tr(),
            ),
            content: Text(
              AppLocaleKey.updateContent.tr(
                namedArgs: {
                  'store_version': status.storeVersion.toString(),
                  'local_version': status.localVersion.toString(),
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  SystemNavigator.pop();
                },
                child: Text(
                  AppLocaleKey.cancel.tr(),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  final platform = Theme.of(dialogContext).platform;

                  final Uri url;

                  if (platform == TargetPlatform.iOS) {
                    url = Uri.parse(
                      'https://apps.apple.com/us/app/%D8%AD%D8%A7%D9%88%D9%8A%D8%A9-%D8%A8%D9%84%D8%B3/id6756757283',
                    );
                  } else {
                    url = Uri.parse(
                      'https://play.google.com/store/apps/details?id=com.hawiah.plus',
                    );
                  }

                  debugPrint('===== UPDATE BUTTON =====');
                  debugPrint('Store URL: $url');

                  try {
                    final launched = await launchUrl(
                      url,
                      mode: LaunchMode.externalApplication,
                    );

                    debugPrint('Launched: $launched');

                    if (!launched) {
                      debugPrint(
                        'Could not launch store URL: $url',
                      );
                    }
                  } catch (e, stackTrace) {
                    debugPrint('Store launch error: $e');
                    debugPrintStack(
                      stackTrace: stackTrace,
                    );
                  }
                },
                child: Text(
                  AppLocaleKey.updateNow.tr(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
