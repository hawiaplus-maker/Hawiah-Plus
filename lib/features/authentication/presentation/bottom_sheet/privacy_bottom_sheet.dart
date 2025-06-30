import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:hawiah_client/core/custom_widgets/app_bottom_sheet.dart';

class PrivacyBottomSheet extends StatelessWidget {
  const PrivacyBottomSheet({super.key, required this.privacy});
  final String privacy;
  @override
  Widget build(BuildContext context) {
    return AppBottomSheet(
      title:"privacy_policy_text".tr(),
      children: [
        HtmlWidget(privacy),
      ],
    );
  }
}
