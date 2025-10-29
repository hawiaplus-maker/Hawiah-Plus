import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hawiah_client/core/custom_widgets/custom_app_bar.dart';
import 'package:hawiah_client/core/custom_widgets/custom_button.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/utils/navigator_methods.dart';
import 'package:hawiah_client/features/layout/presentation/screens/layout-screen.dart';
import 'package:hawiah_client/features/order/presentation/order-cubit/order-cubit.dart';
//!الشاشة دي مش مستخدمة يا أبوعمو
class PaymentScreenArgs {
  final int catigoryId;
  final int serviceProviderId;
  final int priceId;
  final int addressId;
  final String fromDate;
  final double totalPrice;
  final double price;
  final double vatValue;

  PaymentScreenArgs(
      {required this.catigoryId,
      required this.serviceProviderId,
      required this.priceId,
      required this.addressId,
      required this.fromDate,
      required this.totalPrice,
      required this.price,
      required this.vatValue});
}

class PaymentScreen extends StatefulWidget {
  static const routeName = '/payment-screen';
  final PaymentScreenArgs args;
  const PaymentScreen({Key? key, required this.args}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String? selectedPaymentOption;
  @override
  void initState() {
    super.initState();

    selectedPaymentOption = "دفع إلكتروني";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context,
        titleText: AppLocaleKey.paymentMethod.tr(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Order Summary Section
            Container(
              decoration: BoxDecoration(
                color: Color(0xffFCFCFC),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  buildSummaryRow(AppLocaleKey.askPrice.tr(),
                      AppLocaleKey.sar.tr(args: [widget.args.price.toString()]),
                      isBold: false, fontSize: 13),
                  buildSummaryRow(AppLocaleKey.valueAdded.tr(),
                      AppLocaleKey.sar.tr(args: [widget.args.vatValue.toString()]),
                      isBold: false, fontSize: 13),
                  Divider(),
                  buildSummaryRow(AppLocaleKey.netTotal.tr(),
                      AppLocaleKey.sar.tr(args: [widget.args.totalPrice.toString()]),
                      isBold: true, fontSize: 14),
                ],
              ),
            ),
            SizedBox(height: 24),
            // Payment Methods Section
            Text(
              AppLocaleKey.payby.tr(),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            buildPaymentOption(
              context,
              title: AppLocaleKey.electronicpayment.tr(),
              icon: Row(
                children: [
                  Image.asset('assets/icons/mastercard_logo.png', height: 24),
                  SizedBox(width: 8),
                  Image.asset('assets/icons/visa_logo.png', height: 24),
                ],
              ),
            ),
            buildPaymentOption(
              context,
              title: AppLocaleKey.howfarisit.tr(),
              icon: Image.asset('assets/icons/mada_payment_logo.png', height: 24),
            ),
            buildPaymentOption(
              context,
              title: AppLocaleKey.applepay.tr(),
              icon: Image.asset('assets/icons/apple_pay_logo.png', height: 24),
            ),

            // Continue Button
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomButton(
            text: "continue_payment".tr(),
            onPressed: () {
              context.read<OrderCubit>().createOrder(
                  serviceProviderId: widget.args.serviceProviderId,
                  priceId: widget.args.priceId,
                  addressId: widget.args.addressId,
                  fromDate: widget.args.fromDate,
                  onSuccess: () {
                    NavigatorMethods.pushReplacementNamed(
                      context,
                      LayoutScreen.routeName,
                    );
                  });
            }),
      ),
    );
  }

  Widget buildSummaryRow(String title, String value, {bool isBold = false, double fontSize = 16}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPaymentOption(
    BuildContext context, {
    required String title,
    required Widget icon,
  }) {
    final isSelected = selectedPaymentOption == title;

    return GestureDetector(
      onTap: () => setState(() => selectedPaymentOption = title),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green.shade50 : Colors.white,
          border: Border.all(
            color: isSelected ? Colors.green : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: Color(0xff5FFF9F),
                size: 24,
              ),
            SizedBox(width: isSelected ? 16 : 40),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            Spacer(),
            icon,
          ],
        ),
      ),
    );
  }
}
