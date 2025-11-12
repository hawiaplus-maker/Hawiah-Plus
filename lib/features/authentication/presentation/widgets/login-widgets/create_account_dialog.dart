import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hawiah_client/core/custom_widgets/custom_button.dart';
import 'package:hawiah_client/core/images/app_images.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/core/theme/app_text_style.dart';

class CreateAccountDialog extends StatelessWidget {
  const CreateAccountDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColor.whiteColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 5,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                  padding: const EdgeInsets.all(10),
                  onPressed: () => Navigator.pop(context),
                  icon: SvgPicture.asset(AppImages.closeCircleIcon)),
            ],
          ),
          Image.asset(
            AppImages.signInIcon,
            height: 90,
          ),
          Text(AppLocaleKey.loginNow.tr(), style: AppTextStyle.text16_700),
          Text(AppLocaleKey.toBrowseServicesRegisterNow.tr(), style: AppTextStyle.textG16_500),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 5),
            child: CustomButton(
              height: 40,
              text: "login".tr(),
              style: AppTextStyle.buttonStyle.copyWith(color: AppColor.whiteColor, fontSize: 16),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 5),
            child: CustomButton(
              color: AppColor.secondAppColor,
              height: 40,
              text: AppLocaleKey.cancel.tr(),
              style: AppTextStyle.buttonStyle.copyWith(color: AppColor.whiteColor, fontSize: 16),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
