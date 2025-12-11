import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hawiah_client/core/custom_widgets/custom_app_bar.dart';
import 'package:hawiah_client/core/custom_widgets/custom_loading/custom_loading.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/theme/app_text_style.dart';
import 'package:hawiah_client/features/order/presentation/order-cubit/order-cubit.dart';
import 'package:hawiah_client/features/order/presentation/order-cubit/order-state.dart';
import 'package:hawiah_client/features/order/presentation/widget/driver_card_widget.dart';
import 'package:hawiah_client/features/order/presentation/widget/hawiah_details.dart';
import 'package:hawiah_client/features/order/presentation/widget/invoice_and_contract_buttons_widget.dart';
import 'package:hawiah_client/features/order/presentation/widget/pricing_section_widget.dart';
import 'package:hawiah_client/features/order/presentation/widget/reorder_and_empty_hawiah_buttons_widget.dart';

class CurrentOrderScreen extends StatefulWidget {
  final int orderId;
  const CurrentOrderScreen({Key? key, required this.orderId}) : super(key: key);

  @override
  State<CurrentOrderScreen> createState() => _CurrentOrderScreenState();
}

class _CurrentOrderScreenState extends State<CurrentOrderScreen> {
  @override
  void initState() {
    super.initState();
    context.read<OrderCubit>().singleOrder(orderId: widget.orderId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: [
            Text(AppLocaleKey.orderDetails.tr(), style: AppTextStyle.text16_700),
            const SizedBox(height: 5),
            BlocBuilder<OrderCubit, OrderState>(
              builder: (context, state) {
                if (state is CurrentOrderLoaded) {
                  return Text(
                    state.order.data?.referenceNumber.toString() ?? "",
                    style: AppTextStyle.text16_400,
                  );
                }
                return const SizedBox();
              },
            ),
          ],
        ),
      ),
      body: BlocBuilder<OrderCubit, OrderState>(
        builder: (context, state) {
          if (state is OrderLoading) return const Center(child: CustomLoading());
          if (state is CurrentOrderError) return Center(child: Text(state.message));
          if (state is CurrentOrderLoaded) {
            final ordersData = state.order;
            final driver = ordersData.data?.driver?.toString() ?? "";
            final driverMobile = ordersData.data?.driverMobile?.toString() ?? "";
            final support = ordersData.data?.support?.toString() ?? "";

            return SingleChildScrollView(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  HawiahDetails(ordersDate: ordersData),
                  const SizedBox(height: 16),
                  support.isNotEmpty
                      ? ReOrderAndEmptyHawiahButtons(support: support)
                      : const SizedBox(),
                  const SizedBox(height: 16),
                  (driver.isNotEmpty || driverMobile.isNotEmpty)
                      ? DriverCardWidget(ordersData: ordersData)
                      : const SizedBox(),
                  const SizedBox(height: 30),
                  PricingSectionWidget(ordersData: ordersData),
                  const SizedBox(height: 30),
                  InvoiceAndContractButtonsWidget(ordersData: ordersData),
                ],
              ),
            );
          }

          // fallback
          return const Center(child: Text("حدث خطأ غير متوقع"));
        },
      ),
    );
  }
}
