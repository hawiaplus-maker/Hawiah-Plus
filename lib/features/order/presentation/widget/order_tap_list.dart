import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hawiah_client/core/custom_widgets/custom_button.dart';
import 'package:hawiah_client/core/custom_widgets/custom_loading/custom_shimmer.dart';
import 'package:hawiah_client/core/images/app_images.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/core/theme/app_text_style.dart';
import 'package:hawiah_client/core/utils/date_methods.dart';
import 'package:hawiah_client/features/home/presentation/controllers/home-cubit/home-cubit.dart';
import 'package:hawiah_client/features/home/presentation/screens/all_categories_screen.dart';
import 'package:hawiah_client/features/order/presentation/model/orders_model.dart';
import 'package:hawiah_client/features/order/presentation/model/related_order_item.dart';
import 'package:hawiah_client/features/order/presentation/order-cubit/order-cubit.dart';
import 'package:hawiah_client/features/order/presentation/order-cubit/order-state.dart';
import 'package:hawiah_client/features/order/presentation/screens/order_details_screen.dart';
import 'package:hawiah_client/features/order/presentation/screens/related_order_details_screen.dart';
import 'package:hawiah_client/features/order/presentation/widget/order_card_widget.dart';

class OrderTapList extends StatefulWidget {
  const OrderTapList({super.key, required this.isCurrent});

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
    final canLoadMore =
        widget.isCurrent ? cubit.canLoadMoreCurrent : cubit.canLoadMoreOld;

    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 150 &&
        cubit.state is! OrderPaginationLoading &&
        canLoadMore) {
      cubit.getOrders(
        orderStatus: widget.isCurrent ? 0 : 1,
        page: widget.isCurrent
            ? cubit.currentPageCurrent + 1
            : cubit.currentPageOld + 1,
        isLoadMore: true,
      );
    }
  }

  DateTime? _itemDate(Object item) {
    if (item is SingleOrderData) {
      return DateTime.tryParse(item.createdAt ?? item.fromDate ?? '');
    }
    if (item is RelatedOrderItem) return item.date;
    return null;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderCubit, OrderState>(
      bloc: context.read<OrderCubit>(),
      builder: (context, _) {
        final cubit = context.watch<OrderCubit>();
        final orders = widget.isCurrent ? cubit.currentOrders : cubit.oldOrders;
        final relatedItems = cubit.relatedOrderItems.where(
          (item) => item.isCompleted != widget.isCurrent,
        );
        final items = <Object>[...orders, ...relatedItems]..sort((a, b) {
            final aDate = _itemDate(a);
            final bDate = _itemDate(b);
            if (aDate == null) return bDate == null ? 0 : 1;
            if (bDate == null) return -1;
            return bDate.compareTo(aDate);
          });
        final isLoading =
            widget.isCurrent ? cubit.isLoadingCurrent : cubit.isLoadingOld;
        final isPaginating = widget.isCurrent
            ? cubit.isLoadingMoreCurrent
            : cubit.isLoadingMoreOld;
        final homeCubit = HomeCubit.get(context);
        // لو لسه أول تحميل
        if (isLoading) {
          return Center(
              child: SingleChildScrollView(
            child: Column(
              children: List.generate(
                  6,
                  (index) => Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 3.5, horizontal: 16),
                        child: CustomShimmer(
                          height: 120,
                          width: double.infinity,
                          radius: 15,
                        ),
                      )),
            ),
          ));
        }

        if (items.isEmpty && !isPaginating) {
          return RefreshIndicator(
            color: AppColor.mainAppColor,
            onRefresh: () async {
              cubit.getOrders(
                orderStatus: widget.isCurrent ? 0 : 1,
                page: 1,
                isLoadMore: false,
              );
              await cubit.getRelatedOrderItems();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: _buildEmptyOrderWidget(context, homeCubit),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            cubit.getOrders(
              orderStatus: widget.isCurrent ? 0 : 1,
              page: 1,
              isLoadMore: false,
            );
            await cubit.getRelatedOrderItems();
          },
          child: ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(height: 7),
            controller: _scrollController,
            itemCount: items.length + (isPaginating ? 1 : 0),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemBuilder: (context, index) {
              if (index < items.length) {
                final item = items[index];
                if (item is RelatedOrderItem) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RelatedOrderDetailsScreen(item: item),
                        ),
                      );
                    },
                    child: RelatedOrderCard(item: item),
                  );
                }
                final order = item as SingleOrderData;
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OrderDetailsScreen(
                          orderId: order.id ?? 0,
                          isCurrent: widget.isCurrent,
                        ),
                      ),
                    );
                  },
                  child: OrderCardWidget(order: order),
                );
              } else {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: CustomShimmer(
                      height: 120,
                      width: double.infinity,
                      radius: 15,
                    ),
                  ),
                );
              }
            },
          ),
        );
      },
    );
  }

  Center _buildEmptyOrderWidget(BuildContext context, HomeCubit homeCubit) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            AppImages.noOrderImage,
            height: MediaQuery.of(context).size.height / 3,
          ),
          // Text(
          //   widget.isCurrent ? AppLocaleKey.noCurrentOrders.tr() : AppLocaleKey.noOldOrders.tr(),
          //   style: AppTextStyle.text16_700,
          // ),
          // const SizedBox(height: 10),
          CustomButton(
            width: MediaQuery.of(context).size.width / 2.5,
            radius: 5,
            text: "request_hawaia".tr(),
            style: AppTextStyle.text16M_600.copyWith(color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AllCategoriesScreen(
                    categories: homeCubit.categories,
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}

class RelatedOrderCard extends StatelessWidget {
  const RelatedOrderCard({super.key, required this.item});

  final RelatedOrderItem item;

  @override
  Widget build(BuildContext context) {
    final label = item.type == RelatedOrderItemType.cleaningContract
        ? AppLocaleKey.contract.tr()
        : AppLocaleKey.projects.tr();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColor.whiteColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColor.mainAppColor.withAlpha(40)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('#${item.referenceNumber}',
                    style: AppTextStyle.text16_500),
                Text(item.title, style: AppTextStyle.text14_400),
                if (item.subtitle.isNotEmpty)
                  Text(item.subtitle, style: AppTextStyle.text14_400),
                if (item.date != null)
                  Text(
                    DateMethods.formatToFullData(item.date!),
                    style: AppTextStyle.text14_400,
                  ),
                Text(label,
                    style: AppTextStyle.text14_400
                        .copyWith(color: AppColor.mainAppColor)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (item.status.isNotEmpty)
            Flexible(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColor.mainAppColor.withAlpha(50),
                  borderRadius: BorderRadius.circular(5),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Text(
                  item.status,
                  textAlign: TextAlign.center,
                  style: AppTextStyle.text14_400
                      .copyWith(color: AppColor.mainAppColor),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
