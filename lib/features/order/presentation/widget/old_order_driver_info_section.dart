import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/theme/app_text_style.dart';
import 'package:hawiah_client/features/order/presentation/functions/show-feedback-bottom-sheet.dart';
import 'package:hawiah_client/features/order/presentation/model/orders_model.dart';

class OldDriverInfoSection extends StatelessWidget {
  const OldDriverInfoSection({required this.data});
  final Data data;

  @override
  Widget build(BuildContext context) {
    final vehicle = data.vehicles?.isNotEmpty == true ? data.vehicles!.first : null;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (vehicle != null)
                      Text(
                        "${vehicle.plateLetters} ${vehicle.plateNumbers}",
                        style: AppTextStyle.text16_700,
                      ),
                    SizedBox(height: 10.h),
                    if (vehicle != null)
                      Text(
                        "${vehicle.carModel} ${vehicle.carType} ${vehicle.carBrand}",
                        style: AppTextStyle.text14_600.copyWith(color: const Color(0xff545454)),
                      ),
                  ],
                ),
              ),
              Image.asset(
                "assets/images/driver_image.PNG",
                height: 0.2.sh,
                width: 0.35.sw,
              ),
            ],
          ),
          GestureDetector(
            onTap: () => showFeedbackBottomSheet(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/icons/like_icon.png",
                  height: 20,
                  width: 20,
                  color: const Color(0xff1A3C98),
                ),
                SizedBox(width: 8.w),
                Text(
                  AppLocaleKey.delegateEvaluation.tr(),
                  style: AppTextStyle.text16_600.copyWith(color: const Color(0xff1A3C98)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
