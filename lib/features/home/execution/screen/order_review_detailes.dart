import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hawiah_client/core/custom_widgets/custom_app_bar.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/core/theme/app_text_style.dart';
import 'package:hawiah_client/features/home/execution/widget/coupone_widget.dart';
import 'package:hawiah_client/features/home/execution/widget/order_detailes_widget.dart';
import 'package:hawiah_client/features/home/execution/widget/order_details_pricing_section.dart';
import 'package:hawiah_client/features/order/presentation/model/order_details_model.dart';

class OrderReviewDetailes extends StatelessWidget {
  const OrderReviewDetailes({super.key, required this.ordersModel});
  static const String routeName = 'OrderReviewDetailes';
  final OrderDetailsModel ordersModel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(context, titleText: AppLocaleKey.orderSummary.tr()),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: [
            OrderDetailesWidget(ordersModel: ordersModel),
            SizedBox(
              height: 15,
            ),
            OrderDetailsPricingSection(ordersModel: ordersModel),
            SizedBox(
              height: 15,
            ),
            CouponeWidget(),
            SizedBox(
              height: 15,
            ),
            SizedBox(
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
                        args: [ordersModel.totalPrice.toString()],
                      ),
                      style: AppTextStyle.text18_700.copyWith(color: AppColor.whiteColor),
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
