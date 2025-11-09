import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hawiah_client/core/custom_widgets/custom_app_bar.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/core/theme/app_text_style.dart';
import 'package:hawiah_client/features/order/presentation/widget/order_tap_list.dart';

import '../order-cubit/order-cubit.dart';
import '../order-cubit/order-state.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = OrderCubit();
        cubit.getOrders(orderStatus: 0);
        Future.delayed(const Duration(milliseconds: 300), () {
          cubit.getOrders(orderStatus: 1);
        });
        return cubit;
      },
      child: Scaffold(
        appBar: CustomAppBar(
          context,
          titleText: AppLocaleKey.orders.tr(),
        ),
        body: Column(
          children: [
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: AppColor.selectedLightBlueColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: TabBar(
                  controller: _tabController,
                  labelColor: AppColor.whiteColor,
                  unselectedLabelColor: AppColor.greyColor,
                  labelStyle: AppTextStyle.text20_700.copyWith(fontFamily: "DINNextLTArabic"),
                  indicator: BoxDecoration(
                    color: AppColor.mainAppColor,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  dividerHeight: 0,
                  indicatorSize: TabBarIndicatorSize.tab,
                  tabs: [
                    Tab(text: AppLocaleKey.current.tr()),
                    Tab(text: AppLocaleKey.end.tr()),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: BlocBuilder<OrderCubit, OrderState>(
                builder: (context, state) {
                  return TabBarView(
                    controller: _tabController,
                    physics: BouncingScrollPhysics(),
                    children: [
                      OrderTapList(
                        orders: context.read<OrderCubit>().currentOrders,
                        isCurrent: true,
                      ),
                      OrderTapList(
                        orders: context.read<OrderCubit>().oldOrders,
                        isCurrent: false,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
