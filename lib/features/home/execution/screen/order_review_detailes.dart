import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hawiah_client/core/custom_widgets/custom_app_bar.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/core/theme/app_text_style.dart';
import 'package:hawiah_client/core/utils/common_methods.dart';
import 'package:hawiah_client/core/utils/navigator_methods.dart';
import 'package:hawiah_client/features/home/execution/widget/coupone_widget.dart';
import 'package:hawiah_client/features/home/execution/widget/order_detailes_widget.dart';
import 'package:hawiah_client/features/home/execution/widget/order_details_pricing_section.dart';
import 'package:hawiah_client/features/order/presentation/model/order_details_model.dart';
import 'package:hawiah_client/features/order/presentation/order-cubit/order-cubit.dart';
import 'package:hawiah_client/features/order/presentation/screens/payment_web_view.dart';

class OrderReviewDetailes extends StatefulWidget {
  const OrderReviewDetailes({super.key, required this.ordersModel});
  static const String routeName = 'OrderReviewDetailes';
  final OrderDetailsModel ordersModel;

  @override
  State<OrderReviewDetailes> createState() => _OrderReviewDetailesState();
}

class _OrderReviewDetailesState extends State<OrderReviewDetailes> {
  String? discountValue;
  int? discount;
  String? priceAfterDiscount;
  String? copone;
  bool isPaymentSuccess = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(context, titleText: AppLocaleKey.orderSummary.tr()),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: [
            OrderDetailesWidget(ordersModel: widget.ordersModel),
            SizedBox(
              height: 15,
            ),
            OrderDetailsPricingSection(
              ordersModel: widget.ordersModel,
              discount: discount,
              discountValue: discountValue,
              priceAfterDiscount: priceAfterDiscount,
              copone: copone,
            ),
            SizedBox(
              height: 15,
            ),
            if (isPaymentSuccess == false)
              CouponeWidget(
                orderId: widget.ordersModel.id ?? 0,
                onCouponeAppLayed: (discountValue, discount, priceAfterDiscount, copone) {
                  setState(() {
                    this.discountValue = discountValue;
                    this.discount = discount;
                    this.priceAfterDiscount = priceAfterDiscount;
                    this.copone = copone;
                  });
                },
              ),
            SizedBox(
              height: 15,
            ),
            if (isPaymentSuccess == false)
              GestureDetector(
                onTap: () {
                  log("get payment link");
                  context.read<OrderCubit>().getPaymentLink(
                      orderId: widget.ordersModel.id!,
                      onSuccess: (url) {
                        if (url.contains('already exists') == true) {
                          CommonMethods.showError(message: url);
                        } else {
                          NavigatorMethods.pushNamed(context, CustomPaymentWebViewScreen.routeName,
                              arguments: PaymentArgs(
                                  url: url,
                                  onFailed: () {
                                    CommonMethods.showError(
                                        message: AppLocaleKey.paymentFailed.tr());
                                  },
                                  onSuccess: () {
                                    setState(() {
                                      isPaymentSuccess = true;
                                    });
                                    CommonMethods.showToast(
                                        message: AppLocaleKey.paymentSuccess.tr());
                                  }));
                        }
                      });
                },
                child: SizedBox(
                  width: double.infinity,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: AppColor.mainAppColor,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          AppLocaleKey.payXSar.tr(
                            args: [
                              discountValue != null
                                  ? priceAfterDiscount ?? ""
                                  : widget.ordersModel.totalPrice ?? ""
                            ],
                          ),
                          style: AppTextStyle.text18_700.copyWith(color: AppColor.whiteColor),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            SizedBox(
              height: 15,
            ),
            SizedBox(
              width: double.infinity,
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: AppColor.redColor.withAlpha(20),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      AppLocaleKey.allTransactionsSecureAndEncrypted.tr(),
                      style: AppTextStyle.text16_600.copyWith(color: AppColor.redColor),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
          ]),
        ),
      ),
    );
  }
}
