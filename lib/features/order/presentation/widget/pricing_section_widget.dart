import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/features/order/presentation/model/orders_model.dart';
import 'package:hawiah_client/features/order/presentation/widget/custom_list_item.dart';

class PricingSectionWidget extends StatelessWidget {
  const PricingSectionWidget({
    super.key,
    required this.ordersData,
  });

  final SingleOrderData ordersData;

  @override
  Widget build(BuildContext context) {
    final double totalPrice = double.tryParse(
          ordersData.totalPrice?.replaceAll(",", "") ?? "0",
        ) ??
        0;
    final double vat = totalPrice * 0.15;
    final double netTotal = totalPrice + vat;
    return Column(
      children: [
        CustomListItem(
          title: AppLocaleKey.askPrice.tr(),
          subtitle: "${totalPrice} ${AppLocaleKey.sarr.tr()}",
        ),
        SizedBox(height: 20),
        CustomListItem(
          title: AppLocaleKey.valueAdded.tr(),
          subtitle: "${vat.toStringAsFixed(2)} ${AppLocaleKey.sarr.tr()}",
        ),
        SizedBox(height: 10),
        Divider(),
        SizedBox(height: 10),
        CustomListItem(
          title: AppLocaleKey.netTotal.tr(),
          subtitle: "${netTotal.toStringAsFixed(2)} ${AppLocaleKey.sarr.tr()}",
        ),
      ],
    );
  }
}
