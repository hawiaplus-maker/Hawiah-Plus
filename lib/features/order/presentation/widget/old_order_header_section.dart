import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hawiah_client/core/custom_widgets/custom_image/custom_network_image.dart';
import 'package:hawiah_client/core/custom_widgets/global-elevated-button-widget.dart';
import 'package:hawiah_client/core/images/app_images.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/core/theme/app_text_style.dart';
import 'package:hawiah_client/core/utils/date_methods.dart';
import 'package:hawiah_client/features/order/presentation/model/orders_model.dart';

class OldOrderHeaderSection extends StatelessWidget {
  const OldOrderHeaderSection({required this.data});
  final Data data;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            children: [
              Flexible(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: CustomNetworkImage(
                    imageUrl: data.image ?? "",
                    fit: BoxFit.fill,
                    height: 60.h,
                    width: 60.w,
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              OrderInfoTexts(data: data),
            ],
          ),
          SizedBox(height: 10.h),
          GlobalElevatedButton(
            icon: Image.asset(
              AppImages.refreshCw,
              height: 20,
              width: 20,
              color: Colors.white,
            ),
            label: AppLocaleKey.reOrder.tr(),
            onPressed: () {},
            backgroundColor: AppColor.mainAppColor,
            textColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            borderRadius: BorderRadius.circular(12),
            fixedWidth: 0.70,
          ),
        ],
      ),
    );
  }
}

class OrderInfoTexts extends StatelessWidget {
  const OrderInfoTexts({required this.data});
  final Data data;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10.h),
        Text(data.product ?? "", style: AppTextStyle.text16_700),
        SizedBox(height: 5.h),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: AppLocaleKey.orderNumber.tr(),
                style: AppTextStyle.text16_600
                    .copyWith(color: AppColor.blackColor.withValues(alpha: 0.7)),
              ),
              TextSpan(
                text: data.referenceNumber ?? '',
                style: AppTextStyle.text16_500
                    .copyWith(color: AppColor.blackColor.withValues(alpha: 0.7)),
              ),
            ],
          ),
        ),
        SizedBox(height: 5.h),
        Text(
          DateMethods.formatToFullData(
            DateTime.tryParse(data.createdAt ?? "") ?? DateTime.now(),
          ),
          style:
              AppTextStyle.text16_600.copyWith(color: AppColor.blackColor.withValues(alpha: 0.3)),
        ),
      ],
    );
  }
}
