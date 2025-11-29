import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hawiah_client/core/custom_widgets/api_response_widget.dart';
import 'package:hawiah_client/core/custom_widgets/custom_app_bar.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/core/theme/app_text_style.dart';
import 'package:hawiah_client/features/home/execution/widget/nearby_card_widget.dart';
import 'package:hawiah_client/features/home/presentation/model/show_categories_model.dart';
import 'package:hawiah_client/features/location/presentation/model/address_model.dart';
import 'package:hawiah_client/features/order/presentation/order-cubit/order-cubit.dart';
import 'package:hawiah_client/features/order/presentation/order-cubit/order-state.dart';

class NearbyServiceProviderArguments {
  final int catigoryId;
  final int serviceProviderId;
  final AddressModel address;
  final ShowCategoriesModel showCategoriesModel;
  NearbyServiceProviderArguments({
    required this.catigoryId,
    required this.serviceProviderId,
    required this.address,
    required this.showCategoriesModel,
  });
}

class NearbyServiceProviderScreen extends StatelessWidget {
  static const routeName = '/nearby-service-provider';

  final NearbyServiceProviderArguments args;
  const NearbyServiceProviderScreen({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrderCubit()
        ..getNearbyProviders(
          serviceProviderId: args.serviceProviderId,
          addressId: args.address.id!,
          onBadRequest: () {
            Navigator.pop(context);
          },
        ),
      child: Scaffold(
        appBar: CustomAppBar(
          context,
          titleText: AppLocaleKey.serviceProviders.tr(),
        ),
        body: BlocBuilder<OrderCubit, OrderState>(
          builder: (context, state) {
            final providers = context.read<OrderCubit>();
            return ApiResponseWidget(
              apiResponse: providers.nearbyServiceProviderResponse,
              onReload: () => providers.getNearbyProviders(
                  serviceProviderId: args.serviceProviderId, addressId: args.address.id!),
              isEmpty: providers.nearbyServiceProvider.isEmpty,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocaleKey.chooseServiceProvider.tr(),
                      style: AppTextStyle.text18_700,
                    ),
                    Text(
                      AppLocaleKey.spDiscription.tr(),
                      style: AppTextStyle.text16_400.copyWith(color: AppColor.greyTextColor),
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount: providers.nearbyServiceProvider.length,
                          itemBuilder: (context, index) => NearbyCardWidget(
                                providers: providers.nearbyServiceProvider[index],
                                index: index,
                                args: args,
                              )),
                    ),
                    // SafeArea(
                    //   bottom: true,
                    //   child: Container(
                    //     decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(10),
                    //       color: AppColor.redColor.withAlpha(35),
                    //     ),
                    //     child: Padding(
                    //       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    //       child: Text(
                    //         AppLocaleKey.spHint.tr(),
                    //         style: AppTextStyle.text14_400.copyWith(
                    //           color: AppColor.redColor,
                    //         ),
                    //         textAlign: TextAlign.center,
                    //       ),
                    //     ),
                    //   ),
                    // )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
