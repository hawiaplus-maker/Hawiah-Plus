import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hawiah_client/core/custom_widgets/custom_image/custom_network_image.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/core/theme/app_text_style.dart';
import 'package:hawiah_client/core/utils/date_methods.dart';
import 'package:hawiah_client/features/order/presentation/model/orders_model.dart';

class HawiahDetails extends StatelessWidget {
  const HawiahDetails({super.key, required this.ordersDate});
  final SingleOrderData ordersDate;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                // Vehicle Image
                Flexible(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: CustomNetworkImage(
                      imageUrl: ordersDate.image ?? "",
                      fit: BoxFit.fill,
                      height: 60.h,
                      width: 60.w,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ordersDate.product ?? "",
                      style: AppTextStyle.text16_700,
                    ),
                    SizedBox(height: 5.h),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: AppLocaleKey.orderNumber.tr(),
                            style: AppTextStyle.text14_500.copyWith(
                              color: AppColor.blackColor.withValues(alpha: 0.7),
                            ),
                          ),
                          TextSpan(
                            text: ordersDate.referenceNumber ?? '',
                            style: AppTextStyle.text14_500.copyWith(
                              color: AppColor.blackColor.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      DateMethods.formatToFullData(
                        DateTime.tryParse(ordersDate.createdAt ?? "") ?? DateTime.now(),
                      ),
                      style: AppTextStyle.text14_400.copyWith(
                        color: AppColor.blackColor.withValues(alpha: 0.3),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Card(
            color: AppColor.whiteColor,
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Text(ordersDate.otp.toString(), style: AppTextStyle.text18_700),
            ),
          ),
        ],
      ),
    );
  }
}
