import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hawiah_client/core/custom_widgets/custom_app_bar.dart';
import 'package:hawiah_client/core/custom_widgets/custom_image/custom_network_image.dart';
import 'package:hawiah_client/core/custom_widgets/custom_loading/custom_loading.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/core/theme/app_text_style.dart';
import 'package:hawiah_client/features/order/presentation/order-cubit/order-cubit.dart';
import 'package:hawiah_client/features/order/presentation/order-cubit/order-state.dart';
import 'package:hawiah_client/features/order/presentation/widget/driver_card_widget.dart';
import 'package:hawiah_client/features/order/presentation/widget/hawiah_details.dart';
import 'package:hawiah_client/features/order/presentation/widget/invoice_and_contract_buttons_widget.dart';
import 'package:hawiah_client/features/order/presentation/widget/old_order_driver_info_section.dart';
import 'package:hawiah_client/features/order/presentation/widget/old_order_header_section.dart';
import 'package:hawiah_client/features/order/presentation/widget/pricing_section_widget.dart';
import 'package:hawiah_client/features/order/presentation/widget/reorder_and_empty_hawiah_buttons_widget.dart';
import 'package:hawiah_client/features/order/presentation/widget/unloading_the_container_widget.dart';

class OrderDetailsScreen extends StatefulWidget {
  final int orderId;
  final bool isCurrent;

  const OrderDetailsScreen({Key? key, required this.orderId, required this.isCurrent})
      : super(key: key);

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderCubit, OrderState>(
      bloc: context.read<OrderCubit>()..singleOrder(orderId: widget.orderId),
      builder: (context, state) {
        Widget body;

        if (state is OrderLoading) {
          body = const Center(child: CustomLoading());
        } else if (state is CurrentOrderError) {
          body = Center(child: Text(state.message));
        } else if (state is CurrentOrderLoaded) {
          final ordersData = state.order;
          final driver = ordersData.data?.driver?.toString() ?? "";
          final driverMobile = ordersData.data?.driverMobile?.toString() ?? "";
          final support = ordersData.data?.support?.toString() ?? "";

          body = SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.isCurrent)
                  HawiahDetails(ordersDate: ordersData)
                else
                  OldOrderHeaderSection(data: ordersData),
                if (ordersData.data?.containerImages?.isNotEmpty ?? false) ...[
                  const SizedBox(height: 16),
                  Text(AppLocaleKey.imagesFromDeliveryLocation.tr(),
                      style: AppTextStyle.text16_700),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: AppColor.mainAppColor),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                        ),
                        itemCount: ordersData.data?.containerImages?.length ?? 0,
                        itemBuilder: (context, index) {
                          final image = ordersData.data?.containerImages?[index];
                          return CustomNetworkImage(
                              radius: 5, hasZoom: true, imageUrl: image?.url ?? "");
                        },
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                if (widget.isCurrent && (driver.isNotEmpty || driverMobile.isNotEmpty))
                  DriverCardWidget(ordersData: ordersData)
                // else if (!widget.isCurrent && ordersData.data?.orderStatus == 6)
                else if (!widget.isCurrent)
                  UnloadingTheContainerWidget(
                    orderId: ordersData.data?.id ?? 0,
                    serviceProviderId: ordersData.data?.serviceProviderId ?? 0,
                    serviceProviderRating: ordersData.data?.serviceProviderRating ?? 0,
                  ),
                const SizedBox(height: 8),
                PricingSectionWidget(ordersData: ordersData),
                const SizedBox(height: 30),
                InvoiceAndContractButtonsWidget(ordersData: ordersData),
                if (widget.isCurrent && support.isNotEmpty)
                  ReOrderAndEmptyHawiahButtons(support: support)
                else if (!widget.isCurrent)
                  OldDriverInfoSection(data: ordersData),
                const SizedBox(height: 30),
              ],
            ),
          );
        } else {
          body = Center(child: CustomLoading());
        }
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
                if (state is CurrentOrderLoaded)
                  Text(
                    state.order.data?.referenceNumber.toString() ?? "",
                    style: AppTextStyle.text16_400,
                  ),
              ],
            ),
          ),
          body: body,
        );
      },
    );
  }
}
