import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hawiah_client/core/custom_widgets/custom_image/custom_network_image.dart';
import 'package:hawiah_client/core/images/app_images.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/core/theme/app_text_style.dart';
import 'package:hawiah_client/core/utils/date_methods.dart';
import 'package:hawiah_client/features/order/presentation/model/single_order_model.dart';

class OldOrderHeaderSection extends StatelessWidget {
  const OldOrderHeaderSection({required this.data});
  final SingleOrderModel data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      decoration: BoxDecoration(
        color: AppColor.whiteColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColor.mainAppColor, width: .3),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(AppLocaleKey.orderdata.tr(), style: AppTextStyle.text16_700),
              const Spacer(),
              Container(
                decoration: BoxDecoration(
                  color: gtOrderStatusColor(data.data?.status?.en ?? '').withAlpha(50),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      context.locale.languageCode == 'ar'
                          ? (data.data?.status?.ar ?? '')
                          : (data.data?.status?.en ?? ''),
                      style: AppTextStyle.text16_500.copyWith(
                        color: gtOrderStatusColor(data.data?.status?.en ?? ''),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              // Vehicle Image
              Flexible(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: CustomNetworkImage(
                    imageUrl: data.data?.image ?? "",
                    fit: BoxFit.fill,
                    height: 60.h,
                    width: 60.w,
                  ),
                ),
              ),
              SizedBox(width: 20.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.data?.product ?? "",
                    style: AppTextStyle.text16_700,
                  ),
                  SizedBox(height: 5.h),
                  Row(
                    children: [
                      Image.asset(AppImages.requestName, height: 24.h, width: 24.w),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: AppLocaleKey.orderCode.tr(),
                              style: AppTextStyle.text14_600.copyWith(
                                color: AppColor.blackColor,
                              ),
                            ),
                            TextSpan(
                              text: data.data?.referenceNumber ?? '',
                              style: AppTextStyle.text14_500.copyWith(
                                color: AppColor.greyColor.withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.h),
                  Row(
                    children: [
                      Image.asset(AppImages.requestCode, height: 24.h, width: 24.w),
                      Text(
                        data.data?.serviceProvider ?? '',
                        style: AppTextStyle.text14_500.copyWith(
                          color: AppColor.greyColor.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.h),
                  Row(
                    children: [
                      Text(
                        AppLocaleKey.confirmNumber.tr(),
                        style: AppTextStyle.text14_500,
                      ),
                      Gap(5.w),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        decoration: BoxDecoration(
                          color: Color(0xffF3E8FF),
                          borderRadius: BorderRadius.circular(11),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(data.data?.otp.toString() ?? '',
                                style: AppTextStyle.text12_400.copyWith(color: Color(0xff6E11B0))),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color gtOrderStatusColor(String status) {
    switch (status) {
      case "Delivered":
        return AppColor.mainAppColor;
      case "Processing":
        return AppColor.statusOrangeColor;
      case "New order":
        return AppColor.statusBlueColor;
      case "Out for delivery":
        return AppColor.redColor;
      case "Finish Order":
        return AppColor.mainAppColor;
      default:
        return AppColor.textGrayColor;
    }
  }
}

class OrderInfoTexts extends StatelessWidget {
  const OrderInfoTexts({required this.data});
  final SingleOrderModel data;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10.h),
        Text(data.data?.product ?? "", style: AppTextStyle.text16_700),
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
                text: data.data?.referenceNumber ?? '',
                style: AppTextStyle.text16_500
                    .copyWith(color: AppColor.blackColor.withValues(alpha: 0.7)),
              ),
            ],
          ),
        ),
        SizedBox(height: 5.h),
        Text(
          DateMethods.formatToFullData(
            DateTime.tryParse(data.data?.createdAt ?? "") ?? DateTime.now(),
          ),
          style:
              AppTextStyle.text16_600.copyWith(color: AppColor.blackColor.withValues(alpha: 0.3)),
        ),
      ],
    );
  }
}
