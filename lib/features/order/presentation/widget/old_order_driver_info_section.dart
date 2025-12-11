import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hawiah_client/core/images/app_images.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/core/theme/app_text_style.dart';
import 'package:hawiah_client/core/utils/url_luncher_methods.dart';
import 'package:hawiah_client/features/order/presentation/model/single_order_model.dart';

class OldDriverInfoSection extends StatelessWidget {
  const OldDriverInfoSection({required this.data});
  final SingleOrderModel data;

  @override
  Widget build(BuildContext context) {
    final vehicle = data.data?.vehicles?.isNotEmpty == true ? data.data?.vehicles!.first : null;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
      decoration: BoxDecoration(
        color: Color(0x1A4FD956),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${AppLocaleKey.technicalsupport.tr()}: ', style: AppTextStyle.text16_700),
          SizedBox(height: 20.h),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Expanded(
              child: GestureDetector(
                onTap: () => UrlLauncherMethods.launchURL(data.data?.support),
                child: Container(
                  height: 45.h,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColor.mainAppColor, width: 1.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(AppImages.phoneSupport, height: 20.h, width: 20.w),
                      Gap(5.w),
                      Text(AppLocaleKey.connectede.tr(),
                          style: AppTextStyle.text16_600.copyWith(color: AppColor.mainAppColor)),
                    ],
                  ),
                ),
              ),
            ),
            Gap(10.w),
            Expanded(
              child: GestureDetector(
                onTap: () => UrlLauncherMethods.launchURL(data.data?.support, isWhatsapp: true),
                child: Container(
                  height: 45.h,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColor.mainAppColor, width: 1.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(AppImages.whatsappSupport, height: 20.h, width: 20.w),
                      Gap(5.w),
                      Text(AppLocaleKey.whatsab.tr(),
                          style: AppTextStyle.text16_600.copyWith(color: AppColor.mainAppColor)),
                    ],
                  ),
                ),
              ),
            ),
          ])
        ],
      ),
    );
  }
}
