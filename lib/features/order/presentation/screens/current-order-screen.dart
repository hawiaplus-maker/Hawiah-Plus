import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hawiah_client/core/custom_widgets/custom_app_bar.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/features/order/presentation/model/orders_model.dart';
import 'package:hawiah_client/features/order/presentation/widget/driver_and_support_contact_buttons_widget.dart';
import 'package:hawiah_client/features/order/presentation/widget/driver_card_widget.dart';
import 'package:hawiah_client/features/order/presentation/widget/hawiah_details.dart';
import 'package:hawiah_client/features/order/presentation/widget/invoice_and_contract_buttons_widget.dart';
import 'package:hawiah_client/features/order/presentation/widget/payment_button.dart';
import 'package:hawiah_client/features/order/presentation/widget/pricing_section_widget.dart';
import 'package:hawiah_client/features/order/presentation/widget/reorder_and_empty_hawiah_buttons_widget.dart';

class CurrentOrderScreen extends StatefulWidget {
  const CurrentOrderScreen({
    Key? key,
    required this.ordersData,
  }) : super(key: key);
  final Data ordersData;

  @override
  State<CurrentOrderScreen> createState() => _CurrentOrderScreenState();
}

class _CurrentOrderScreenState extends State<CurrentOrderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context,
        titleText: AppLocaleKey.orderDetails.tr(),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HawiahDetails(ordersDate: widget.ordersData),
            SizedBox(height: 16.0),
            ReOrderAndEmptyHawiahButtons(widget: widget),
            SizedBox(height: 16.0),
            DriverCardWidget(
              ordersData: widget.ordersData,
            ),
            SizedBox(height: 16.0),
            DriverAndSupportContactButtons(widget: widget),
            SizedBox(height: 60.0),
            PricingSectionWidget(ordersData: widget.ordersData),
            SizedBox(height: 30),
            PaymentButtonWidget(
              ordersData: widget.ordersData,
            ),
            SizedBox(height: 30.0),
            InvoiceAndContractButtonsWidget(ordersData: widget.ordersData),
            SizedBox(height: 30.0),
          ],
        ),
      ),
    );
  }
}
