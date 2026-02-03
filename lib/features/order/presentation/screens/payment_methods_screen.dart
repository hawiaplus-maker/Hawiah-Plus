import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hawiah_client/core/custom_widgets/api_response_widget.dart';
import 'package:hawiah_client/core/custom_widgets/custom_app_bar.dart';
import 'package:hawiah_client/core/custom_widgets/custom_button.dart';
import 'package:hawiah_client/core/images/app_images.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/core/theme/app_text_style.dart';
import 'package:hawiah_client/core/utils/common_methods.dart';
import 'package:hawiah_client/core/utils/navigator_methods.dart';
import 'package:hawiah_client/features/order/presentation/model/payment_model.dart';
import 'package:hawiah_client/features/order/presentation/order-cubit/order-cubit.dart';
import 'package:hawiah_client/features/order/presentation/order-cubit/order-state.dart';
import 'package:hawiah_client/features/order/presentation/screens/payment_web_view.dart';

class PaymentMethodsArgs {
  final int orderId;
  final String totalPrice;

  PaymentMethodsArgs({required this.orderId, required this.totalPrice});
}

class PaymentMethodsScreen extends StatefulWidget {
  static const String routeName = 'PaymentMethodsScreen';
  final PaymentMethodsArgs args;
  const PaymentMethodsScreen({super.key, required this.args});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  // سنستخدم الـ index لتخزين العنصر المختار لسهولة الوصول للرسوم (fees)
  int selectedPaymentIndex = -1;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrderCubit()..getPaymentMethodsList(),
      child: Scaffold(
        appBar: CustomAppBar(
          context,
          titleText: AppLocaleKey.paymentMethods.tr(),
        ),
        body: BlocBuilder<OrderCubit, OrderState>(
          builder: (context, state) {
            final cubit = context.read<OrderCubit>();

            // --- منطق حساب السعر ---
            double basePrice = double.tryParse(widget.args.totalPrice) ?? 0.0;
            double fees = 0.0;
            double totalPriceWithFees = basePrice;

            if (selectedPaymentIndex != -1) {
              // استخراج الرسوم من العنصر المختار وتحويلها لرقم
              var selectedMethod = cubit.paymentMethodsList[selectedPaymentIndex];
              fees = double.tryParse(selectedMethod.fees.toString()) ?? 0.0;
              totalPriceWithFees = basePrice + fees;
            }
            // -----------------------

            return ApiResponseWidget(
              apiResponse: cubit.paymentMethodsListResponse,
              onReload: () => cubit.getPaymentMethodsList(),
              isEmpty: cubit.paymentMethodsList.isEmpty,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColor.mainAppColor),
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            children: [
                              Text(
                                "${AppLocaleKey.totalPrice.tr()} ${AppLocaleKey.sar.tr(args: [
                                      basePrice.toStringAsFixed(2)
                                    ])}",
                                style:
                                    AppTextStyle.text18_600.copyWith(color: AppColor.mainAppColor),
                              ),
                              if (fees > 0) // إظهار قيمة الرسوم إذا وجدت
                                Text(
                                  "( + ${AppLocaleKey.sar.tr(args: [fees.toStringAsFixed(2)])}  )",
                                  style: AppTextStyle.text14_400.copyWith(color: Colors.grey),
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(AppLocaleKey.choosePaymentMethod.tr(), style: AppTextStyle.text18_600),
                      const SizedBox(height: 20),
                      paymentListView(cubit.paymentMethodsList, basePrice),
                      const SizedBox(height: 20),
                      if (selectedPaymentIndex != -1) ...[
                        if (cubit.paymentMethodsList[selectedPaymentIndex].name == 'Tabby') ...[
                          Image.asset(
                            AppImages.tabbyPayLogoImage,
                            width: MediaQuery.of(context).size.width * 0.2,
                          ),
                          const SizedBox(height: 10),
                          RowTextImageWidget(
                            text: AppLocaleKey.tabyHeadline1.tr(),
                          ),
                          const SizedBox(height: 10),
                          RowTextImageWidget(
                            text: AppLocaleKey.tabyHeadline2.tr(),
                          ),
                          const SizedBox(height: 10),
                          RowTextImageWidget(
                            text: AppLocaleKey.tabyHeadline3.tr(),
                          ),
                          const SizedBox(height: 10),
                          RowTextImageWidget(
                            text: AppLocaleKey.tabySubtitle1.tr(),
                          ),
                          const SizedBox(height: 10),
                          RowTextImageWidget(
                            text: AppLocaleKey.tabySubtitle2.tr(),
                          ),
                          const SizedBox(height: 10),
                          RowTextImageWidget(
                            text: AppLocaleKey.tabySubtitle3.tr(),
                          ),
                        ],
                        if (cubit.paymentMethodsList[selectedPaymentIndex].name == 'Tamara') ...[
                          Image.asset(
                            AppImages.tamaraPayLogoImage,
                            width: MediaQuery.of(context).size.width * 0.2,
                          ),
                          const SizedBox(height: 10),
                          RowTextImageWidget(
                            text: AppLocaleKey.tamaraHeadline1.tr(),
                          ),
                          const SizedBox(height: 10),
                          RowTextImageWidget(
                            text: AppLocaleKey.tamaraHeadline2.tr(),
                          ),
                          const SizedBox(height: 10),
                          RowTextImageWidget(
                            text: AppLocaleKey.tamaraSubtitle1.tr(),
                          ),
                          const SizedBox(height: 10),
                          RowTextImageWidget(
                            text: AppLocaleKey.tamaraSubtitle2.tr(),
                          ),
                          const SizedBox(height: 10),
                          RowTextImageWidget(
                            text: AppLocaleKey.tamaraSubtitle3.tr(),
                          ),
                        ]
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        bottomNavigationBar: Builder(
          // استخدام Builder للوصول للـ context الصحيح داخل الـ Provider
          builder: (context) => SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: CustomButton(
                text: AppLocaleKey.payNow.tr(),
                onPressed: () {
                  if (selectedPaymentIndex == -1) {
                    Fluttertoast.showToast(msg: "الرجاء اختيار طريقة دفع");
                    return;
                  }

                  final cubit = context.read<OrderCubit>();
                  final methodId = cubit.paymentMethodsList[selectedPaymentIndex].id ?? 0;

                  cubit.getPaymentLink(
                    orderId: widget.args.orderId,
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
                            onFailed: () =>
                                Fluttertoast.showToast(msg: AppLocaleKey.paymentFailed.tr()),
                            onSuccess: () =>
                                Fluttertoast.showToast(msg: AppLocaleKey.paymentSuccess.tr()),
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget paymentListView(List<PaymentMethoudModel> paymentMethods, double basePrice) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: paymentMethods.length,
      itemBuilder: (context, index) {
        final paymentMethod = paymentMethods[index];
        double totalPriceWithFees =
            basePrice + ((double.tryParse(paymentMethod.fees.toString()) ?? 0));
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedPaymentIndex = index; // تخزين الـ index
            });
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            height: 80,
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
            child: Row(
              children: [
                Radio<int>(
                  activeColor: AppColor.mainAppColor,
                  value: index,
                  groupValue: selectedPaymentIndex,
                  onChanged: (value) {
                    setState(() {
                      selectedPaymentIndex = value!;
                    });
                  },
                ),
                paymentImagByName(paymentMethod.name ?? '', context),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    AppLocaleKey.payXSar.tr(args: [totalPriceWithFees.toStringAsFixed(2)]),
                    style: AppTextStyle.text14_600.copyWith(color: AppColor.mainAppColor),
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),
          ),
        );
      },
    );
  }
}

class RowTextImageWidget extends StatelessWidget {
  final String text;

  const RowTextImageWidget({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CircleAvatar(
          radius: 10,
          backgroundColor: AppColor.mainAppColor,
          child: Icon(Icons.check, color: Colors.white, size: 15),
        ),
        const SizedBox(width: 10),
        Text(text, style: AppTextStyle.text16_400),
      ],
    );
  }
}

Widget paymentImagByName(String name, BuildContext context) {
  switch (name) {
    case 'Tabby':
      return Image.asset(
        AppImages.tabbyPayLogoImage,
        width: MediaQuery.of(context).size.width * 0.25,
      );
    case 'Tamara':
      return Image.asset(
        AppImages.tamaraPayLogoImage,
        width: MediaQuery.of(context).size.width * 0.25,
      );
    case 'Visa-MIGS-online':
      return Image.asset(
        AppImages.visaPayImage,
        width: MediaQuery.of(context).size.width * 0.25,
      );
    case 'MIGS-online':
      return Image.asset(
        AppImages.madaPayLogoImage,
        width: MediaQuery.of(context).size.width * 0.25,
      );
    case 'MIGS-online (Apple Pay)':
      return Image.asset(
        AppImages.applePayImage,
        width: MediaQuery.of(context).size.width * 0.25,
      );
    default:
      return Text(name, style: AppTextStyle.text18_600);
  }
}
