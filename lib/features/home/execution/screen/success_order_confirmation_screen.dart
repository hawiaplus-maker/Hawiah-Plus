import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hawiah_client/core/custom_widgets/custom_app_bar.dart';
import 'package:hawiah_client/core/custom_widgets/custom_button.dart';
import 'package:hawiah_client/core/images/app_images.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/core/theme/app_text_style.dart';
import 'package:hawiah_client/core/utils/navigator_methods.dart';
import 'package:hawiah_client/features/layout/presentation/layout_methouds.dart';
import 'package:hawiah_client/features/layout/presentation/screens/layout-screen.dart';

class SuccessOrderConfirmationScreen extends StatelessWidget {
  static const String routeName = 'SuccessOrderConfirmation';
  const SuccessOrderConfirmationScreen({
    super.key,
    // required this.ordersModel
  });
  //final OrderDetailsModel ordersModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context,
        titleText: AppLocaleKey.confirmOrder.tr(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Center(
                child: Image.asset(
                  AppImages.successCheckImage,
                  height: 80,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                AppLocaleKey.orderConfirmedSuccessfully.tr(),
                style: AppTextStyle.text18_700,
              ),
              // SizedBox(
              //   height: 10,
              // ),
              // Text(
              //   AppLocaleKey.ordernumber.tr(args: [ordersModel.referenceNumber.toString()]),
              //   style: AppTextStyle.text18_400.copyWith(color: AppColor.greyTextColor),
              // ),
              SizedBox(
                height: 40,
              ),
              //  SuccessConfirmationInvoiceAndContractWidget(ordersModel: ordersModel),
              SizedBox(
                height: 40,
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColor.redColor.withAlpha(20),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColor.redColor.withAlpha(80)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocaleKey.nextSteps.tr(),
                        style: AppTextStyle.text16_500.copyWith(color: AppColor.redColor),
                      ),
                      SizedBox(height: 10), // Add a 20-space gap
                      Text(
                        '*\t\t ${AppLocaleKey.youWillReceiveNotification.tr()}', // Add a period after the text
                        style: AppTextStyle.text16_400.copyWith(color: AppColor.redColor),
                      ),
                      SizedBox(height: 10), // Add a 20-space gap
                      Text(
                        '*\t\t ${AppLocaleKey.youWillReceiveNotificationDescription.tr()}', // Add a period after the text
                        style: AppTextStyle.text16_400.copyWith(color: AppColor.redColor),
                      ),
                      SizedBox(height: 10), // Add a 20-space gap
                      Text(
                        '*\t\t ${AppLocaleKey.youWillReceiveNotificationDescription2.tr()}', // Add a period after the text
                        style: AppTextStyle.text16_400.copyWith(color: AppColor.redColor),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              // CustomButton(
              //   onPressed: () {
              //     log("get payment link");
              //     context.read<OrderCubit>().getPaymentLink(
              //         orderId: ordersModel.id!,
              //         onSuccess: (url) {
              //           if (url.contains('already exists') == true) {
              //             CommonMethods.showError(message: url);
              //           } else {
              //             NavigatorMethods.pushNamed(context, CustomPaymentWebViewScreen.routeName,
              //                 arguments: PaymentArgs(
              //                     url: url,
              //                     onFailed: () {
              //                       CommonMethods.showError(
              //                           message: AppLocaleKey.paymentFailed.tr());
              //                     },
              //                     onSuccess: () {
              //                       CommonMethods.showToast(
              //                           message: AppLocaleKey.paymentSuccess.tr());
              //                     }));
              //           }
              //         });
              //   },
              //   text: AppLocaleKey.payXSar.tr(
              //      args: [ordersModel.totalPrice ?? ""],
              //   ),
              // ),
              // SizedBox(
              //   height: 20,
              // ),
              Row(
                children: [
                  // Expanded(
                  //   child: CustomButton(
                  //     color: AppColor.secondAppColor,
                  //     text: AppLocaleKey.viewOrderDetails.tr(),
                  //     style: AppTextStyle.text14_600
                  //         .copyWith(color: AppColor.whiteColor, height: -0.5),
                  //     onPressed: () {
                  //       NavigatorMethods.pushNamed(context, OrderReviewDetailes.routeName,
                  //           arguments: ordersModel);
                  //     },
                  //   ),
                  // ),
                  // SizedBox(
                  //   width: 20,
                  // ),
                  Expanded(
                    child: CustomButton(
                      text: AppLocaleKey.backToHome.tr(),
                      onPressed: () async {
                        await LayoutMethouds.getdata();
                        NavigatorMethods.pushNamedAndRemoveUntil(context, LayoutScreen.routeName);
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
