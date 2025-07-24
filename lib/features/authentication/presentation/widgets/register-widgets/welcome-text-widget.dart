import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hawiah_client/core/theme/app_text_style.dart';

class WelcomeTextWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      // margin: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "welcome".tr(),
            style: AppTextStyle.text24_700,
          ),
          const SizedBox(height: 5),
          Text(
            "welcome_back".tr(),
            style: AppTextStyle.text16_400,
          ),
        ],
      ),
    );
  }
}
