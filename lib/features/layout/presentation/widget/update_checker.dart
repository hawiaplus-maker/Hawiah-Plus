import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:new_version_plus/new_version_plus.dart';

class UpdateChecker {
  static Future<void> checkForUpdate(BuildContext context) async {
    final newVersion = NewVersionPlus(
      androidId: "com.hawiah.plus",
      iOSId: "6756757283",
    );

    final status = await newVersion.getVersionStatus();
    if (status == null) return;
    if (status.canUpdate) {
      _showUpdateDialog(context, status, newVersion);
    }
  }

  static void _showUpdateDialog(
    BuildContext context,
    VersionStatus status,
    NewVersionPlus newVersion,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            title: Text(AppLocaleKey.updateTitle.tr()),
            content: Text(
              AppLocaleKey.updateContent.tr(
                namedArgs: {
                  "store_version": status.storeVersion,
                  "local_version": status.localVersion,
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => SystemNavigator.pop(),
                child: Text(AppLocaleKey.cancel.tr()),
              ),
              ElevatedButton(
                onPressed: () async {
                  const playStoreLink =
                      "https://play.google.com/store/apps/details?id=com.hawiah.plus";
                  const appStoreLink =
                      "https://apps.apple.com/us/app/%D8%AD%D8%A7%D9%88%D9%8A%D8%A9-%D8%A8%D9%84%D8%B3/id6756757283";

                  final link =
                      Theme.of(context).platform == TargetPlatform.iOS ? appStoreLink : playStoreLink;

                  await newVersion.launchAppStore(link);
                },
                child: Text(AppLocaleKey.updateNow.tr()),
              ),
            ],
          ),
        );
      },
    );
  }
}
