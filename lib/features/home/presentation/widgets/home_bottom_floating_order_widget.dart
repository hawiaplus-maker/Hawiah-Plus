import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hawiah_client/core/images/app_images.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/core/theme/app_text_style.dart';

class HomeBottomFloatingOrderCardWidget extends StatelessWidget {
  const HomeBottomFloatingOrderCardWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 110),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: Color(0xffE5E7FE),
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.symmetric(horizontal: 20.w),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: SvgPicture.asset(AppImages.locationsIcon),
          title: Text(
            AppLocaleKey.youhaveorder.tr(),
            style: AppTextStyle.text16_700,
          ),
          subtitle: Text(
            "  ${AppLocaleKey.orderNumber.tr()} 1234",
            style: AppTextStyle.text16_500.copyWith(color: AppColor.greyColor),
          ),
          trailing: Card(
            color: AppColor.whiteColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              child: Text("1234".tr(), style: AppTextStyle.text16_700, textAlign: TextAlign.center),
            ),
          ),
        ),
      ),
    );
  }
}
