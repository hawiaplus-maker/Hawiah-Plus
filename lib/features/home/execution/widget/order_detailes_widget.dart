import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hawiah_client/core/custom_widgets/custom_image/custom_network_image.dart';
import 'package:hawiah_client/core/images/app_images.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/core/theme/app_text_style.dart';
import 'package:hawiah_client/features/order/presentation/model/order_details_model.dart';

class OrderDetailesWidget extends StatelessWidget {
  const OrderDetailesWidget({super.key, required this.ordersModel});
  final OrderDetailsModel ordersModel;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColor.lightGreyColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocaleKey.orderDetails.tr(),
            style: AppTextStyle.text16_700,
          ),
          SizedBox(height: 10),
          Center(
            child: CustomNetworkImage(
              imageUrl: ordersModel.image ?? '',
              height: 120.h,
              width: MediaQuery.of(context).size.width * 0.6,
            ),
          ),
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: Image.asset(AppImages.boxMainImage),
            title: Text(AppLocaleKey.hawiahType.tr(), style: AppTextStyle.text16_700),
            subtitle: Text(
              ordersModel.product ?? '',
              style: AppTextStyle.text16_500.copyWith(color: AppColor.textGrayColor),
            ),
          ),
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: Image.asset(AppImages.contactMainImage),
            title: Text(AppLocaleKey.serviceProvider.tr(), style: AppTextStyle.text16_700),
            subtitle: Text(
              ordersModel.serviceProvider ?? '',
              style: AppTextStyle.text16_500.copyWith(color: AppColor.textGrayColor),
            ),
          ),
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: Image.asset(AppImages.locationMainImage),
            title: Text(AppLocaleKey.theAddress.tr(), style: AppTextStyle.text16_700),
            subtitle: Text(
              ordersModel.address ?? '',
              style: AppTextStyle.text16_500.copyWith(color: AppColor.textGrayColor),
            ),
          ),
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: Image.asset(AppImages.calednderMainImage),
            title: Text(AppLocaleKey.rentalPeriority.tr(), style: AppTextStyle.text16_700),
            subtitle: Text(
              " ${AppLocaleKey.fromxToY.tr(
                args: [ordersModel.fromDate ?? '', ordersModel.toDate ?? ''],
              )}\t ( ${AppLocaleKey.days.tr(
                args: [ordersModel.duration.toString()],
              )})",
              style: AppTextStyle.text16_500.copyWith(color: AppColor.textGrayColor),
            ),
          ),
        ],
      ),
    );
  }
}
