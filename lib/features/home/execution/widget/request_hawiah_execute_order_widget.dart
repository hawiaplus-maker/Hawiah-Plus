import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hawiah_client/core/custom_widgets/custom_button.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/core/utils/navigator_methods.dart';
import 'package:hawiah_client/features/home/execution/screen/order_review_detailes.dart';
import 'package:hawiah_client/features/home/execution/screen/request_hawia_screen.dart';
import 'package:hawiah_client/features/order/presentation/order-cubit/order-cubit.dart';

import '../../presentation/controllers/home-cubit/home-cubit.dart';

class RequestHawiahExecuteOrderWidget extends StatelessWidget {
  const RequestHawiahExecuteOrderWidget({
    super.key,
    required this.args,
  });

  final RequestHawiahScreenArgs args;

  @override
  Widget build(BuildContext context) {
    final homeCubit = context.read<HomeCubit>();
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomButton(
          text: AppLocaleKey.executeorder.tr(),
          color: homeCubit.rangeStart == null ? AppColor.lightGreyColor : AppColor.mainAppColor,
          onPressed: () {
            final orderCubit = context.read<OrderCubit>();
            if (homeCubit.rangeStart == null) {
              null;
            } else {
              orderCubit.createOrder(
                  serviceProviderId: args.serviceProviderId,
                  priceId: args.nearbyServiceProviderModel.id!,
                  addressId: args.addressId,
                  fromDate:
                      DateFormat('yyyy-MM-dd', 'en').format(homeCubit.rangeStart ?? DateTime.now()),
                  fromTime: DateFormat('HH:mm', 'en').format(homeCubit.fromTime ?? DateTime.now()),
                  onSuccess: (order) {
                    homeCubit.selectedIndex = -1;
                    NavigatorMethods.pushNamed(context, OrderReviewDetailes.routeName,
                        arguments: order);
                  });
            }
          },
        ),
      ),
    );
  }
}
