import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hawiah_client/core/custom_widgets/custom_button.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/core/utils/navigator_methods.dart';
import 'package:hawiah_client/features/order/presentation/model/orders_model.dart';
import 'package:hawiah_client/features/order/presentation/screens/payment_methods_screen.dart';

class PaymentButtonWidget extends StatelessWidget {
  const PaymentButtonWidget({
    super.key,
    required this.ordersData,
  });

  final SingleOrderData ordersData;

  @override
  Widget build(BuildContext context) {
    return ordersData.paidStatus == 0
        ? CustomButton(
            color: AppColor.greenColor,
            text: AppLocaleKey.payNow.tr(),
            onPressed: () {
              NavigatorMethods.pushNamed(context, PaymentMethodsScreen.routeName,
                  arguments: PaymentMethodsArgs(
                      orderId: ordersData.id!, totalPrice: ordersData.totalPrice ?? ""));
            },
          )
        : SizedBox();
  }
}
