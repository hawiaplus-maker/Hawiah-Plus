import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hawiah_client/core/custom_widgets/api_response_widget.dart';
import 'package:hawiah_client/core/custom_widgets/custom_app_bar.dart';
import 'package:hawiah_client/core/custom_widgets/custom_button.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/core/theme/app_text_style.dart';
import 'package:hawiah_client/core/utils/common_methods.dart';
import 'package:hawiah_client/core/utils/navigator_methods.dart';
import 'package:hawiah_client/features/home/execution/widget/coupone_widget.dart';
import 'package:hawiah_client/features/home/execution/widget/order_detailes_widget.dart';
import 'package:hawiah_client/features/home/execution/widget/order_details_pricing_section.dart';
import 'package:hawiah_client/features/layout/presentation/layout_methouds.dart';
import 'package:hawiah_client/features/layout/presentation/screens/layout-screen.dart';
import 'package:hawiah_client/features/order/presentation/model/order_details_model.dart';
import 'package:hawiah_client/features/order/presentation/model/payment_model.dart';
import 'package:hawiah_client/features/order/presentation/order-cubit/order-cubit.dart';
import 'package:hawiah_client/features/order/presentation/order-cubit/order-state.dart';
import 'package:hawiah_client/features/order/presentation/screens/payment_methods_screen.dart';
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
  double? fees;
  double? totalWithFees;
  String? copone;
  bool isPaymentSuccess = false;
  bool showBackToHome = false;
  int selectedPaymentIndex = -1;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrderCubit()..getPaymentMethodsList(),
      child: BlocBuilder<OrderCubit, OrderState>(
        builder: (context, state) {
          final cubit = context.read<OrderCubit>();
          double basePrice = double.tryParse(discountValue != null
                  ? (priceAfterDiscount ?? '0')
                  : (widget.ordersModel.totalPrice ?? '0')) ??
              0.0;

          // 2. Add the fees (fees is updated in the paymentMethodSection)
          double finalAmount = basePrice + (fees ?? 0.0);

          return ApiResponseWidget(
            apiResponse: cubit.paymentMethodsListResponse,
            onReload: () => cubit.getPaymentMethodsList(),
            isEmpty: cubit.paymentMethodsList.isEmpty,
            child: PopScope(
              canPop: false,
              onPopInvokedWithResult: (didPop, result) {
                if (didPop) return;
                setState(() {
                  showBackToHome = true;
                });
              },
              child: Scaffold(
                appBar: CustomAppBar(
                  context,
                  titleText: AppLocaleKey.orderSummary.tr(),
                  leading: SizedBox(),
                ),
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
                      paymentMethodSection(cubit.paymentMethodsList),
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
                            if (selectedPaymentIndex == -1) {
                              Fluttertoast.showToast(msg: "الرجاء اختيار طريقة دفع");
                              return;
                            }

                            final cubit = context.read<OrderCubit>();
                            final methodId = cubit.paymentMethodsList[selectedPaymentIndex].id ?? 0;

                            cubit.getPaymentLink(
                              orderId: widget.ordersModel.id!,
                              selectedPaymentMethod: methodId, // نرسل الـ ID للسيرفر
                              onSuccess: (url) {
                                if (url.contains('already exists')) {
                                  CommonMethods.showError(message: url);
                                } else {
                                  NavigatorMethods.pushNamed(
                                    context,
                                    CustomPaymentWebViewScreen.routeName,
                                    arguments: PaymentArgs(
                                      url: url,
                                      onFailed: () => Fluttertoast.showToast(
                                          msg: AppLocaleKey.paymentFailed.tr()),
                                      onSuccess: () => Fluttertoast.showToast(
                                          msg: AppLocaleKey.paymentSuccess.tr()),
                                    ),
                                  );
                                }
                              },
                            );
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
                                      args: [finalAmount.toStringAsFixed(2)],
                                    ),
                                    style: AppTextStyle.text18_700
                                        .copyWith(color: AppColor.whiteColor),
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
                        height: 15,
                      ),
                      if (showBackToHome)
                        CustomButton(
                          text: AppLocaleKey.backToHome.tr(),
                          onPressed: () async {
                            await LayoutMethouds.getdata();
                            NavigatorMethods.pushNamedAndRemoveUntil(
                                context, LayoutScreen.routeName);
                          },
                        ),
                      SizedBox(
                        height: 15,
                      ),
                    ]),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget paymentMethodSection(List<PaymentMethoudModel> paymentMethods) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColor.lightGreyColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppLocaleKey.paymentMethods.tr(),
            style: AppTextStyle.text16_700,
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 70,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: paymentMethods.length,
              itemBuilder: (context, index) {
                final paymentMethod = paymentMethods[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedPaymentIndex = index; // تخزين الـ index
                      fees = paymentMethod.fees;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        width: 2,
                        color: selectedPaymentIndex == index
                            ? AppColor.lightMainAppColor
                            : AppColor.lightGreyColor.withAlpha(50),
                      ),
                    ),
                    child: paymentImagByName(paymentMethod.name ?? '', context),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
