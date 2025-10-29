import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hawiah_client/core/custom_widgets/custom_image/custom_network_image.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/core/theme/app_text_style.dart';
import 'package:hawiah_client/core/utils/date_methods.dart';
import 'package:hawiah_client/features/order/presentation/screens/current-order-screen.dart';
import 'package:hawiah_client/features/order/presentation/screens/old-order-screen.dart';

class OrderTapList extends StatelessWidget {
  const OrderTapList({super.key, required this.orders, required this.isCurrent});
  final List<dynamic> orders;
  final bool isCurrent;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: orders.length,
      padding: EdgeInsets.only(left: 16, right: 16, bottom: 100.h),
      itemBuilder: (context, index) {
        final order = orders[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => isCurrent
                    ? CurrentOrderScreen(ordersData: order)
                    : OldOrderScreen( ordersData: order,),
              ),
            );
          },
          child: Card(
            margin: EdgeInsets.symmetric(vertical: 10),
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(bottom: 16),
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
                              DateTime.tryParse(order.createdAt ?? "") ?? DateTime.now(),
                            ),
                            style: AppTextStyle.text16_500.copyWith(color: AppColor.darkGreyColor),
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
                                  color: gtOrderStatusColor(order.status?['en'] ?? ''),
                                ),
                              )
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
                        style: AppTextStyle.text16_700.copyWith(color: AppColor.mainAppColor),
                      ),
                      const SizedBox(width: 5),
                      Icon(Icons.arrow_forward_ios, color: AppColor.mainAppColor, size: 15),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
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
