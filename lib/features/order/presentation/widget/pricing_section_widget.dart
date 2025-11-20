import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/core/theme/app_text_style.dart';
import 'package:hawiah_client/features/order/presentation/model/orders_model.dart';
import 'package:hawiah_client/features/order/presentation/widget/custom_list_item.dart';

class PricingSectionWidget extends StatelessWidget {
  const PricingSectionWidget({
    super.key,
    required this.ordersData,
  });

  final Data ordersData;

  @override
  Widget build(BuildContext context) {
    final double totalPrice = double.tryParse(
          ordersData.totalPrice?.replaceAll(",", "") ?? "0",
        ) ??
        0;
    final double vat = totalPrice * 0.15;
    final double netTotal = totalPrice + vat;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
      decoration: BoxDecoration(
        color: AppColor.grey100Color.withAlpha(50),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColor.mainAppColor, width: .3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppLocaleKey.priceDetails.tr(), style: AppTextStyle.text16_700),
          SizedBox(height: 10),
          CustomListItem(
            title: AppLocaleKey.total.tr(),
            subtitle: "${totalPrice.toStringAsFixed(2)} ${AppLocaleKey.sarr.tr()}",
          ),
        ],
      ),
    );
  }
}
