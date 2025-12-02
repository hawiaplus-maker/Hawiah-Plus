import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hawiah_client/core/custom_widgets/custom_button.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
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
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomButton(
          text: AppLocaleKey.executeorder.tr(),
          onPressed: () {
            final homeCubit = context.read<HomeCubit>();
            final orderCubit = context.read<OrderCubit>();

            orderCubit.createOrder(
                serviceProviderId: args.serviceProviderId,
                priceId: args.nearbyServiceProviderModel.id!,
                addressId: args.address.id!,
                fromDate:
                    DateFormat('yyyy-MM-dd', 'en').format(homeCubit.rangeStart ?? DateTime.now()),
                onSuccess: (order) {
                  homeCubit.selectedIndex = -1;
                  NavigatorMethods.pushNamed(context, OrderReviewDetailes.routeName,
                      arguments: order);
                });
          },
        ),
      ),
    );
  }
}
