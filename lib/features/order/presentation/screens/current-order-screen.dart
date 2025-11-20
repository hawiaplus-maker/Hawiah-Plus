import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hawiah_client/core/custom_widgets/custom_app_bar.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/theme/app_text_style.dart';
import 'package:hawiah_client/features/order/presentation/model/orders_model.dart';
import 'package:hawiah_client/features/order/presentation/widget/driver_card_widget.dart';
import 'package:hawiah_client/features/order/presentation/widget/hawiah_details.dart';
import 'package:hawiah_client/features/order/presentation/widget/invoice_and_contract_buttons_widget.dart';
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
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            AppLocaleKey.orderDetails.tr(),
            style: AppTextStyle.text16_700,
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            widget.ordersData.referenceNumber ?? "",
            style: AppTextStyle.text16_400,
          )
        ]),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15.0),
        child: Column(
          children: [
            SizedBox(height: 16.0),
            HawiahDetails(ordersDate: widget.ordersData),
            SizedBox(height: 16.0),
            ReOrderAndEmptyHawiahButtons(widget: widget),
            SizedBox(height: 16.0),
            DriverCardWidget(
              ordersData: widget.ordersData,
            ),
            SizedBox(height: 30.0),
            PricingSectionWidget(ordersData: widget.ordersData),
            SizedBox(height: 30.0),
            InvoiceAndContractButtonsWidget(ordersData: widget.ordersData),
            SizedBox(height: 30.0),
          ],
        ),
      ),
    );
  }
}
