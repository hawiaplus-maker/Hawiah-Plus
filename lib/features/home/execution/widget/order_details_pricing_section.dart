import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/core/theme/app_text_style.dart';
import 'package:hawiah_client/features/order/presentation/model/order_details_model.dart';

class OrderDetailsPricingSection extends StatelessWidget {
  const OrderDetailsPricingSection({super.key, required this.ordersModel});
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
          Text(AppLocaleKey.paymentDetails.tr(), style: AppTextStyle.text16_700),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppLocaleKey.mainPrice.tr(), style: AppTextStyle.text16_400),
              Text(AppLocaleKey.sar.tr(args: [ordersModel.totalPrice.toString()]),
                  style: AppTextStyle.text16_400),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppLocaleKey.tax.tr(args: [15.toString()]), style: AppTextStyle.text16_400),
              Text(AppLocaleKey.sar.tr(args: [ordersModel.totalPrice.toString()]),
                  style: AppTextStyle.text16_400),
            ],
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppLocaleKey.totalPrice.tr(), style: AppTextStyle.text16_400),
              Text(AppLocaleKey.sar.tr(args: [ordersModel.totalPrice.toString()]),
                  style: AppTextStyle.text16_400.copyWith(color: AppColor.mainAppColor)),
            ],
          ),
        ],
      ),
    );
  }
}
