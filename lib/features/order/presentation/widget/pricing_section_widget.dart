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

  final SingleOrderData ordersData;

  @override
  Widget build(BuildContext context) {
    final double totalPrice = double.tryParse(
          ordersData.totalPrice?.replaceAll(",", "") ?? "0",
        ) ??
        0;
    final double vat = totalPrice * 0.15;
    final double netTotal = totalPrice + vat;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        color: AppColor.grey100Color.withAlpha(50),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColor.mainAppColor, width: .3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Text(AppLocaleKey.priceDetails.tr(), style: AppTextStyle.text16_700),
          SizedBox(height: 10),
          CustomListItem(
            title: AppLocaleKey.total.tr(),
            subtitle: "${totalPrice.toStringAsFixed(2)} ${AppLocaleKey.sarr.tr()}",
          ),
          SizedBox(height: 10),

          if (ordersData.discountValue != null && ordersData.discountValue != 0) ...[
            CustomListItem(
              title: AppLocaleKey.priceAfterDiscount.tr(),
              subtitle:
                  "${((double.tryParse(ordersData.totalPrice ?? "0") ?? 0) - (double.tryParse(ordersData.discountValue.toString() ?? "0") ?? 0)).toStringAsFixed(2)} ${AppLocaleKey.sarr.tr()}",
            ),
            SizedBox(height: 10),
          ]
          // if (ordersData.paidStatus == 0)
          //   Padding(
          //     padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
          //     child: CustomButton(
          //       onPressed: () {
          //         log("get payment link");
          //         context.read<OrderCubit>().getPaymentLink(
          //             orderId: ordersData.id!,
          //             onSuccess: (url) {
          //               if (url.contains('already exists') == true) {
          //                 CommonMethods.showError(message: url);
          //               } else {
          //                 NavigatorMethods.pushNamed(context, CustomPaymentWebViewScreen.routeName,
          //                     arguments: PaymentArgs(
          //                         url: url,
          //                         onFailed: () {
          //                           CommonMethods.showError(
          //                               message: AppLocaleKey.paymentFailed.tr());
          //                         },
          //                         onSuccess: () {
          //                           CommonMethods.showToast(
          //                               message: AppLocaleKey.paymentSuccess.tr());
          //                         }));
          //               }
          //             });
          //       },
          //       height: 45,
          //       color: AppColor.whiteColor,
          //       borderColor: AppColor.mainAppColor,
          //       text: AppLocaleKey.payNow.tr(),
          //       style: AppTextStyle.buttonStyle.copyWith(
          //         color: AppColor.mainAppColor,
          //         height: -0.5,
          //       ),
          //     ),
          //   )
        ],
      ),
    );
  }
}
