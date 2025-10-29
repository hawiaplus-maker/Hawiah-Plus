import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hawiah_client/core/custom_widgets/custom_button.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/core/utils/common_methods.dart';
import 'package:hawiah_client/core/utils/navigator_methods.dart';
import 'package:hawiah_client/features/order/presentation/model/orders_model.dart';
import 'package:hawiah_client/features/order/presentation/order-cubit/order-cubit.dart';
import 'package:hawiah_client/features/order/presentation/screens/payment_web_view.dart';

class PaymentButtonWidget extends StatelessWidget {
  const PaymentButtonWidget({
    super.key,
    required this.ordersData,
  });

  final Data ordersData;

  @override
  Widget build(BuildContext context) {
    return ordersData.paidStatus == 0
        ? CustomButton(
            color: AppColor.greenColor,
            text: AppLocaleKey.payNow.tr(),
            onPressed: () {
              context.read<OrderCubit>().getPaymentLink(
                  orderId: ordersData.id!,
                  onSuccess: (url) {
                    if (url.contains('already exists') == true) {
                      CommonMethods.showError(message: url);
                    } else {
                      NavigatorMethods.pushNamed(context, CustomPaymentWebViewScreen.routeName,
                          arguments: PaymentArgs(
                              url: url,
                              onFailed: () {
                                Fluttertoast.showToast(msg: AppLocaleKey.paymentFailed.tr());
                              },
                              onSuccess: () {
                                Fluttertoast.showToast(msg: AppLocaleKey.paymentSuccess.tr());
                              }));
                    }
                  });
            },
          )
        : SizedBox();
  }
}
