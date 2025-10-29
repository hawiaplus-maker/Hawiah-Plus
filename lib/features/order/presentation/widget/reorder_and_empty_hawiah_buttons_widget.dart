import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hawiah_client/core/custom_widgets/custom_button.dart';
import 'package:hawiah_client/core/images/app_images.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/core/theme/app_text_style.dart';
import 'package:hawiah_client/features/order/presentation/screens/current-order-screen.dart';
import 'package:hawiah_client/features/order/presentation/screens/reorder_hawiah-screen.dart';

class ReOrderAndEmptyHawiahButtons extends StatelessWidget {
  const ReOrderAndEmptyHawiahButtons({
    super.key,
    required this.widget,
  });

  final CurrentOrderScreen widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Flexible(
            child: CustomButton(
              prefixIcon: Image.asset(
                AppImages.refreshCw,
                height: 20.0,
                width: 20.0,
                color: Colors.white,
              ),
              color: AppColor.mainAppColor,
              text: AppLocaleKey.reOrder.tr(),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReOrderHawiahScreen(
                      orderId: widget.ordersData.id ?? 0,
                      duration: widget.ordersData.duration ?? 0,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 30),
          Flexible(
            child: CustomButton(
              color: Colors.transparent,
              prefixIcon: Image.asset(
                AppImages.trendDown,
                height: 20.0,
                width: 20.0,
                color: Colors.red,
              ),
              child: Text(
                AppLocaleKey.emptytheContainer.tr(),
                style: AppTextStyle.text16_600.copyWith(
                  color: AppColor.redColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
