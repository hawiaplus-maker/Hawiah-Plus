import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hawiah_client/core/custom_widgets/custom_image/custom_network_image.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/core/theme/app_text_style.dart';
import 'package:hawiah_client/core/utils/date_methods.dart';
import 'package:hawiah_client/features/order/presentation/screens/current-order-screen.dart';
import 'package:hawiah_client/features/order/presentation/screens/old-order-screen.dart';
import '../order-cubit/order-cubit.dart';
import '../order-cubit/order-state.dart';

class OrderTapList extends StatefulWidget {
  const OrderTapList({super.key, required this.orders, required this.isCurrent});
  final List<dynamic> orders;
  final bool isCurrent;

  @override
  State<OrderTapList> createState() => _OrderTapListState();
}

class _OrderTapListState extends State<OrderTapList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final cubit = context.read<OrderCubit>();
    // عندما يقترب المستخدم من نهاية القائمة
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 100 &&
        cubit.canLoadMore &&
        cubit.state is! OrderPaginationLoading) {
      cubit.getOrders(
        orderStatus: widget.isCurrent ? 0 : 1,
        page: cubit.currentPage + 1,
        isLoadMore: true,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<OrderCubit>();
    final orders = widget.isCurrent
        ? cubit.currentOrders ?? []
        : cubit.oldOrders ?? [];
    final isPaginating = cubit.state is OrderPaginationLoading;

    return ListView.builder(
      controller: _scrollController,
      itemCount: orders.length + (isPaginating ? 1 : 0),
      padding: EdgeInsets.only(left: 16, right: 16, bottom: 100.h),
      itemBuilder: (context, index) {
        if (index < orders.length) {
          final order = orders[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => widget.isCurrent
                      ? CurrentOrderScreen(ordersData: order)
                      : OldOrderScreen(ordersData: order),
                ),
              );
            },
            child: Card(
              margin: const EdgeInsets.symmetric(vertical: 10),
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CustomNetworkImage(
                          imageUrl: order.image ?? "",
                          height: 60.h,
                          width: 60.h,
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              order.product ?? '---',
                              style: AppTextStyle.text16_700,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              DateMethods.formatToFullData(
                                DateTime.tryParse(order.createdAt ?? "") ??
                                    DateTime.now(),
                              ),
                              style: AppTextStyle.text16_500.copyWith(
                                color: AppColor.darkGreyColor,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  AppLocaleKey.states.tr(),
                                  style: AppTextStyle.text16_600,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  context.locale.languageCode == 'ar'
                                      ? (order.status?['ar'] ?? '')
                                      : (order.status?['en'] ?? ''),
                                  style: AppTextStyle.text16_700.copyWith(
                                    color: gtOrderStatusColor(
                                        order.status?['en'] ?? ''),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          AppLocaleKey.orderDetails.tr(),
                          style: AppTextStyle.text16_700
                              .copyWith(color: AppColor.mainAppColor),
                        ),
                        const SizedBox(width: 5),
                        Icon(Icons.arrow_forward_ios,
                            color: AppColor.mainAppColor, size: 15),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          // Loader أسفل القائمة عند تحميل الصفحة التالية
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }

  Color gtOrderStatusColor(String status) {
    switch (status) {
      case "Delivered":
        return AppColor.mainAppColor;
      case "Processing":
        return AppColor.greenColor;
      case "New order":
        return AppColor.greyColor;
      default:
        return AppColor.blackColor;
    }
  }
}
