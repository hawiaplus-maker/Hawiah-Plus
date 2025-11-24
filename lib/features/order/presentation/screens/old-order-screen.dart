import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hawiah_client/core/custom_widgets/custom_app_bar.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/theme/app_text_style.dart';
import 'package:hawiah_client/features/order/presentation/model/orders_model.dart';
import 'package:hawiah_client/features/order/presentation/widget/invoice_and_contract_buttons_widget.dart';
import 'package:hawiah_client/features/order/presentation/widget/old_order_driver_info_section.dart';
import 'package:hawiah_client/features/order/presentation/widget/old_order_header_section.dart';
import 'package:hawiah_client/features/order/presentation/widget/pricing_section_widget.dart';
import 'package:hawiah_client/features/order/presentation/widget/unloading_the_container_widget.dart';

class OldOrderScreen extends StatelessWidget {
  const OldOrderScreen({
    Key? key,
    required this.ordersData,
  }) : super(key: key);

  final SingleOrderData ordersData;

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
            ordersData.referenceNumber ?? "",
            style: AppTextStyle.text16_400,
          )
        ]),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OldOrderHeaderSection(data: ordersData),
            SizedBox(height: 16.h),
            OldDriverInfoSection(data: ordersData),
            SizedBox(height: 8.h),
            PricingSectionWidget(ordersData: ordersData),
            SizedBox(height: 30.h),
            UnloadingTheContainerWidget(
              orderId: ordersData.id ?? 0,
              serviceProviderId: ordersData.serviceProviderId ?? 0,
            ),
            SizedBox(height: 30.h),
            InvoiceAndContractButtonsWidget(ordersData: ordersData),
          ],
        ),
      ),
    );
  }
}
